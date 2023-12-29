#Figure 1
ggarrange(drugs_fig, devfig,
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

