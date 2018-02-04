R.utils::sourceDirectory("fonctions")
library(tidyverse)
library(tidytext)

com_brut <- read_csv("cache/extrait_to_250.csv")
com_traite <- read_rds(path = "cache/com_traite.rds")

# TODO Essayer de attribuer un numéro de commentaire pour qu'il soit ensuite 
# facilement retrouvable. 
#TODO Mettre les nouveaux graphiques dans l'appli Shiny. 
#TODO Tout passer en proportion
#Améliorer l'interface du Shiny. 
#Continuer le scraping du site. 

ville <- "ISSY LES MOULINEAUX"
name_ville_decoup <- str_split(ville, pattern = " |-") %>% 
  flatten_chr() %>% 
  str_to_lower()


com_traite_long <- com_traite %>%  
  filter(nom_ville == ville) %>% 
  filter(!mot %in% name_ville_decoup) 


stat <- com_traite_long %>% 
  count(nom_ville, expression) 
  

# Analyse mots simples ----------------------------------------------------
com_traite_long %>% 
  plot_mots(var_to_plot = expression, nom_ville = ville, nb_select = 20)


# Analyse mots composés ---------------------------------------------------
com_traite_long %>%   
  filter(nb_mot == "deux_mots") %>% 
  plot_mots(var_to_plot = expression, nom_ville = ville, nb_select = 5)


# Analyse expression manque -----------------------------------------------
com_traite %>%   
  filter(mot == "manque") %>% 
  plot_mots(deux_mots, ville, nb_select = 5)


# Commentaire associé -----------------------------------------------------
prnt_com_ass <-  function(commentaires_brut, mot_clef){
  commentaires_brut %>% 
    filter(str_detect(com, mot_clef)) %>%
    pull(com) %>% 
    map(~ str_view(.x, mot_clef))
}
com_brut %>%  
  filter(nom_ville == ville) %>% 
  prnt_com_ass("quartier")

