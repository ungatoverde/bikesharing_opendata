# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
#TODO: 
# - Add motivational dashboard boxes showing how many measures did the user do
# - Add more details to assessment tool according to tool of Marloes
# - Add DT tables
# - Factor columns to set order
# - Languages
# - Different colors for different values in measurements
# - Add input to user data and hide the input until the user authenticate with password

######## Preparation ######

# Load packages that are needed for this script
library(shiny)
library(shinydashboard)
library(flexdashboard)
#library(shinyjs)

library(leaflet)
library(htmltools)

library(dplyr)
library(readr)
library(ggplot2)

# Read measurement data
# Read geo_dictionary
geo_dictionary <-
  read.csv("background_data/own_output/geo_dictionary.csv")
# Read OPBE data
obpe_data <-
  read.csv("background_data/obpe_dataset_for_r.csv")

######## User interface ######

# HEADER of the dashboard
header <- 
  shinydashboard::dashboardHeader(title= HTML("Bike-sharing Open Data"),
                                  # Set width of dashboardHeader
                                  titleWidth = 300)
# Add logo to header
header$children[[2]]$children[[2]] <-
  header$children[[2]]$children[[1]]

header$children[[2]]$children[[1]] <-
  tags$a(
    # href = 'http://https://github.com/PawanRamaMali',
    tags$img(
      src = "/logo_obpe.png",
      height = '50px',
      width = '50px',
      align = 'left'),
    target = '_blank')

# SIDEBAR of the dashboard
sidebar <- 
  shinydashboard::dashboardSidebar(
    sidebarMenu(
      # Intro
      menuItem("Introduction", tabName= "intro", icon = icon("book-open")),
      # Data and subitems
      menuItem("Data", tabName = "agg_data", icon = icon("chart-bar")),
      # Maps and subitems
      menuItem("Map", tabName = "map", icon = icon("map")),
    # Width of the sidebar
    width = 300))

# BODY of the dashboard
body <-
  shinydashboard::dashboardBody(
    tabItems(
      tabItem(tabName= "intro",
              h1("Introduction"),
              "Place holder to explain the content of this website"),
      
      # Input for the aggregated data
      tabItem(tabName= "agg_data",
              h1("Aggregated EMF exposure data from the ETAIN app data"),
              #Two rows
              fluidRow(
                column(width = 3,
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
                #column(width = 3)
                ),

              # The output is a text showing the selection
              textOutput(outputId = "selected_city"),
              # Show a plot of the generated distribution
              #plotOutput(outputId = "exposure_byYear"),
              # Add header for download
              h2("Download data"),
              "Only the data shown in the figure above:",
              # Add the download button
              #downloadButton(outputId = "download_data_toPlot_csv", 
                             #label = "Download as csv file"),
              br(), # Line break
              br(), # Line break
              "All data:"
              #,
              # Add the download button
              #downloadButton(outputId = "download_agg_data_csv", 
                             #label = "Download as csv file")
              ),
      

      tabItem(tabName= "map",
              h1("Map of bike-sharing schemes"))))
      

# Define the UI (user interface) for the web application
ui <- shinydashboard::dashboardPage(
  # Define the background color of the dashboard
  skin = "green",
  header = header,
  sidebar = sidebar,
  body = body)


######## Server ######

# Define server logic required to produce the outputs
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
  
  # Prepare the aggregated data for the plot
  #agg_data_toPlot <- 
    #reactive({
      
    #})
  
  
  # Represent in a chart 
  #output$exposure_byYear <- renderPlot({
    #agg_data_toPlot()%>%
      #ggplot(aes(x=year, y=mean_exposure, fill=country))+
      #geom_col(position="dodge")+
      #geom_text(aes(label=round(mean_exposure, 1)), 
                #vjust = -0.5,
                #position = position_dodge(width = .9))+
      #facet_wrap(vars(wave_type))+
      #ylab("average exposure (-1*dBm)")
    
  #})
  
  
  # Download the data of the figure
  # output$download_data_toPlot_csv <- downloadHandler(
  #   filename = function() {
  #     paste0("bikesharing_dataFromFigure-", Sys.Date(), ".csv")
  #   },
  #   content = function(filename) {
  #     write.csv(agg_data_anonym(), filename)
  #   }
  # )
  
  # Anonimyzed data to export
  #agg_data_anonym <- 
    #reactive({
      #data%>%
        #dplyr::select(-c(user_id, gps_latitude, gps_longitude, coordinates))
    #})
  
  # 
  # # Download the aggregated data
  # output$download_agg_data_csv <- downloadHandler(
  #   filename = function() {
  #     paste0("bikesharing_data-", Sys.Date(), ".csv")
  #   },
  #   content = function(filename) {
  #     write.csv(agg_data_anonym(), filename)
  #   }
  # )
  
  # Create a map
  # output$map_base <- renderLeaflet({
  #   
  #   
  #   leaflet::leaflet(data,
  #                    options=leaflet::leafletOptions(zoomControl = FALSE,
  #                                                    maxZoom = 10,
  #                                                    minZoom = 2)) %>% 
  #     # Add background map
  #     leaflet::setView(lng = 20, lat = 48, zoom = 5) %>% 
  #     leaflet::addTiles()%>%
  #     leaflet::addProviderTiles(
  #       providers$Stamen.TonerLite,
  #       options = providerTileOptions(
  #         noWrap = TRUE))%>%
  #     # Add points and value of measurement
  #     leaflet::addCircleMarkers(
  #       lng = ~gps_longitude, lat = ~gps_latitude,
  #       popup = ~htmltools::htmlEscape(paste0("Exposure: ",exposure, "dBm")),
  #       clusterOptions = markerClusterOptions())
  # })
  # 

  
  
}





# Run the application 
shinyApp(ui = ui, server = server)
