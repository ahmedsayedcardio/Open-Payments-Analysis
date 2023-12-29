#Load the packages we'll use for this work.
packs <- c("ggplot2", "doParallel", "dplyr", "tidyr", "data.table", "janitor",
           "stringr", "stringi", "forcats", "ggsci", "ggpubr", "ggthemes", "ggh4x",
           "ggrepel",  "grid", "gridExtra", "Hmisc", "qs", "flextable")
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


#Perform some aesthetic modifications for flextables
flextable_aes <- function(table, table_title) {
  
  #Table font
  table <- flextable::font(table, fontname = "Times New Roman", part = "all")
  
  #Align everything centrally
  table <- flextable::align(table, align = "center", part = "all")
  
  #Table heading
  table <- flextable::set_caption(table, caption = table_title,
                                  fp_p = fp_par(text.align = "left"))
  
  #Align footer to the left
  table <- flextable::align(table, align = "left", part = "footer")
  
  #Bold header
  table <- flextable::bold(table, part = "header")
  
  #Set Table width
  table <- flextable::width(table, width = 1.5, unit = "in")
  
  #Bold
  table <- flextable::bold(table, part = "header")
  
  #Print
  table
}

#Function to insert footnote symbol in the correct order
footnote_symbol <- function(i) {
  footnote_symbols <- c("\U002A", "\U2020", "\U2021", "\U00A7")
  footnote_symbols[i]
}
