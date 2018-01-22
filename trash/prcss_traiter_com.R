#prcss traiter 
traiter_com <- function(com_token_brut, stop_words_fr, no_info) {
  
  #On enleve les accents, les chiffres, les particules
  com_token_traite <- com_token_brut %>%  
    mutate(mot = stringi::stri_trans_general(mot,"latin-ascii")) %>%
    mutate(mot = str_replace_all(mot, pattern = "(l|d|j|qu|n|s|c)'", replacement = "")) %>%
    filter(str_detect(mot, pattern = "[:alpha:]"))  %>% 
    filter(!str_detect(mot, pattern = "\\d")) %>% #Enlever les mots avec chiffre
    anti_join(no_info) %>% 
    anti_join(stop_words_fr, by = c("mot" = "X1")) 
  
  com_token_traite
}


