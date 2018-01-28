#
library(shiny)
R.utils::sourceDirectory("fonctions")
library(here)
library(tidytext)
library(tidyverse)


com_traite <- read_rds(path = here("cache","com_traite.rds"))
com_traite_long <- com_traite %>%   
  gather(key = nb_mot, value = expression, mot, deux_mots) %>% 
  mutate(nb_mot = fct_recode(nb_mot, "un_mot" = "mot"))
# com_traite <- com_traite %>% 
#   mutate(nom_ville = str_to_title(nom_ville))



# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  
  df_filtre <- reactive({
  com_traite_long %>%
    filter(nom_ville == input$choix_ville)
  })
  
  
  output$plot_simple <- renderPlot({
    df_filtre() %>%
      filter(nb_mot %in% input$nombre_mots) %>% 
      plot_mots(expression, input$choix_ville, nb_select = 10)
  })
  
  
})
