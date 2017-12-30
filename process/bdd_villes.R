#BDD villes
library(tidyverse)
# Automatiser l'écriture 
villes_brut <- read_csv2("data/code_postaux.csv") 

villes <- villes_brut %>% 
  rename(nom_ville = Nom_commune, codpost = Code_postal) %>% 
  mutate(INSEE_clean = str_replace_all(Code_commune_INSEE, 
                                       pattern = " ", 
                                       replacement = "-")) %>% 
  mutate(id_ville = paste0(nom_ville, "_", INSEE_clean)) %>% 
  mutate(dep =  as.numeric(str_sub(codpost, start = 1, end = 2))) %>% 
  select(nom_ville, id_ville, codpost, dep) %>% 
  distinct()

#write_csv(villes, "cache/bdd_villes.csv")