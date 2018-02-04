#' Fonction pour enlever les mots simples qui sont en fait contenu 
#' dans une expression en deux mots. Par exemple si espace vert est présent
#' on enlève espace et vert pour éviter toute redondance. 
#' 
enlv_incl <- function(df) {
  mots_doubles_scindes <- df %>% 
    pull(expression) %>% 
    str_subset(pattern = " ") %>% 
    str_split(pattern = " ") %>% 
    flatten_chr() 
  
  df %>% 
    filter(!expression %in% mots_doubles_scindes)
}