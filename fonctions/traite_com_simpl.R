library(tidyverse)

#'Enleve les accents, les chiffres, les particules
traiter_com_simpl <- function(com_token_brut) {
  
  com_token_traite <- com_token_brut %>%  
    mutate(mot = stringi::stri_trans_general(mot,"latin-ascii")) %>%
    mutate(mot = str_replace_all(mot, pattern = "(l|d|j|qu|n|s|c)'", replacement = "")) %>%
    filter(str_detect(mot, pattern = "[:alpha:]"))  %>% 
    filter(!str_detect(mot, pattern = "\\d"))
  
  com_token_traite
}


