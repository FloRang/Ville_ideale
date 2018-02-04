# pipeline pour traiter les commentaires 
R.utils::sourceDirectory("fonctions")
library(tidytext)
library(tidyverse)
library(SnowballC)

commentaire_df <- read_csv("cache/extrait_to_250.csv") %>% 
  rowid_to_column(var = "num_com")

no_info <- read_csv("data/mot_sans_info.csv")

stop_words_fr <- read_delim(file = "data/stopwords_fr.txt", 
                            delim = "\\n", col_names = FALSE)
racine_mot <- read_csv("data/bdd_racine_mot.csv") %>% rename(mot_new = mot)


df_token <- commentaire_df %>% 
  get_com_token(token = "ngrams", 
                n = 3) %>% 
  traiter_com_simpl() %>%
  separate(mot, c("mot1", "mot2", "mot3"), sep = " ") 


mots_interdits <- c(stop_words_fr$X1, no_info$mot)

#Enlever mots interdits
com_traite <- df_token %>% 
  filter(!mot1 %in% mots_interdits) %>% 
  mutate(mot2 = if_else(mot2 %in% mots_interdits,
                        true = mot3,
                        false = mot2)) %>%  
  filter(!mot2 %in% mots_interdits) 

#Appliquer racinisation
com_traite <- com_traite %>% 
  mutate(rac1 = wordStem(mot1, language = "french")) %>% 
  mutate(rac2 = wordStem(mot2, language = "french")) %>%
  left_join(racine_mot, by = c("rac1" = "racine"))  %>% 
  left_join(racine_mot, by = c("rac2" = "racine"), suffix = c("1", "2")) %>%
  mutate(mot_new1 = if_else(is.na(mot_new1),
                            true = mot1,
                            false = mot_new1)) %>%
  mutate(mot_new2 = if_else(is.na(mot_new2),
                            true = mot2,
                            false = mot_new2))

# Creer couple mot 
com_traite <- com_traite %>%
  mutate(deux_mots =  paste(mot_new1, mot_new2)) %>% 
  rename(mot = mot_new1) %>% 
  select(-mot_new2, -mot1, -mot2, -mot3, -rac1, -rac2) 


write_rds(com_traite, path = "cache/com_traite.rds")
