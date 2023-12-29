#Create the part of Table 1 pertaining to specialties and the total amounts paid thereto
sp_table_df <- sp %>% 
  group_by(sp_full) %>% #Group by specialty
  summarise(amount = round((sum(tamount)), 0)) %>% #Sum the amount paid to each specialty and convert to million $
  arrange(-amount) %>% #Arrange by descending order
  mutate(amount = amount %>% comma) #Make it so that the first decimal place always shows up

#Create the part of Table 1 pertaining to the top and median recipients
top_table_df <- top %>%
  mutate(top0.1mean = top0.1mean %>% round(0) %>% comma, #Convert to million $ and make it so that the first decimal place always shows up
         median = median %>% round(0) %>% comma #Make it so that the first decimal place always shows up
         ) 

#Now, match these 2 based on the name of the specialty
table_df <- full_join(sp_table_df, top_table_df, by = "sp_full") 

#Remove the sp column (redundant)
table_df <- table_df %>% select(-sp)

#Rename column names

#Convert to a flextable "t"
t <- flextable(table_df)

#Apply appropriate labels
t <- set_header_labels(t, values = list(
  sp_full = "Specialty",
  amount = "Total amount paid ($)",
  median = "Amount paid to the median recipient ($)",
  top0.1mean = "Mean amount paid to the top 0.1% of recipients ($)",
  top_mid_ratio = "Relative difference between top and median recipients (%)",
  total_n = "Total number of recipients",
  top0.1_n = "Number of physicians comprising top 0.1% of recipients"
)
                       )

#Create table borders
t <- border_inner(t)
t <- border_outer(t)

#Desigante column width
t <- width(t, width = 2)


#Desigante column width
t <- width(t, j = 1, width = 4)


#Bold first column
t <- bold(t, j = 1)


#Add a footnnote to state that specialties were coalesced
t <- footnote(t, j = 1, i = 1, part = "header", 
              ref_symbols = footnote_symbol(1),
              value = as_paragraph("The 228 distinct categories identified in the Open Payments database were coalesced into 39 specialties to facilitate interpretation.")
)

#Add a footnnote to explain how the relative difference was calculated
t <- footnote(t, j = 5, i = 1, part = "header",
         ref_symbols = footnote_symbol(2),
         value = as_paragraph("The relative difference was calculated by dividing the mean amount paid to the top 0.1% of recipients by the amount paid to the median recipient. For example, a value of 1,000 can be interpreted as the top 0.1% physicians being, on average, paid 1000% more than the median-paid physician.")
         )

#Add a footnnote to explain what the "Other" category includes
t <- footnote(t, j = 1, i = which(table_df$sp_full == "Other"), 
              ref_symbols = footnote_symbol(3),
              value = as_paragraph("The 'Other' category includes those classified by Open Payments as internal medicine physicians with a subspecialty of sports medicine, obesity medicine, integrative medicine, sleep medicine, electrodiagnostic medicine, addiction medicine, adolescent medicine, hospice and pallative medicine, hypertension specialists, and magnetic resonance imaging. It also includes those practicing legal medicine, neuromusculoskeletal medicine, phlebology, independent medical examiners, clinical pharmacists, geneticists, and pain medicine (not specified under another specialty such as anesthesia or physical & rehabilitative medicine). Additionally, it also includes surgeons with subspecialties in oral & maxillofacial surgery, hospice and palliative medicine, hand surgery, surgical critical care, and transplant surgery. These specialties generally had a low number of physicians in each category and could not readily be grouped alongside any of the other 38 specialties herein.")
)


#Apply some aesthetics to make the table more visually appropriate
t <- flextable_aes(t, table_title = "Table. Industry payments to physicians according to specialty")

#Save table
save_as_docx(t, path = paste0(folder, "Table.docx"))
