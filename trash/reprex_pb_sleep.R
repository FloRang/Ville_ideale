
# Le problème vient probablement d'rvest
test <- function(nom_ville, codpost){
  cat("blahblah")
  
  code_INSEE <- codpost %>% 
    filter(Nom_commune == nom_ville) %>% 
    pull(Code_commune_INSEE)
  
  id_ville <- paste0(nom_ville, "_", code_INSEE)
  path <- glue("https://www.ville-ideale.fr/{id_ville}")
  Sys.sleep(5)
  path
 
}

safe_test <- possibly(test, otherwise = NA_character_)
get_villes_dprtment(dprtment = 92, codpost = code_postaux) %>% 
   map(safe_test, codpost = code_postaux) 
