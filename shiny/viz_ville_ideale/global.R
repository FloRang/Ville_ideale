library(shiny)
library(R.utils)
library(here)
library(tidytext)
library(tidyverse)

sourceDirectory(here("fonctions"))

com_traite <- read_rds(path = here("cache","com_traite.rds"))
com_traite_long <- com_traite %>%   
  gather(key = nb_mot, value = expression, mot, deux_mots) %>% 
  mutate(nb_mot = fct_recode(nb_mot, "un_mot" = "mot"))
# com_traite <- com_traite %>% 
#   mutate(nom_ville = str_to_title(nom_ville))

ville_dispo <- sort(unique(com_traite$nom_ville))
