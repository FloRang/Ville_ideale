R.utils::sourceDirectory("fonctions")
library(here)
library(tidytext)
library(tidyverse)

commentaire_df <- read_csv("cache/extrait_to_250.csv")
count(commentaire_df, nom_ville)

com_selct_brut <- commentaire_df  %>%
  filter(nom_ville == "CLAMART")

commentaires <-  com_selct_brut %>% 
  mutate(com = str_replace_all(com , pattern = "([:upper:])", replacement = " \\1")) %>% 
  unnest_tokens(output = mot, input = com)  


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


prnt_com_ass <-  function(commentaires_brut, mot_clef){
  commentaires_brut %>% 
  filter(str_detect(com, mot_clef)) %>%
    pull(com) %>% 
    map(~ str_view(.x, mot_clef))
}

prnt_com_ass(com_selct_brut, "manque")


