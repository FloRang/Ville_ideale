# Analyse 2-grams
#Idée: Voir à quels mots sont liés le mot "manque". 

R.utils::sourceDirectory("fonctions")
library(here)
library(tidytext)
library(tidyverse)
library(SnowballC)
library(tm)

source("fonctions/traite_com_2_gram.R") # creer com

# TODO Enlever le source et tout mettre sous forme de fonctions

commentaire_df <- read_csv("cache/extrait_to_250.csv")

no_info <- read_csv(here("data", "mot_sans_info.csv"))

stop_words_fr <- read_delim(file = here("data", "stopwords_fr.txt"), 
                            delim = "\\n", col_names = FALSE)

com_2_gram %>%   
  count(mot, sort = TRUE)  %>%
  top_n(30, n) %>% 
  ggplot(aes(x = n, y = fct_reorder(mot, n))) +
  geom_point(fill = "black") + 
  theme_light()

# TODO Essayer de attribuer un numéro de commentaire pour qu'il soit ensuite 
# facilement retrouvable. 
com_2_gram %>%   
  filter(nom_ville == "ISSY LES MOULINEAUX") %>% 
  count(mot, sort = TRUE)  %>%
  top_n(10, n) %>% 
  ggplot(aes(x = n, y = fct_reorder(mot, n))) +
  geom_point(fill = "black") + 
  theme_light()


com_2_gram %>%   
  filter(nom_ville == "LEVALLOIS PERRET" & mot1 == "manque") %>% 
  count(mot, sort = TRUE)  %>%
  top_n(10, n) %>% 
  ggplot(aes(x = n, y = fct_reorder(mot, n))) +
  geom_point(fill = "black") + 
  theme_light()




