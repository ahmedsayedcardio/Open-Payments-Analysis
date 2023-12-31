drugfig_df <- drugs %>%
  mutate(name = case_when(
  str_detect(name, "(?i)Xarelto") ~ "Xarelto",
  str_detect(name, "(?i)Entresto|(?i)lcz696") ~ "Entresto",
  str_detect(name, "(?i)Eliquis") ~ "Eliquis",
  str_detect(name, "(?i)Jardiance") ~ "Jardiance",
  str_detect(name, "(?i)Praluent") ~ "Praluent",
  str_detect(name, "(?i)Vascepa") ~ "Vascepa",
  str_detect(name, "(?i)Brilinta") ~ "Brilinta",
  str_detect(name, "(?i)Farxiga") ~ "Farxiga",
  str_detect(name, "(?i)Pradaxa") ~ "Pradaxa",
  str_detect(name, "(?i)Corlanor") ~ "Corlanor",
  str_detect(name, "(?i)Nexlizet") ~ "Nexlizet",
  str_detect(name, "(?i)Ranexa") ~ "Ranexa",
  str_detect(name, "(?i)Adempas") ~ "Adempas",
  str_detect(name, "(?i)Vyndaqel") ~ "Vyndaqel",
  str_detect(name, "(?i)Humira|(?i)Adalimumab") ~ "Humira",
  str_detect(name, "(?i)Dupixent|(?i)Dupilumab") ~ "Dupixent",
  str_detect(name, "(?i)Botox") ~ "Botox",
  str_detect(name, "(?i)cosentyx|(?i)secukinumab") ~ "Cosentyx",
  str_detect(name, "(?i)Aimovig|(?i)Erenumab") ~ "Aimovig",
  str_detect(name, "(?i)Abilify") ~ "Abilify",
  str_detect(name, "(?i)Latuda") ~ "Latuda",
  str_detect(name, "(?i)Brilinta") ~ "Brilinta",
  str_detect(name, "(?i)Bydureon") ~ "Bydureon",
  str_detect(name, "(?i)Invokana") ~ "Invokana",
  str_detect(name, "(?i)Rexulti") ~ "Rexulti",
  str_detect(name, "(?i)Repatha") ~ "Repatha",
  str_detect(name, "(?i)Acthar") ~ "Acthar",
  str_detect(name, "(?i)Aubagio") ~ "Aubagio",
  str_detect(name, "(?i)Trulicity") ~ "Trulicity",
  str_detect(name, "(?i)Keytruda") ~ "Keytruda",
  TRUE ~ name
  ))
