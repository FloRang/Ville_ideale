library(shiny)
library(R.utils)
library(here)
library(tidytext)
library(tidyverse)

sourceDirectory(here("fonctions"))

com_traite <- read_rds(path = here("cache","com_traite.rds"))
com_traite <- com_traite %>% 
  mutate(nom_ville = str_to_title(nom_ville))

com_traite_long <- com_traite %>% 
  gather(key = nb_mot, value = expression, mot, deux_mots) %>% 
  mutate(nb_mot = fct_recode(nb_mot, "un_mot" = "mot")) %>% 
  count(nom_ville, expression) %>% 
  filter(n > 2) %>% #On enlève les mots rares
  bind_tf_idf(term = expression, document = nom_ville, n = n) 



ville_dispo <- sort(unique(com_traite_long$nom_ville))
