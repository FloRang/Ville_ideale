#Recup nb de pages

get_nb_pg <- function(id_ville){
  library(rvest)
  library(glue)
  
  path <- glue("https://www.ville-ideale.fr/{id_ville}")
  
  read_html(path) %>% 
    html_nodes("a") %>% 
    html_text() %>% 
    str_subset("^[1-9][0-9]*$") %>% 
    as.numeric() %>% 
    max()
  
}



