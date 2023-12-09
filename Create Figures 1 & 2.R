#Set folder to save figures
folder <- "C:/Ahmed's Stuff/ResearchStuff/Open_Payments_Project/Manuscript/Revisions_JAMA/"

#Combine figures 1A and 1B into a single figure (Figure 1)
#Figure 1
ggarrange(spfig, topfig, 
          labels = c("[A]","[B]"),
          nrow = 2, ncol = 1) 
#Use a single horizontal line as a separator
grid_single_horizontal() 
fig1 <- grid.grab()
#Save the file
ggsave(fig1,
       filename = paste0(folder, "Figure 1.pdf"),
       width = 16,
       height = 9,
       dpi = 600)


#Figure 2
ggarrange(drugs_fig, devfig,
          labels = c("[A]","[B]"),
          nrow = 2, ncol = 1)
#Use a single horizontal line as a separator
grid_single_horizontal()
fig2 <- grid.grab()
#Save the file
ggsave(fig2,
       filename = paste0(folder, "Figure 2.pdf"),
       width = 16,
       height = 9,
       dpi = 600)

