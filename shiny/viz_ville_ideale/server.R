R.utils::sourceDirectory(here("fonctions"))


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  
  df_filtre <- reactive({
    com_traite_long %>%
      filter(nom_ville == input$choix_ville)
  })
  
  
  output$plot_tf_idf <- renderPlot({
    df_filtre() %>%
      plot_mots(tf_idf, nb_select = 20)
  })
  
  output$plot_simple <- renderPlot({
    df_filtre() %>%
      plot_mots(n, nb_select = 20)
  })
  
  
})
