# On tokenise la base et on traite certains cas particuliers

get_com_token <- function(commentaire_df, ...) {
  library(tidyverse)
  library(tidytext)
  
  commentaires <-  commentaire_df %>% 
    mutate(com = str_replace_all(com , pattern = "([:upper:])", replacement = " \\1")) %>% 
    unnest_tokens(output = mot, input = com, ...)  
  
  commentaires
  
}


