# On tokenise la base et on traite certains cas particuliers
library(here)
library(tidytext)
library(tidyverse)
library(SnowballC)


get_com_token <- function(commentaire_df, 
                          stop_words_fr, 
                          no_info) {
library(tidyverse)
library(tidytext)
  
commentaires <-  commentaire_df %>% 
  mutate(com = str_replace_all(com , pattern = "([:upper:])", replacement = " \\1")) %>% 
  unnest_tokens(output = mot, input = com)  

commentaires  <- anti_join(commentaires, stop_words_fr, 
                           by = c("mot" = "X1"))


#On enleve les accents, les chiffres, les particules
com_token <- commentaires %>%  
  mutate(mot = stringi::stri_trans_general(mot,"latin-ascii")) %>%
  mutate(mot = str_replace_all(mot, pattern = "(l|d|j|qu|n|s|c)'", replacement = "")) %>%
  filter(str_detect(mot, pattern = "[:alpha:]"))  %>% 
  filter(!str_detect(mot, pattern = "\\d")) %>% #Enlever les mots avec chiffre
  anti_join(no_info) %>% 
  anti_join(stop_words_fr, by = c("mot" = "X1")) 

com_token

}