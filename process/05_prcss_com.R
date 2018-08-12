R.utils::sourceDirectory("fonctions")
library(tidyverse)

vlls_92_cln <- read_csv("cache/vlls_92_pg.csv")

safe_scrap_comment <- quietly(scrap_comment)

commnt_brut <- vlls_92_cln %>%
  slice(251:300) %>% 
  mutate(com = map2(id_ville, 
                    num_page, 
                    ~ scrap_comment(id_ville = .x, num_page = .y))) 

commnt_cln <- commnt_brut %>% 
  unnest(com)


write_csv(commnt_cln, "cache/201_250_pg.csv")
  
  

# Aggrégation
com_scrap <- str_subset(list.files("cache"), pattern = "^\\d") %>%  
  map(function(x) read.csv(paste0("cache/", x))) %>% 
  reduce(bind_rows)

write_csv(com_scrap, "cache/extrait_to_250.csv")


# Paris -------------------------------------------------------------------
library(tidyverse)

vlls_75_cln <- read_csv("cache/villes_75_pages_reduit.csv")

safe_scrap_comment <- possibly(scrap_comment, otherwise = NA)

commnt_brut <- vlls_75_cln %>%
  mutate(com = map2(id_ville, 
                    num_page, 
                    ~ safe_scrap_comment(id_ville = .x, num_page = .y))) 

commnt_cln <- commnt_brut %>% 
  unnest(com)


write_csv(commnt_cln, "cache/paris/paris_light_com_brut.csv")



# Paris Outliers (1er et 8e) ont peu de commentaires ----------------------------------------------

paris_outliers <- villes_interet_75 %>%  
  filter(lengths(num_page) == 1) %>% 
  mutate(num_page = 1) %>%
  mutate(com = map2(id_ville, 
                    num_page, 
                    ~ safe_scrap_comment(id_ville = .x, num_page = .y)))  %>%  
  unnest(com)
write_csv(paris_outliers, "cache/paris/paris_outliers_com_brut.csv")

