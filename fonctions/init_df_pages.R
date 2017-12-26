#get_com_ville
init_df_pages <- function(nom_ville, codpost) {
  library(readr)
  library(stringr)
  cat("Pour économiser les serveurs, le programme est ralenti manuellement")
  
  code_INSEE <- codpost %>% 
    filter(Nom_commune == nom_ville) %>% 
    pull(Code_commune_INSEE)
  
  id_ville <- paste0(nom_ville, "_", code_INSEE)  
  
  path <- glue("https://www.ville-ideale.fr/{id_ville}")
  
  nb_pages <- read_html(path) %>% 
    html_nodes("a") %>% 
    html_text() %>% 
    str_subset("^[1-9][0-9]*$") %>% 
    as.numeric() %>% 
    max()
  Sys.sleep(5)
  
  init_df <-  tibble(id_ville = id_ville, num_page = seq(to = nb_pages))
  
  init_df
}



# 
# if (nrow(result) == 0) {
#   stop("La ville que vous avez entrée n'existe pas")
# }
# if (nrow(result) > 1) {
#   warning("La ville que vous avez entrée est dupliquée dans la base")
# }