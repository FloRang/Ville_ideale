R.utils::sourceDirectory("fonctions")
library(tidyverse)

villes <- read_csv("cache/bdd_villes.csv")

safe_get_comment <- quietly(get_comment)
safe_init_df_pages <- possibly(init_df_pages, otherwise = NA_character_)


villes_interet <- villes %>%
  filter(dep == 92) %>%   
  mutate(num_page = map(id_ville, init_df_pages)) %>%
  unnest(num_page) 

commnt_brut <- villes_interet %>%
  sample_n(10) %>% 
  mutate(com = map2(id_ville, 
                    num_page, 
                    ~ scrap_comment(id_ville = .x, num_page = .y))) 

commnt_cln <- commnt_brut %>% 
  unnest(com)

  
  

