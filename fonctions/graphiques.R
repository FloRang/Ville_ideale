#Fonctions pour créer graphiques
#Cependant problème de compatibilité entre NSE et ggplot2 pour le moment. 




plot_mots <- function(df, var_to_plot, nb_select = 20) {
  quo_var <- enquo(var_to_plot)
  quo_var_str <- quo_name(quo_var)

  title <- paste(str_to_title(unique(df$nom_ville)), quo_var_str)

  
  top_words <- df %>% 
    top_n(n = nb_select, wt = !!quo_var)
  
  
  top_words %>%
   mutate(expression = fct_reorder(expression, !!quo_var)) %>% 
   ggplot(aes_string(x = "expression", y = quo_var_str)) +
    geom_col(fill = "black", alpha = 0.1) + 
    geom_text(aes(label = expression, x = expression), hjust =  0, y = 0) + 
    coord_flip() +
    theme_void() +
    labs(title = title) +
    theme(plot.title = element_text(size = 18, face = "bold", family = "Avenir"))#+
  #geom_hline(yintercept = seq(grid, grid^2, by = grid), col = "white") 
}


