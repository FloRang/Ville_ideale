# Récuperer les données de ville idéale
get_comment <- function(id_ville, num_page) {
require(dplyr)
require(glue)
require(rvest)

path <- glue("https://www.ville-ideale.fr/{id_ville}?\\
             page={num_page}#commentaires")

read_html(path) %>% 
  html_nodes(".comm") %>% 
  html_text()

}


