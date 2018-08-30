library(sf)
library(ggplot2)
library(dplyr)
carte_trottoir <- st_read("data/trottoirs_des_rues_de_paris.geojson")
carte_trottoir %>%  glimpse()


plop <- carte_trottoir  %>% as.data.frame() %>%  select(-geometry)

plop %>% count(niveau)
plop %>% count(libelle)
plop %>% count(info)