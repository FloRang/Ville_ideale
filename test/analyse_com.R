R.utils::sourceDirectory("Fonctions")
library(here)
library(tidytext)
library(tidyverse)

#AUtomatisr l'écriture 
# Trouver le nombre de pages

id_ville <- get_id_ville("SURESNES")

# Une manière plus propre de le faire pourrait être
# Potentiellement simplifiable la colonne num_page est (presque) useless. 
#
# commentaire_df <-  tibble(id_ville = id_ville, num_page = seq(to = get_nb_pg(id_ville))) %>% 
#   mutate(com = map(get_comment(id_ville = id_ville, num_page = num_page)))%>% 
#   unnest(com)

# commentaires_df  %>%
#   rowid_to_column(var = "num_com") %>% 
#   unnest_tokens(output = mot, input = com) %>% 
#   mutate(texte = str_replace_all(texte, pattern = "([:upper:])", replacement = " \\1")) 


commentaires_brut <- id_ville %>%   
  get_nb_pg() %>% 
  seq(to = . ) %>%  
  map(~ get_comment(id_ville = id_ville, num_page =  .x)) 


# Il semblerait qu'il y ait une limite de requêtes consécutives sur ville ideale
# Il faudrait les espacer légèrement dans le temps. 


#C'est pas magnifique. Voir s'il n'y a pas moyen de le faire avec list-column. 
commentaires <- commentaires_brut %>% 
  map(function(x) str_split(x, pattern = " ")) %>%  
  map(function(x) map_dfr(x, ~ tibble(texte = .x), .id = 'id_com')) %>% 
  map_dfr(as_tibble, .id = "id_page") %>% 
  mutate(texte = str_replace_all(texte, pattern = "([:upper:])", replacement = " \\1")) %>% 
  unnest_tokens(mot, texte)
 
stop_words_fr <- read_delim(file = here("data", "stopwords_fr.txt"), 
                            delim = "\\n", col_names = FALSE)

commentaires  <- anti_join(commentaires, stop_words_fr, 
                           by = c("mot" = "X1"))

no_info <- read_csv(here("data", "mot_sans_info.csv"))

#On enleve les accents
occurences <- commentaires %>%  
  mutate(mot = stringi::stri_trans_general(mot,"latin-ascii")) %>%
  mutate(mot = str_replace_all(mot, pattern = "(l|d|j|qu|n|s|c)'", replacement = "")) %>%
  filter(str_detect(mot, pattern = "[:alpha:]"))  %>% 
  anti_join(no_info) %>% 
  anti_join(stop_words_fr, by = c("mot" = "X1")) %>% 
  count(mot, sort = TRUE)


occurences %>%
  slice(1:30) %>% 
  ggplot(aes(x = n, y = fct_reorder(mot, n))) +
  geom_point(fill = "black") + 
  theme_light()


prnt_com_ass <-  function(mot_clef){
  map_chr(commentaires_brut, function(x) keep(x, ~ str_detect(.x, mot_clef))) %>% 
    map(~ str_view(.x, mot_clef))
}

prnt_com_ass("paris")


map(commentaires_brut, function(x) keep(x, ~ str_detect(str_to_lower(.x), "paris"))) %>% 
  flatten_chr() %>% 
  str_to_lower() %>% 
  map(~ str_view(.x, "paris"))
