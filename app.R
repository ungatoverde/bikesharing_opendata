# Clear environment
rm(list=ls())

# Load packages
library(shiny)
library(dplyr)
library(readr)

# Read geo_dictionary
geo_dictionary <-
  read.csv("background_data/own_output/geo_dictionary.csv")


#TODO: Add conditional list 

# Define UI.
ui <- fluidPage(
  # App title
  titlePanel("Bike-sharing Open Data"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      # Input: Slider for the number of bins
      selectizeInput(inputId = "region",
                     label = "Nombre de la comunidad autónoma / Name of the region",
                     choices = geo_dictionary %>% 
                       group_by(region_name) %>% 
                       summarize(.groups = "drop")%>%
                       pull(.)),
      # Input: Slider for the number of bins
      selectizeInput(inputId = "province",
                     label = "Nombre de la provincia / Name of the province",
                     choices = NULL),
      # Input: Slider for the number of bins
      selectizeInput(inputId = "city",
                     label = "Nombre de la ciudad / Name of the city",
                     choices = NULL)),
    
    # Main panel for displaying outputs ----
    mainPanel(
      # The output is a text showing the selection
      textOutput(outputId = "selected_city"))
    )
  )


# Define server function ----

server <- function(input, output, session) {
  
  # Conditional drop down filter
  # provinces filter
  observe({
    
    provinces_filtered <- 
      geo_dictionary %>% 
      filter(region_name == input$region) %>% 
      group_by(province_name) %>% 
      summarize(.groups = "drop")%>%
      pull(.)
    
    #provinces_filtered <- 
      #unique(geo_dictionary$province_name[geo_dictionary$region_name%in%input$region])
    
    updateSelectizeInput(session, "province", 
                         choices = provinces_filtered)
  })
  
  # cities filter
  observe({
    
    cities_filtered <- 
      geo_dictionary %>% 
      filter(province_name == input$province) %>% 
      group_by(city_name) %>% 
      summarize(.groups = "drop")%>%
      pull(.)
    
    updateSelectizeInput(session, "city", 
                         choices = cities_filtered)
  })
  
  
  # Print selected city
  output$selected_city <- renderText({ 
    paste("You have selected", input$city)
  })
  
}


# Run app ----
shinyApp(ui = ui, server = server)
