#Analyse paris saleté
library(tidyverse)
com_paris_neg <- read_csv("cache/paris/paris_com_neg_clean.csv")

mots_sans_infos <- tibble(mot = c("rue", "quartier", "paris", "arrondissement", "mairie"))


# Le 16e a été compté deux fois -------------------------------------------
com_paris_neg <- com_paris_neg %>% 
  filter(codpost != 75116)  %>%  
  anti_join(mots_sans_infos, by = "mot")

#Pour trouver les mots du champ lexical de la saleté
com_paris_neg %>%  
  count(mot) %>%  
  top_n(n = 500, wt = n) %>%  View

nb_com_neg <- com_paris_neg %>% 
  group_by(nom_ville) %>% 
  summarise(n = n_distinct(num_com)) 

#On ne s'interesse qu'à certains mots du champ lexical de la salete
com_paris_neg_sale <- com_paris_neg %>%  
  group_by(num_com) %>% 
  filter(mot %in% c("sale", "salete", "propre", "crottes", "dejections", "poubelles", 
                        "nettoyage", "dechet", "detritus", "excrements", "poubelle",
                        "ordures")) 


totaux_neg_sale <- com_paris_neg_sale %>%  
  group_by(nom_ville) %>% 
  summarise(n_sale = n_distinct(num_com)) %>%  
  right_join(nb_com_neg, by = "nom_ville") %>%  
  replace_na(replace = list(n_sale = 0)) %>%  
  mutate(prop = n_sale / n) %>%  
  arrange(desc(prop))

write_csv(totaux_neg_sale,"~/Documents/Challenge_Lincoln/OpenDataParis/Donnees/totaux_neg_sale.csv")

write_csv(com_paris_neg_sale,"~/Documents/Challenge_Lincoln/OpenDataParis/Donnees/com_paris_neg_sale.csv")
