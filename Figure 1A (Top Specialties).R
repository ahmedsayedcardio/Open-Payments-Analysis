#Scale down the size of the figure (to fit it into a 2-figure panel)
scale_down = 2
#Group by type and name of specialty and get top 20
spfig_df <- sp %>% 
  group_by(sp_full) %>% 
  summarise(amount = (sum(tamount))/1000000000) %>%
  arrange(-amount) %>% 
  slice(1:20)


#Rename certain items to save space
spfig_df$sp_full <- spfig_df$sp_full %>% str_replace_all(c("Rheumatology, Allergy, and Immunology" = "Rheumatology & Immunology"))
spfig_df$sp_full <- spfig_df$sp_full %>% str_replace_all(c("General IM" = "Internal Medicine"))

#Reorder specialties according to amount (such that the first specialties show first)
spfig_df$sp_full <- fct_reorder(spfig_df$sp_full, -spfig_df$amount)

#Add a column containing numbers that will be put on top of the bars
spfig_df$label <- paste0(spfig_df$amount %>% round(2) %>%
                           format(nsmall = 1)) %>% str_trim

#Get amount received by specialty receiving the median payment
sp_median <- sp %>% 
  group_by(sp_full) %>% 
  summarise(amount = (sum(tamount))/1000000000) %>%
  filter(amount == median(amount))

#Convert to data.table (to make for easier use)
spfig_df <- spfig_df %>% data.table

#Create a color palette for this figure (composed of 20 colors for 20 specialties)
sp_palette <- c("#E15759", "#FF9D9A", "#F28E2B", "#FFBE7D","#B6992D", "#F1CE63",
                "#79706E", "#BAB0AC",
                "#9D7660", "#D7B5A6",
                "#D37295", "#FABFD2",
                "#B07AA1", "#D4A6C8",
                "#4E79A7", "#A0CBE8",
                "#499894", "#86BCB6",
                "#59A14F", "#8CD17D")

#Plot
spfig <- ggplot(data = spfig_df,
       aes(x = sp_full,
           y = amount,
           fill = sp_full)) +
  #Bars and their fill
  geom_bar(stat = "identity",  color = "black", lwd = 1/scale_down) +
  scale_fill_manual(name = "",
                    values = sp_palette) +
  #Plot median
  geom_hline(yintercept = median(sp_median$amount), lwd = 1/scale_down, linetype = "dashed",
             color = "black") +
  #Add label on top
  geom_text(nudge_y = 0.03,
             size = 6/scale_down,
             aes(label = label,
                 fontface = "bold")) +
  #Add title
  ggtitle("Top 20 specialties according to total industry payments in the US, 2013 to 2022",
          subtitle = "These numbers are the total sum of payments paid to all clinicians within these specialties. These numbers do not include acquisitions of entities owned by physicians, loans for medical products, royalty or licensing fees, or debt forgiveness payments.\nThe black dashed line represents the specialty receiving the median sum of payments.") +
  #Add scales
  scale_x_discrete(
    name = NULL
  ) +
  scale_y_continuous(
    name = "Total value of payments (billion USD)",
    expand = c(0, 0),
    limits = c(0, 1.5),
    breaks = c(0, 0.5, 1, 1.5)
  ) +
  #Theme elements
  theme_pubclean() +
  theme(text = element_text(size = 21/scale_down),
        plot.title=element_text(face = "bold",hjust = 0.0, size = 24/scale_down),
        plot.subtitle = element_text(face = "bold", size = 15/scale_down, hjust = 0.0, color = "grey45"),
        axis.text.x = element_text(size = 15/scale_down, face = "bold", angle = 45, vjust = 1, hjust = 1),
        axis.text.y = element_text(size = 20/scale_down, face = "bold"),
        axis.title.x = element_text(size = 22/scale_down, face = "bold"),
        axis.title.y = element_text(size = 22/scale_down, face = "bold"),
        axis.line = element_line(colour = "black", size = 2/scale_down),
        legend.text = element_text(size = 15.8/scale_down, face = "bold"),
        legend.title = element_text(face = "bold"),
        plot.margin = margin(0.5, 1, 0.5, 1, "cm")/scale_down,
        legend.key.width = unit(3, "mm"),
        legend.key.height = unit(3, "mm"),
        legend.position = "none") 
