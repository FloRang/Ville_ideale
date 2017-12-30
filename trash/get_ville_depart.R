# Récupérer villes hauts de seine

get_villes_dprtment <- function(dprtment, villes) {
  
  villes %>%
    mutate(dep =  as.numeric(str_sub(codpost, start = 1, end = 2))) %>% 
    filter(dep == dprtment) %>% 
    select(Nom_commune) %>% 
    distinct()
}

