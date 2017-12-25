# get id_ville
#' @param nom_ville_maj Le nom de la ville d'intérêt en majuscule et sans accent
get_id_ville <- function(nom_ville_maj){
  library(readr)
  library(stringr)
  
  suppressWarnings(code_post <- read_csv2("data/code_postaux.csv")) 
  
  result <- code_post %>% 
    filter(Nom_commune == nom_ville_maj)
  
  if (nrow(result) == 0) {
  stop("La ville que vous avez entrée n'existe pas")
  }
  if (nrow(result) > 1) {
    warning("La ville que vous avez entrée est dupliquée dans la base")
  }
  
  nom_ville <- pull(result, Nom_commune)
  code_INSEE <- pull(result, Code_commune_INSEE)
  paste0(nom_ville, "_", code_INSEE)
}


