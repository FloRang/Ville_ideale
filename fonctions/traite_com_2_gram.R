library(tidyverse)
traiter_com_simpl <- function(com_token_brut) {
  
  #On enleve les accents, les chiffres, les particules
  com_token_traite <- com_token_brut %>%  
    mutate(mot = stringi::stri_trans_general(mot,"latin-ascii")) %>%
    mutate(mot = str_replace_all(mot, pattern = "(l|d|j|qu|n|s|c)'", replacement = "")) %>%
    filter(str_detect(mot, pattern = "[:alpha:]"))  %>% 
    filter(!str_detect(mot, pattern = "\\d"))
  
  com_token_traite
}


commentaire_df <- read_csv("cache/extrait_to_250.csv")

no_info <- read_csv(here("data", "mot_sans_info.csv"))

stop_words_fr <- read_delim(file = here("data", "stopwords_fr.txt"), 
                            delim = "\\n", col_names = FALSE)
racine_mot <- read_csv("data/bdd_racine_mot.csv") %>% rename(mot_new = mot)
 
 
suppr_mots_inut <- function(df, col_mot, df_to_suppr) {
  if (ncol(df_to_suppr) > 1) stop("Le data.frame à supprimer a plus d'une colonne")
  
  join1 <-  colnames(df_to_suppr)
  names(join1) <- col_mot
  
  df %>% 
    anti_join(df_to_suppr, by = join1) 
} 
 




#TODO Automatiser ce qui peut l'être


df_token <- commentaire_df %>% 
  get_com_token(token = "ngrams", 
                n = 3) %>% 
  traiter_com_simpl() %>%
  separate(mot, c("mot1", "mot2", "mot3"), sep = " ") 


mots_interdits <- c(stop_words_fr$X1, no_info$mot)
# TODO Finir automatisation
com_2_gram <- df_token %>% 
  suppr_mots_inut("mot1", no_info) %>% 
  suppr_mots_inut("mot1", stop_words_fr) %>%
  mutate(mot2 = if_else(mot2 %in% mots_interdits,
                        true = mot3,
                        false = mot2)) %>% 
  mutate(rac1 = wordStem(mot1, language = "french")) %>% 
  mutate(rac2 = wordStem(mot2, language = "french")) %>%
  left_join(racine_mot, by = c("rac1" = "racine"))  %>% 
  left_join(racine_mot, by = c("rac2" = "racine"), suffix = c("1", "2")) %>%
  mutate(mot_new1 = if_else(is.na(mot_new1),
                            true = mot1,
                            false = mot_new1)) %>%
  mutate(mot_new2 = if_else(is.na(mot_new2),
                            true = mot2,
                            false = mot_new2))  %>%
  unite(col = "mot", mot_new1, mot_new2, sep = " ") 
