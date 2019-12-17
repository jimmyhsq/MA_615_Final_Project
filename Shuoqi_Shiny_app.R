
library(shiny)
library(leaflet)
library(rgdal)
library(RColorBrewer)

data <- read_csv("Clean_airbnb_boston.csv")
data_crime <- read_csv("crime_2017.csv")
data_price <- data

ui <- bootstrapPage(
    tags$style(type = "text/css", "html, body{width:100%;height:100%}"),
    leafletOutput("map", width = "100%", height = "100%"),
    absolutePanel(top = 20, right = 50,
                  sliderInput("range", "Price", 
                  min(data_price$price), max(data_price$price),
                  value = range(data_price$price), step = 80),
                  selectInput("crimetype","Please select the type of crime",unique(data_crime$OFFENSE_CODE_GROUP))
                  )
)

server <- function(input, output, session) {

    output$map <- renderLeaflet({
        data_crime = data_crime %>% filter(OFFENSE_CODE_GROUP %in% input$crimetype)
        data_price = data_price %>% filter(data_price$price >= input$range[1] & data_price$price <= input$range[2])
        leaflet(data=data_price) %>%
            addProviderTiles(providers$Esri.NatGeoWorldMap)%>%
            addMarkers(lng = ~ longitude, lat = ~ latitude,
            label = paste("Price = $", data_price$price,
                        "Location = ", data_price$neighborhood))%>%
            addCircles(lng = data_crime$Long,lat = data_crime$Lat, color = "red")
 })

            
        
    }
    


# Run the application 
shinyApp(ui = ui, server = server)
