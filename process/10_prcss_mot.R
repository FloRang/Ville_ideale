# pipeline pour traiter les commentaires 
R.utils::sourceDirectory("fonctions")
library(tidytext)
library(tidyverse)
library(SnowballC)

#nom_fichier_coms_brut <- "cache/extrait_to_250.csv"
nom_fichier_coms_brut <- "cache/paris/paris_light_com_brut.csv"

commentaire_df <- read_csv(nom_fichier_coms_brut) %>% 
  rowid_to_column(var = "num_com")

no_info <- read_csv("data/mot_sans_info.csv")

stop_words_fr <- read_delim(file = "data/stopwords_fr.txt", 
                            delim = "\\n", col_names = FALSE)
racine_mot <- read_csv("data/bdd_racine_mot.csv") %>% rename(mot_new = mot)



# Tokenisation ------------------------------------------------------------

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



# Seulements points négatifs ----------------------------------------------

com_df_negatifs <- commentaire_df %>%  
  mutate(com = str_replace_all(com, 
                               pattern = "[\\s\\S]*(Les points négatifs[\\s\\S]+)",
                               replacement = "\\1")) %>%  
  mutate(com = str_remove(com, pattern = "Les points négatifs"))



# Il manque le 8e et le premier qui ont peu de commentaires-----------------------------

commentaire_outliers_paris <- read_csv("cache/paris/paris_outliers_com_brut.csv") %>% 
  rowid_to_column(var = "num_com") %>%  
  mutate(com = str_replace_all(com, 
                               pattern = "[\\s\\S]*(Les points négatifs[\\s\\S]+)",
                               replacement = "\\1")) %>%  
  mutate(com = str_remove(com, pattern = "Les points négatifs")) %>%  
  mutate(num_com = num_com + nrow(com_df_negatifs))


com_df_negatifs <- bind_rows(com_df_negatifs, commentaire_outliers_paris) %>%  
  get_com_token(token = "ngrams", 
                n = 1) %>% 
  traiter_com_simpl()


mots_interdits <- c(stop_words_fr$X1, no_info$mot)

#Enlever mots interdits
com_neg_traite <- com_df_negatifs %>% 
  filter(!mot %in% mots_interdits) 

#Appliquer racinisation
com_neg_traite <- com_neg_traite %>% 
  mutate(rac = wordStem(mot, language = "french")) %>% 
  left_join(racine_mot, by = c("rac" = "racine"))   %>% 
  mutate(mot_new = if_else(is.na(mot_new),
                           true = mot,
                           false = mot_new)) %>% 
  select(num_com, nom_ville, id_ville, codpost, dep, num_page,  mot_new) %>% 
  rename(mot = mot_new)

write_csv(com_df_negatifs, path = "cache/paris/paris_com_neg_tidy.csv")
write_csv(com_neg_traite, path = "cache/paris/paris_com_neg_clean.csv")


