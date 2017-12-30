# A supprimer
get_id_ville <- function(nom_ville, codpost) {
  library(stringr)
  code_INSEE <- codpost %>% 
    filter(Nom_commune == nom_ville) %>% 
    pull(Code_commune_INSEE) %>% 
    unique() %>% 
    str_replace_all(pattern = " ", replacement = "-")
  
  id_ville <- paste0(nom_ville, "_", code_INSEE)
  id_ville
}

code_postaux %>% 
  filter(Nom_commune %in% c("SURESNES", "NANTERRE"))
?arrange
