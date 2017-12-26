# Récuperer les données de ville idéale
get_comment <- function(id_ville, num_page) {
  library(dplyr)
  library(glue)
  library(rvest)
  
  if (num_page == 1) {
   
    path <- glue("https://www.ville-ideale.fr/{id_ville}")
  
   } else {
  
    path <- glue("https://www.ville-ideale.fr/{id_ville}?\\
             page={num_page}#commentaires")
   }
  
  texte <- read_html(path) %>% 
    html_nodes(".comm") %>% 
    html_text()
  
  # Pour économiser les serveurs de ville idéale, on pause pendant 
  # 5 secondes l'exécution du code. 
  Sys.sleep(5)
  
  texte
  }
