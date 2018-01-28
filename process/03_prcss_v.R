#Scraping des villes
R.utils::sourceDirectory("fonctions")
library(tidyverse)

villes <- read_csv("cache/bdd_villes.csv")

safe_get_seq_pg <- possibly(get_seq_pg, otherwise = NA_integer_)

villes_interet <- villes %>%
  filter(dep == 92) %>%   
  mutate(num_page = map(id_ville, safe_get_seq_pg)) 

vlls_92_cln <- villes_interet %>%  
  rowwise() %>% 
  filter(!any(is.na(num_page))) %>% 
  unnest()

write_csv(vlls_92_cln, "cache/vlls_92_pg.csv")
