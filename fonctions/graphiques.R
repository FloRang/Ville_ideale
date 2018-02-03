#Fonctions pour créer graphiques
#Potentiellement les réunir dans une seule et même fonction
#Cependant problème de compatibilité entre NSE et ggplot2 pour le moment. 

plot_mots <- function(df, var_to_plot, nom_ville, nb_select = 20) {
  quo_var <- enquo(var_to_plot)
  var_name <- quo_name(quo_var)
  
  nb_com <- summarise(df, n = n_distinct(num_com))
  
 comptage_mots <- df %>% 
    count(!!quo_var) %>% 
    mutate(proportion = n / nb_com$n) %>% 
    top_n(nb_select, proportion) %>% 
    mutate(!!var_name := fct_reorder(!!quo_var, proportion)) 
    
   comptage_mots %>% 
   ggplot(aes_string(x = var_name, y = "proportion")) +
    geom_col(fill = "black", alpha = 0.1) + 
    geom_text(aes_string(label = var_name, x = var_name), hjust =  0, y = 0) + 
    coord_flip() +
    theme_void() +
    labs(title = nom_ville) +
    theme(plot.title = element_text(size = 18, face = "bold", family = "Avenir"))#+
  #geom_hline(yintercept = seq(grid, grid^2, by = grid), col = "white") 
}

