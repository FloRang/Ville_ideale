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





com_traite_long <- com_traite %>% 
  gather(key = nb_mot, value = expression, mot, deux_mots) %>% 
  mutate(nb_mot = fct_recode(nb_mot, "un_mot" = "mot")) %>% 
  count(nom_ville, expression) %>% 
  filter(n > 2) %>% #On enlève les mots rares
  bind_tf_idf(term = expression, document = nom_ville, n = n) 

com_traite_long <- com_traite_long %>%  
  filter(nom_ville == ville) %>% 
  enlv_nom_ville(ville)




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

