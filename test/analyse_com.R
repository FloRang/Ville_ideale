R.utils::sourceDirectory("Fonctions")
library(here)
library(tidytext)
library(tidyverse)

#AUtomatisr l'écriture 
commentaires <- 2:5 %>%  
  map(~ get_comment(id_ville = 'sevres_92072', num_page =  .x)) %>% 
  map(function(x) str_split(x, pattern = " ")) %>%  
  map(function(x) map_dfr(x, ~ tibble(texte = .x), .id = 'id_com')) %>% 
  map_dfr(as_tibble, .id = "id_page") %>% 
  unnest_tokens(mot, texte)
 


stop_words_fr <- read_delim(file = here("data", "stopwords_fr.txt"), 
                            delim = "\\n", col_names = FALSE)

commentaires  <- anti_join(commentaires, stop_words_fr, 
                           by = c("mot" = "X1"))

#Il faudrait enlever les accents
commentaires %>%  
  count(mot, sort = TRUE) %>%  View


#Reprex à faire pour améliorer ma pipeline
# my_list <- list(tibble(X1 = rnorm(5)), tibble(X1 = rnorm(5)))
# my_list
# 
# 

