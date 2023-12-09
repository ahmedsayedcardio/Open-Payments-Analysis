#Scale down the size of the figure (to fit it into a 2-figure panel)
scale_down = 2
#This will load the source code for unifying device names that may be referred to using more than a single term
source("Unify Devices.R")

#Group by type and name and get top 20
devfig_df <- devfig_df %>% 
  group_by(name) %>% #Group by device
  summarise(amount = (sum(amount))/1000000) %>% #Calculate total per device and divide by 1 million
  arrange(-amount) %>% #Arrange in descending order
  slice(1:25) #Get the top 25


#Import the groupings sheet
device_cats <- readxl::read_xlsx("Categorizations.xlsx", sheet = "Devices")

#Join
devfig_df <- left_join(devfig_df, device_cats, by = c("name" = "Item"))

#Add label
devfig_df$label <- paste0((devfig_df$amount) %>% round(1) %>% format(nsmall = 1)) %>% str_trim

#Change to a more sequential manner
pal25 <- c("#e31a1c","#fb9a99","#ff7f00", "#d95f02",
           "#fb8072", "#fc8d62",
           "#6a3d9a","#e78ac3",
           "#b15928",    "#fdbf6f","#ffd92f", "#ffff99", "#e5c494","#b3b3b3", 
           "#cab2d6",  
           "#8dd3c7", "#bebada",
           "#8da0cb",   "#80b1d3",
           "#1f78b4",  "#a6cee3","#66c2a5",
           "#33a02c","#b2df8a", "#a6d854")


#Reorder factor according to amount
devfig_df$name <- fct_reorder(devfig_df$name, -devfig_df$amount)


#Convert to data.talbe
devfig_df <- devfig_df %>% data.table

#Plot
devfig <- ggplot(data = devfig_df,
       aes(x = name,
           y = amount,
           fill = Category)) +
  #Bars and their fill
  geom_bar(stat = "identity",  color = "black", lwd = 1/scale_down) +
  scale_fill_brewer(name = "Indication",
                    breaks = c("Cardiac",
                             "Orthopedic",
                             "Neurologic",
                             "Urologic",
                             "Gynecologic",
                             "Plastic",
                             "Oncologic",
                             "Other"),
                    palette = "Dark2") +
  #Add label on top
  geom_text(hjust = "center",
            nudge_y = 0.5,
             size = 8/scale_down,
             aes(label = label,
                 fontface = "bold")) +
  #Add title
  ggtitle("Top 25 devices related to industry payments in the US, 2013 to 2022") +
  #Add scales
  scale_x_discrete(
    name = "Device"
  ) +
  scale_y_continuous(
    name = "Total value of payments (million USD)",
    expand = c(0, 0),
    limits = c(0, 360),
    trans = "sqrt",
    breaks = c(0, 5, 20, 50, 100, 200, 300)
  ) +
  #Theme elements
  theme_pubclean() +
  theme(text = element_text(size = 18/scale_down),
        plot.title=element_text(face = "bold", hjust = 0.0, size = 28/scale_down),
        plot.subtitle = element_text(face = "bold", size = 0/scale_down, hjust = 0.0, color = "grey45"),
        axis.text.x = element_text(size = 15/scale_down, face = "bold", angle = 45, vjust = 1, hjust = 1),
        axis.text.y = element_text(size = 20/scale_down, face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_text(size = 22/scale_down, face = "bold"),
        axis.line = element_line(colour = "black", size = 2/scale_down),
        legend.text = element_text(size = 25/scale_down, face = "bold"),
        legend.title = element_text(size = 30/scale_down, face = "bold"),
        legend.position = c(0.5, 0.95),
        plot.margin = margin(0.5, 1, 0.5, 1, "cm")/scale_down,
        legend.key.width = unit(6, "mm"),
        legend.key.height = unit(6, "mm"),
        legend.background = element_rect(fill = "transparent")) +
  guides(fill = guide_legend(nrow = 1, byrow = TRUE,
                             title.position = "left")) 
