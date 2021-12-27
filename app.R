# Load packages
library(shiny)

# Define UI
ui <- fluidPage(
  # App title
  titlePanel("Bike-sharing Open Data"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Slider for the number of bins ----
      selectInput(inputId = "city",
                  label = "Nombre de la ciudad / Name of the city",
                  choices = list("Madrid" = 1, "Zaragoza" = 2, "Elche" = 3))
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
    )
  )
)
