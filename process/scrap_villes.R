R.utils::sourceDirectory("Fonctions")
library(tidytext)
library(tidyverse)

# Automatiser l'écriture 
code_postaux <- read_csv2("data/code_postaux.csv")

safe_get_comment <- quietly(get_comment)
safe_init_df_pages <- possibly(init_df_pages, otherwise = NA_character_)

# Problèmle, le sys.sleep ne fonctionne pas
commentaire_df <- get_villes_dprtment(dprtment = 92, codpost = code_postaux) %>% 
  map_dfr(safe_init_df_pages, codpost = code_postaux) %>%
  mutate(com = map2(id_ville, 
                    num_page, 
                    ~ safe_get_comment(id_ville = .x, num_page = .y))) %>%
  unnest(com)

write_csv(commentaire_df, path = glue("cache/{id_ville}.csv"))



