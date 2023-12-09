#Scale down the size of the figure (to fit it into a 2-figure panel)
scale_down = 2
#This will load the source code for unifying drug names that may be referred to using more than a single term
source("Unify Drugs.R")

#Group by type and name and get top 20
drugfig_df <- drugfig_df %>% 
  filter(name != "") %>% #Filter out those with blank names (indicates non-drug payments)
  group_by(name) %>% #Group by drug
  summarise(amount = (sum(amount))/1000000) %>% #Calculate total per drug and divide by 1 million
  arrange(-amount) %>% #Arrange in descending order
  slice(1:25) #Get the top 25


#Capitalize only first letters
drugfig_df$name <- drugfig_df$name %>% str_to_title

#Import the groupings sheet to categorize drugs
drug_cats <- readxl::read_xlsx("Categorizations.xlsx", sheet = "Drugs")

#Join the imported sheet
drugfig_df <- left_join(drugfig_df, drug_cats, by = c("name" = "Item"))

#Reorder drugs according to amount
drugfig_df$name <- fct_reorder(drugfig_df$name, -drugfig_df$amount)

#Add label to display on top of bars
drugfig_df$label <- paste0( (drugfig_df$amount) %>% round(1) %>%
                              format(nsmall = 1)) %>% str_trim

#Convert to data.table
drugfig_df <- drugfig_df %>% data.table


#Plot
drugs_fig <- ggplot(data = drugfig_df,
       aes(x = name,
           y = amount,
           fill = Category)) +
  #Bars and their fill
  geom_bar(stat = "identity",  color = "black", lwd = 1/scale_down) +
  scale_fill_jama(name = "Indication",
                     breaks = c("Cardiometabolic",
                                "Neuropsychiatric",
                                "Oncologic",
                                "Rheumatologic & Immunologic",
                                "Other")) +
  #Add label on top
  geom_text(hjust = "center",
            nudge_y = 0.35,
            size = 8/scale_down,
            aes(label = label,
                fontface = "bold")) +
  #Add title
  ggtitle("Top 25 drugs related to industry payments in the US, 2013 to 2022",
          subtitle = "These numbers do not include acquisitions of entities owned by physicians, loans for medical products, royalty or licensing fees, or debt forgiveness payments.\nThe color of each bar corresponds to its category (drugs in the top 25 were classified as having cardiometabolic indications, neuropsychiatric indications, oncologic indications, rheumatologic/immunlogic indications, or other indications).") +
  #Add scales
  scale_x_discrete(
    name = "Drug"
  ) +
  scale_y_continuous(
    name = "Total value of payments (million USD)",
    expand = c(0, 0),
    limits = c(0, 230),
    trans = "sqrt",
    breaks = c(0, 5, 20, 50, 100, 200)
  ) +
  #Theme elements
  theme_pubclean() +
  theme(text = element_text(size = 18/scale_down),
        plot.title=element_text(face = "bold", hjust = 0.0, size = 28/scale_down),
        plot.subtitle = element_text(face = "bold", size = 0/scale_down, hjust = 0.0, color = "grey45"),
        axis.text.x = element_text(size = 20/scale_down, face = "bold", angle = 45, vjust = 1, hjust = 1),
        axis.text.y = element_text(size = 20/scale_down, face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_text(size = 22/scale_down, face = "bold"),
        axis.line = element_line(colour = "black", size = 2/scale_down),
        legend.text = element_text(size = 25/scale_down, face = "bold"),
        legend.title = element_text(size = 30/scale_down, face = "bold"),
        legend.position = c(0.5, 0.98),
        plot.margin = margin(0.5, 1, 0.5, 1, "cm")/scale_down,
        legend.key.width = unit(6, "mm"),
        legend.key.height = unit(6, "mm"),
        legend.background = element_rect(fill = "transparent")) +
  guides(fill = guide_legend(nrow = 1, byrow = TRUE,
                             title.position = "left")) 

