#Load the packages we'll use for this work.
packs <- c("ggplot2", "doParallel", "dplyr", "tidyr", "data.table", "janitor",
           "stringr", "stringi", "forcats", "ggsci", "ggpubr", "ggthemes", "ggh4x",
           "ggrepel",  "grid", "gridExtra", "Hmisc", "qs")
lapply(packs, require, character.only = TRUE)


##Self-made (non-package) functions##
#Function to add comma separators to large numbers
comma <- function(x) {
  if(!is.numeric(x)) {
    x <- x %>% pull
  }
  x %>%
    format(big.mark = ",", trim = T)
}

#Chain select and pull
spull <- function(df, ...) {
  df %>% dplyr::select(...) %>% pull
}

#Function to insert a single horizontal line (to separate figures)
grid_single_horizontal <- function() {
  vert_coords = c(0.5, 0.5)
  hrzl_coords = c(0, 1)
  line_id = c(1, 1)
  grid.polygon(hrzl_coords, vert_coords, line_id, gp = gpar(lwd = 2))
}

