enlv_nom_ville <- function(df, ville) {
  name_ville_decoup <- str_split(ville, pattern = " |-") %>% 
    flatten_chr() %>% 
    str_to_lower()
  
  print(length(name_ville_decoup))
  
  df %>%
    filter(!expression %in% name_ville_decoup)
}

