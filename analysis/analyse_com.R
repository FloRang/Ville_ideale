R.utils::sourceDirectory("fonctions")
library(tidyverse)

com_traite <- read_rds(path = "cache/com_traite.rds")


# Analyse mots simples ----------------------------------------------------


com_token %>%   
  filter(nom_ville ==  "ISSY LES MOULINEAUX") %>% 
  count(mot, sort = TRUE) %>%
  top_n(30, n) %>% 
  ggplot(aes(x = n, y = fct_reorder(mot, n))) +
  geom_point(fill = "black") + 
  theme_light()



# Analyse mots composés ---------------------------------------------------


com_traite %>%   
  count(deux_mots, sort = TRUE)  %>%
  top_n(30, n) %>% 
  ggplot(aes(x = n, y = fct_reorder(deux_mots, n))) +
  geom_point(fill = "black") + 
  theme_light()

# TODO Essayer de attribuer un numéro de commentaire pour qu'il soit ensuite 
# facilement retrouvable. 
com_traite %>%   
  filter(nom_ville == "ISSY LES MOULINEAUX") %>% 
  count(deux_mots, sort = TRUE)  %>%
  top_n(10, n) %>% 
  ggplot(aes(x = n, y = fct_reorder(deux_mots, n))) +
  geom_point(fill = "black") + 
  theme_light()


com_traite %>%   
  filter(nom_ville == "LEVALLOIS PERRET" & mot == "manque") %>% 
  count(deux_mots, sort = TRUE)  %>%
  top_n(10, n) %>% 
  ggplot(aes(x = n, y = fct_reorder(deux_mots, n))) +
  geom_point(fill = "black") + 
  theme_light()



# Commentaire associé -----------------------------------------------------


prnt_com_ass <-  function(commentaires_brut, mot_clef){
  commentaires_brut %>% 
    filter(str_detect(com, mot_clef)) %>%
    pull(com) %>% 
    map(~ str_view(.x, mot_clef))
}
commentaire_df %>%  
  filter(nom_ville == "ISSY LES MOULINEAUX") %>% 
  prnt_com_ass("quartier")

