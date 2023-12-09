#Scale down the size of the figure (to fit it into a 2-figure panel)
scale_down = 2
#Group by type and name of specialty and get top 20
topfig_df <- top %>% 
  filter(n >= 1000) %>% #Only include specialties with at least 1,000 records (the smallest number necessary to calculate 0.1%)
  group_by(sp_full) %>% 
  summarise(t0.1q_amount = (sum(top0.1avg))/1000000, #Top 0.1%. Divide by million to get amount in millions
            median_amount = (sum(median))/1000000) %>% #Median. Divide by million to get amount in millions
  arrange(-t0.1q_amount) %>% 
  slice(1:20)

#Rename specialties to have extra space
topfig_df$sp_full <- topfig_df$sp_full %>% str_replace_all(c("Rheumatology, Allergy, and Immunology" = "Rheumatology & Immunology"))

#Order by amount
t1q_order <- topfig_df$sp_full %>% unique

#Change data structure (from wider to longer) to make it usable for plotting
topfig_df <- topfig_df %>% 
  pivot_longer(cols = c("t0.1q_amount", "median_amount"),
               names_to = c("percentile"),
               values_to = c("amount"))

#Write percentile neatly
topfig_df$percentile <- str_replace_all(topfig_df$percentile, 
                                c("t0.1q_amount" = "99.9th percentile",
                                  "median_amount" = "50th percentile"))
#Order by amount
topfig_df$sp_full <- fct_relevel(topfig_df$sp_full, t1q_order)

#Factor percentiles and order them such that the 99.9th comes before the 50th
topfig_df$percentile <- fct_relevel(topfig_df$percentile, 
                                c("99.9th percentile", "50th percentile"))

#Set spacing
spacing <- 0.7

#Data.table it
topfig_df <- topfig_df %>% data.table

#Get the ratio between the top 0.1% and the median for each specialty
top_mid_ratio <- foreach(specialty = topfig_df$sp_full %>% unique,
                         .combine = "rbind") %do% {
  
  data.table(
  sp_full = specialty,
  ratio = 
    topfig_df[sp_full == specialty & percentile == "99.9th percentile", amount]
  /
  topfig_df[sp_full == specialty & percentile == "50th percentile", amount]
  )
}

#Create palette to be used for plotting
sp_palette <- c("#E15759", "#FF9D9A", "#F28E2B", "#FFBE7D","#B6992D", "#F1CE63",
                "#79706E", "#BAB0AC",
                "#9D7660", "#D7B5A6",
                "#D37295", "#FABFD2",
                "#B07AA1", "#D4A6C8",
                "#4E79A7", "#A0CBE8",
                "#499894", "#86BCB6",
                "#59A14F", "#8CD17D")

#Plot
topfig <- ggplot(data = topfig_df,
       aes(x = sp_full,
           ymin = 0,
           ymax = amount,
           y = amount,
           col = sp_full,
           linetype = percentile,
           group = percentile)) +
  #Bars and their fill
  geom_linerange(stat = "identity", lwd = 4/scale_down, position = position_dodge(width = spacing)) +
  geom_point(position = position_dodge(width = spacing), size = 8/scale_down) +
  scale_color_manual(name = NULL,
                    values = sp_palette) +
  scale_linetype_manual(name = "Percentile",
                        labels = c("99.9th", "99th", "95th", "50th"),
                        values = c("11", "dotted", "longdash", "solid") %>% rev) +
  #Add title
  ggtitle("Top 20 specialties according to the highest-earning 0.1% in the US, 2013 to 2022",
          subtitle = "For each specialty, the solid line represents the average amount of industry payments to the top 0.1%. The single dot represents the median.") +
  #Add scales
  scale_x_discrete(
    name = NULL
  ) +
  scale_y_continuous(
    name = "Total value of payments (million USD)",
    expand = c(0.0, 0),
    trans = "sqrt",
    limits = c(0, 7),
    breaks = c(0, 0.25, 1, 2.5, 5, 7.5, 10, 12.5)
  ) +
  #Theme elements
  theme_pubclean() +
  theme(text = element_text(size = 21/scale_down),
        plot.title=element_text(face = "bold", hjust = 0.0, size = 24/scale_down),
        plot.subtitle = element_text(face = "bold", size = 15/scale_down, hjust = 0.0, color = "grey45"),
        axis.text.x = element_text(size = 15/scale_down, face = "bold", angle = 45, vjust = 1, hjust = 1),
        axis.ticks.x = element_blank(),
        axis.text.y = element_text(size = 20/scale_down, face = "bold"),
        axis.title.x = element_text(size = 22/scale_down, face = "bold"),
        axis.title.y = element_text(size = 22/scale_down, face = "bold"),
        axis.line = element_line(colour = "black", size = 2/scale_down),
        legend.text = element_text(size = 16/scale_down, face = "bold"),
        legend.background = element_blank(),
        legend.title = element_text(face = "bold"),
        plot.margin = margin(0.5, 1, 0.5, 1, "cm")/scale_down,
        legend.key=element_rect(fill="white"),
        legend.key.width = unit(3, "mm"),
        legend.key.height = unit(3, "mm"),
        legend.position = "none") +
  #Don't show a legend for linetype
  guides(linetype = "none")

