##NOTE: This code is partitioned into a section for the 2016-2022 data. and a section for the 
##2013-2015 data. This was necessary because of slightly different column-naming schemes.


##2016-2022:
#Designate wanted columns for 2016-2022 (faster compared to importing entire file)
wanted_cols <- c("Covered_Recipient_Profile_ID", 
                 "Total_Amount_of_Payment_USDollars",
                 "Nature_of_Payment_or_Transfer_of_Value",
                 "Covered_Recipient_Specialty_1")

#Import data for 2016-2022                                  
files <- paste0("C:/Ahmed's Stuff/ResearchStuff/Open Payments Data/General_Payments_", seq(2016, 2022, 1), ".csv")

#Read files
x <- lapply(files, fread, select = wanted_cols, nThread = 14)

#Bind them together into a single data.table
x <- rbindlist(x)

#Clean names to make them easier to reference
x <- clean_names(x)

#Rename
x <- x %>% rename(any_of(c(
  id = "covered_recipient_profile_id",
  specialty = "covered_recipient_specialty_1",
  amount = "total_amount_of_payment_us_dollars",
  payment_nature = "nature_of_payment_or_transfer_of_value"
)))

##2013-2015:
#Designate wanted columns for 2013-2015 (faster compared to importing entire file)
wanted_cols <- c("Physician_Profile_ID", 
                 "Total_Amount_of_Payment_USDollars",
                 "Nature_of_Payment_or_Transfer_of_Value",
                 "Physician_Specialty")

#Import data for 2013-2015                                
files <- paste0("C:/Ahmed's Stuff/ResearchStuff/Open Payments Data/General_Payments_", seq(2013, 2015, 1), ".csv")

#Read files (save into "x_old" to denote that they belong to 2013-2015 rather than newer years)
x_old <- lapply(files, fread, select = wanted_cols, nThread = 14)

#Bind them together into a single data.table
x_old <- rbindlist(x_old)

#Clean names to make them easier to reference
x_old <- clean_names(x_old)

#Rename
x_old <- x_old %>%
  rename(any_of(c(
    id = "physician_profile_id",
    specialty = "physician_specialty",
    amount = "total_amount_of_payment_us_dollars",
    year = "program_year"
  )))


#Bind the 2016-2022 and the 2013-2015 into a single data.table
x <- bind_rows(x, x_old)

#Set aside types of payments deemed irrelevant for the analysis & filter to MDs/DOs
x <- x %>% filter(payment_nature != "Royalty or License" & 
                    payment_nature != "Acquisitions" &
                    payment_nature != "Debt Forgiveness" &
                    payment_nature != "Debt forgiveness" &
                    payment_nature != "Long-term medical supply or device loan" &
                    payment_nature != "Long term medical supply or device loan" &
                    payment_nature != "Current or prospective ownership or investment interest" &
                    stri_detect_fixed(specialty, "Allopathic & Osteopathic Physicians"))


#Map specialties
x <- left_join(x, specialties, by = "specialty")

#Now, save the relevant data into "top"
top <- x %>%
  group_by(sp, sp_full, id) %>% #Group by ID to identify individuals
  summarise(amount = sum(amount)) %>% #Sum up the amounts they've received from 2013-2022
  group_by(sp, sp_full) %>% #Group by specialty and get top 10 per specialty
  summarise(
    top0.1avg = sum(amount[rank(desc(amount)) <= round(0.001 * n())])/(0.001 * n()), #Get the amount by the top 0.1% (top 1 in 1000)
    median = quantile(amount, 0.5), #Get the amount of the median MD/DO
    n = n()
  )

#Save the file
qsave(top, "Top earners data.RData")

