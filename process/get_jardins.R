# get jardins

library(rvest)


jardins_paris_brut <- read_html("https://fr.wikipedia.org/wiki/Liste_des_espaces_verts_de_Paris")


tables <- html_nodes(jardins_paris_brut, "table")
tables_list <- html_table(tables)


prop_vert_arrond <- tables_list[[1]]
prop_vert_arrond <- prop_vert_arrond[1:20,]
prop_vert_arrond <- prop_vert_arrond %>% 
  mutate(Arrondissement = str_remove_all(Arrondissement, 
                                         pattern = "\\+|,|e.?"))
prop_vert_arrond <- prop_vert_arrond %>%  
  rename(hectare_hors_bois = `Superficie, hors bois(ha)`,
         prop_jardins_arrond = `Proportion del'arrondissement`)
prop_vert_arrond <- prop_vert_arrond %>% 
  mutate(prop_jardins_arrond = str_remove(prop_jardins_arrond, pattern = "%")) %>%  
  mutate(prop_jardins_arrond = str_replace(prop_jardins_arrond, 
                                        pattern = ",", 
                                        replacement = "\\."))
prop_vert_arrond <- prop_vert_arrond %>%  
  mutate(prop_jardins_arrond = as.numeric(prop_jardins_arrond ))


readr::write_rds(prop_vert_arrond, "data/prop_vert_arrond.RDS")

bois <- tables_list[[2]]
parcs <- tables_list[[3]]
jardins <- tables_list[[4]]
squares <- tables_list[[5]]
autres <- tables_list[[6]]
