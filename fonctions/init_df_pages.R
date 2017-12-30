#get_com_ville
init_df_pages <- function(id_ville) {
  library(rvest)
  print("Pour économiser les serveurs, le programme est ralenti manuellement")
  Sys.sleep(5) # 

  
  path <- glue::glue("https://www.ville-ideale.fr/{id_ville}")
  
  nb_pages <- read_html(path) %>% 
    html_nodes("a") %>% 
    html_text() %>% 
    str_subset("^[1-9][0-9]*$") %>% 
    as.numeric() %>% 
    max()

  
  seq(to = nb_pages)

}




# 
# if (nrow(result) == 0) {
#   stop("La ville que vous avez entrée n'existe pas")
# }
# if (nrow(result) > 1) {
#   warning("La ville que vous avez entrée est dupliquée dans la base")
# }