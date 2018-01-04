#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Mots les plus fréquents"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       selectInput("choix_ville",
                   "Ville choisie:",
                   c("Nanterre" =  "NANTERRE", 
                    "Antony" = "ANTONY", 
                    "Asnieres-sur-Seine" = "ASNIERES SUR SEINE", 
                    "Bagneux" = "BAGNEUX", 
                    "Bourg-la-Reine" = "BOURG LA REINE")
                   )
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("occurrence_plot")
    )
  )
))
