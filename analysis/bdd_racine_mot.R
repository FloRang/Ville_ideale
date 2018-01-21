#Construction d'une base racinisation-vrai mots 
#afin de peaufiner le traitement des mots au pluriel etc. 


# La saisie de données est plus simple en Excel. 
R.utils::sourceDirectory("fonctions")
library(tidyverse)
library(tidytext)
library(here)

commentaire_df <- read_csv("cache/extrait_to_250.csv")

no_info <- read_csv(here("data", "mot_sans_info.csv"))

stop_words_fr <- read_delim(file = here("data", "stopwords_fr.txt"), 
                            delim = "\\n", col_names = FALSE)

com_token <- get_com_token(commentaire_df = commentaire_df,
                           stop_words_fr = stop_words_fr, 
                           no_info = no_info)

bdd_racine_mot <- com_token %>%
  mutate(racine = wordStem(mot, language = "french")) %>% 
  count(racine, sort = TRUE) %>% 
  top_n(200, n) %>% 
  select(racine) %>% 
  mutate(mot = racine) %>% 
  edit()

write_csv(bdd_racine_mot, "data/bdd_racine_mot.csv")


