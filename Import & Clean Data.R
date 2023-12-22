##Designate wanted columns (this will speed up file importing compared to importing all columns)
##Column names in 2016+ files are slightly different from those in 2013-2015
#2016+ columns
wanted_cols_2016plus <- c("Total_Amount_of_Payment_USDollars", "Number_of_Payments_Included_in_Total_Amount",
                 "Name_of_Drug_or_Biological_or_Device_or_Medical_Supply_1",
                 "Indicate_Drug_or_Biological_or_Device_or_Medical_Supply_1", "Covered_Recipient_Specialty_1",
                 "Program_Year", "Nature_of_Payment_or_Transfer_of_Value",
                 "Associated_Drug_or_Biological_NDC_1", "Associated_Device_or_Medical_Supply_PDI_1")
#2013-2015 columns
wanted_cols_2013_to_2015 <- c("Total_Amount_of_Payment_USDollars", "Number_of_Payments_Included_in_Total_Amount",
                 "Nature_of_Payment_or_Transfer_of_Value", "Name_of_Associated_Covered_Drug_or_Biological1",
                 "Name_of_Associated_Covered_Device_or_Medical_Supply1", "Physician_Specialty",
                 "Program_Year")

#Paste them together and deduplicate common column names
wanted_cols <- c(wanted_cols_2016plus, wanted_cols_2013_to_2015) %>% unique


#Read specialties sheet (to map CMS codes onto specialties)
specialties <- read.csv("Specialties Mapping.csv")


#Run foreach loop from 2013-2022
x <- foreach(file_year = seq(2013, 2022, 1),
             .packages = packs,
             .combine = "rbind") %do% {
               
               #Set file to import (To import the data, save your files as "General_Payments_XXXX.csv", where "XXXX" refers to the year)
               file <- paste0(write_your_file_directory_here, "/General_Payments_", file_year, ".csv")
               
               #Read file
               x <- fread(file,
                          select = wanted_cols,
                          nThread = 14)
               
               #Clean names to make them easier to reference
               x <- clean_names(x)
               
               #Rename columns to make them easier to reference
               x <- x %>%
                 rename(any_of(c(
                   ##This will rename the column corresponding to the primary (first-mentioned) item for which the payment was made
                   #For 2016+
                   name = "name_of_drug_or_biological_or_device_or_medical_supply_1",
                   #For 2013-2015 (drugs/device names are in different columns)
                   drug_name = "name_of_associated_covered_drug_or_biological1",
                   device_name = "name_of_associated_covered_device_or_medical_supply1",
                   ##This will rename the column stating whether the primary item is a drug or device
                   #For 2016+ only since 2013-2015 have different columns for drugs/devices
                   object_type = "indicate_drug_or_biological_or_device_or_medical_supply_1",
                   ##This will rename the specialties column
                   #For 2016+
                   specialty = "covered_recipient_specialty_1",
                   #For 2013-2015
                   specialty = "physician_specialty",
                   ##This will rename the column stating the amount in USD
                   #Same name for both 2013-2015 and 2016+
                   amount = "total_amount_of_payment_us_dollars",
                   ##This will rename the column stating the N of payments
                   #Same name for both 2013-2015 and 2016+
                   payments_n = "number_of_payments_included_in_total_amount",
                   ##This will rename the column stating the nature of the payments
                   #Same name for both 2013-2015 and 2016+
                   payment_nature = "nature_of_payment_or_transfer_of_value",
                   ##This will rename the column stating the year
                   #Same name for both 2013-2015 and 2016+
                   year = "program_year"
                 )))
               
               #Filter to MDs/DOs (Allopathic/Osteopathic physicians)
               x <- x %>% filter(specialty %>% stri_detect_fixed("Allopathic & Osteopathic Physicians"))
               
               #Remove ownership/investment interest (not a category of General Payments)
               x <- x %>%
                 filter(payment_nature != "Current or prospective ownership or investment interest")
               
               #Set aside payment categories applicable from 2021 onwards only
               x <- x %>% filter(payment_nature != "Acquisitions" &
                                   payment_nature != "Debt Forgiveness" &
                                   payment_nature != "Debt forgiveness" &
                                   payment_nature != "Long-term medical supply or device loan" &
                                   payment_nature != "Long term medical supply or device loan")
               
               #Exclude royalty/licensing fees
               x <- x %>% filter(payment_nature != "Royalty or License")
               
               #Get number of payments to doctors (sum because 1 record may have >1 payment(s))
               n_of_payments <- x %>% 
                 spull(payments_n) %>%
                 sum
               
               #By specialty
               x <- left_join(x, specialties, by = "specialty")
               
               #Make sure all specialties have been successfully mapped
               missing_spec <- x %>% filter(is.na(sp_full)) %>% nrow
               
               #Group payments by specialty
               sp <- x %>%
                 group_by(year, sp, sp_full) %>%
                 summarise(payments_n = sum(payments_n),
                           tamount = sum(amount)
                 )
               
               ##Run code to import drug/device payments for 2016+
               if(file_year >= 2016) {
               #Group payments by primary drug (first mentioned)
               drugs <- x %>% 
                 filter(object_type %in% c("Drug", "Biological")) %>% #Filter to drugs (includes biologics)
                 mutate(name = toupper(name)) %>% #This will capitalize all words of the name (to group in a case-insensitve manner)
                 group_by(name) %>% #Group by drug
                 summarise(amount = sum(amount)) #Calculate totals per drug
               
               #Group payments by primary device (first mentioned)
               devices <- x %>% 
                 filter(object_type == "Device") %>% #Filter to devices
                 mutate(name = toupper(name)) %>% #This will capitalize all words of the name (to group in a case-insensitve manner)
                 group_by(name) %>% #Group by device
                 summarise(amount = sum(amount)) #Calculate totals per device
               }
               
               
               ##Run code to import drug/device payments for 2016+
               if(file_year %between% c(2013, 2015)) {
               drugs <- x %>% 
                 filter(drug_name != "") %>% #Filter to drugs (anything that does not have a blank in the drug column; includes biologics)
                 mutate(name = toupper(drug_name)) %>% #This will capitalize all words of the name (to group in a case-insensitve manner)
                 group_by(drug_name) %>% #Group by drug
                 summarise(amount = sum(amount)) %>% #Calculate totals per drug
                 rename(name = drug_name) #To make column names compatible with the 2016+ data
               
               #Get devices
               devices <- x %>% 
                 filter(device_name != "") %>% #Filter to devices (anything that does not have a blank in the device column)
                 mutate(name = toupper(device_name)) %>% #This will capitalize all words of the name (to group in a case-insensitve manner)
                 group_by(device_name) %>% #Group by device
                 summarise(amount = sum(amount)) %>% #Calculate totals per drug
                 rename(name = device_name) #To make column names compatible with the 2016+ data
                 
               }
               
               
               #Create a list containing the relevant items
               list(n_of_payments, sp, drugs, devices, missing_spec)
             }


#Save the imported data
qsave(x, file = "Imported_Data.RData")
#Read the file
x <- qread(file = "Imported_Data.RData")

##Use rbindlist to create dataframes from the list elements in the data.table
#Get N of payments and sum them up
n_of_payments <- x[, 1] %>% as.numeric %>% sum %>% comma
#Create a specialties data.table (payments for each specialty)
sp <- x[, 2] %>% rbindlist
#Create a drugs data.table (payments for each drug)
drugs <- x[, 3] %>% rbindlist
#Create a devices data.table (payments for each device)
devices <- x[, 4] %>% rbindlist
#Add up rows (if any) with missing specialties
missing_specs <- x[, 5] %>% as.numeric %>% sum

#Perform the check (if missing_specs > 0)
if(missing_specs > 0) {
  "Some records have not been assigned to a specialty"
} else {
  "There were no rows with missing specialties"
}
