# Récuperer les données de ville idéale
scrap_comment <- function(id_ville, num_page) {
  library(dplyr)
  library(glue)
  library(rvest)
  Sys.sleep(5)
  # Pour économiser les serveurs de ville idéale, on pause pendant 
  # 5 secondes l'exécution du code. Pour l'instant la pause est avant
  # l'instruction de scraping car on fait l'hypothèse d'une utilisation 
  #récursive et en cas d'erreurs du code qui ferait sortir de la fonction
  # sans le Sys.sleep. 
  # Réfléchir à un moyen de le faire de manière propre. 
  chemin_ville <- glue("https://www.ville-ideale.fr/{id_ville}")
  
  #A cause d'un problème sur la version de glue du CRAN. Je n'utilise pos
  #la fonction if_else https://github.com/tidyverse/glue/commit/4d8019526e947543cc367c0519b456f2dbc8323b
  path <- ifelse(num_page == 1, 
                 yes = chemin_ville, 
                 no = glue("{chemin_ville}?page={num_page}#commentaires"))
  
  texte <- read_html(path) %>% 
    html_nodes(".comm") %>% 
    html_text()
  
  texte
}
