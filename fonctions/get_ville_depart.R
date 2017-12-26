# Récupérer villes hauts de seine

get_villes_dprtment <- function(dprtment, codpost) {
  
  codpost %>%
    mutate(dep =  as.numeric(str_sub(Code_postal, start = 1, end = 2))) %>% 
    filter(dep == dprtment) %>% 
    pull(Nom_commune) %>% 
    str_replace_all(pattern = " ", replacement = "-") %>% 
    unique()
}

