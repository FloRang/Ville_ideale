R.utils::sourceDirectory("fonctions")
library(tidyverse)

vlls_92_cln <- read_csv("cache/vlls_92_pg.csv")

safe_scrap_comment <- quietly(scrap_comment)


commnt_brut <- vlls_92_cln %>%
  slice(1:50) %>% 
  mutate(com = map2(id_ville, 
                    num_page, 
                    ~ scrap_comment(id_ville = .x, num_page = .y))) 

commnt_cln <- commnt_brut %>% 
  unnest(com)

  
  

