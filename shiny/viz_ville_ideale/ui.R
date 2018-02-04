# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Mots les plus fréquents"),
  #TODO Automatiser la slider Bar
  #TODO Complétion automatique de la barre
  #TODO Déu-bugguer le cas où le nombre de mots n'est pas défini. 
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       selectInput("choix_ville",
                   "Ville choisie:",
                   ville_dispo)
    ),
    
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("plot_simple"),
      plotOutput("plot_tf_idf")
    )
  )
))
