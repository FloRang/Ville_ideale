# Script pour récupérer et traiter des données
library(sf)
library(ggrepel)
library(tidyverse)

carte <- st_read("data/paris.geojson")
commerces <- st_read("data/commercesparis.geojson")
info_iris_paris <- read_rds("data/info_iris_paris.rds")
prix_paris_quartier <- read_rds("data/prix_quartier_clean.rds") 
parcs_paris <- read_rds("data/prop_vert_arrond.RDS") 
carte_commerces <- st_join(carte, commerces, join = st_contains)


# Prix ---------------------------------------------------------------------
prix_paris_crp_iris <- left_join(info_iris_paris, prix_paris_quartier, 
                                 by = "num_quart")
carte <- carte %>%  mutate(CODE_IRIS = as.integer(as.character(CODE_IRIS)))

carte_prix <- left_join(carte, prix_paris_crp_iris,  by = c("CODE_IRIS" = "num_iris"))


# TODO Pour l'instant le prix est par quartier mais à terme recopier le prix
# par iris de meilleurs agents. 
carte_prix %>%
ggplot() +
  geom_sf(aes(fill = prix)) +
  theme_void() +
  scale_fill_gradient(low = "#ffeda0", high = "#f03b20", na.value = "white") +
  theme(panel.grid.major = element_line(linetype = "blank"), 
        panel.grid.minor = element_line(linetype = "blank"))


# Commerce ----------------------------------------------------------------
# On enlève les modalités très nombreuses et peu pertinentes.
carte_commerces <- carte_commerces %>% 
  filter(!libact %in% c("Locaux Vacants", "Bureau en boutique", "Locaux en travaux"))

carte_commerces_iris <- carte_commerces %>% 
  group_by(iris) %>%  
  summarise(nb_commerces = n()) %>% 
  mutate(iris = as.integer(as.character(iris))) #Pour faciliter la jointure qui suit. 

carte_commerces_iris <- carte_commerces_iris %>% 
  left_join(prix_paris_crp_iris,  by = c("iris" = "num_iris")) %>% 
  ungroup() %>% 
  mutate(area = as.numeric(st_area(geometry))) %>% 
  mutate(commerces_m2 = nb_commerces / area) %>%  
  mutate(iris_arro = str_sub(iris, start = 1, end = 5))

# Carte Commerces m2
ggplot() +
  geom_sf(data = carte_commerces_iris, aes(fill = commerces_m2)) +
  theme_void() +
  scale_fill_viridis_c() +
  theme(panel.grid.major = element_line(linetype = "blank"), 
        panel.grid.minor = element_line(linetype = "blank"))


#  Arrondissements avec le plus de commerces ----------------------------------
carte_commerces_iris %>%  
  ggplot() +
  geom_point(aes(x = area, y = commerces_m2, col = iris_arro)) +
  geom_text_repel(data = filter(carte_commerces_iris, commerces_m2 > 0.003), 
                  aes(x = area, y = commerces_m2, label = str_sub(iris_arro, start = 4, end = 5))) +
  scale_x_log10() +
  scale_color_viridis_d() + 
  labs(title = "Les iris avec la plus grande densité de commerces")



# Type de commerces pour les arrondissements avec bcp de commerces --------------
boutiques_arro_style <- left_join(as.data.frame(filter(carte_commerces_iris, commerces_m2 > 0.003)),
                                  carte_commerces,
                                  by = "iris")

stat <- boutiques_arro_style %>%  
  as.data.frame() %>% 
  select(-matches("geometry")) %>% 
  count(iris, libact)

stat %>%  spread(key = iris, value = nn, fill = 0) %>%  View


# Parcs -------------------------------------------------------------------
carte <- carte %>%  
  mutate(arrond = str_sub(CODE_IRIS, start = 3, end = 5)) %>%  
  mutate(arrond = str_replace(arrond, 
                              pattern = "^1", 
                              replacement = "0")) %>%  
  mutate(arrond = as.integer(arrond))


parcs_paris <- parcs_paris %>%  
  mutate(arrond = as.integer(Arrondissement))

carte_parcs <- carte %>%  inner_join(parcs_paris, 
                                     by = c("arrond"))
carte_parcs %>%  
  ggplot() +
  geom_sf(aes(fill = prop_jardins_arrond)) + 
  scale_fill_gradient(low = "#ecf9ec", high = "#339933")

library(tmap)
carte_parcs %>%  
  tm_shape() +
  tm_polygons("prop_jardins_arrond",
              breaks=c(0, 4, 8, 12, 16, 20), 
              palette = "Greens")


# Ajouter MapBox? 
# Mettre un fond de carte plus sympa. Visualisation dynamique? 
# OSM par exemple? Pour avoir notamment les stations de métro....
#TODO Connecter à RATP ou CityMqpper. Utiliser l'appli pour opti les trajets. 
#TODO Taille trottoir
#TODO Ajouter parcs
#TODO Discriminer magasins hors alimentaire. 
#TODO Ajouter la circulation




