R.utils::sourceDirectory(here("fonctions"))


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  
  df_filtre <- reactive({
    name_ville_decoup <- str_split(input$choix_ville, pattern = " |-") %>% 
      flatten_chr() %>% 
      str_to_lower()
    
    com_traite_long %>%
      filter(nom_ville == input$choix_ville) %>% 
      filter(!expression %in% name_ville_decoup)
  })
  
  
  output$plot_simple <- renderPlot({
    df_filtre() %>%
      plot_mots(expression, input$choix_ville, nb_select = 20)
  })
  
  
})
