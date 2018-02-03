R.utils::sourceDirectory(here("fonctions"))


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
