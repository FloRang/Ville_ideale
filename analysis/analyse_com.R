R.utils::sourceDirectory("fonctions")
library(here)
library(tidytext)
library(tidyverse)
library(SnowballC)
library(tm)



commentaire_df <- read_csv("cache/extrait_to_250.csv")

no_info <- read_csv(here("data", "mot_sans_info.csv"))

stop_words_fr <- read_delim(file = here("data", "stopwords_fr.txt"), 
                            delim = "\\n", col_names = FALSE)

com_token <- get_com_token(commentaire_df = commentaire_df,
                           stop_words_fr = stop_words_fr, 
                           no_info = no_info)

occurences <-  com_token %>%
  mutate(racine = wordStem(mot, language = "french")) %>% 
  count(racine, sort = TRUE)


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


