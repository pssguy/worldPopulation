# attempt to return country name for further processing there is a maps.
# getMapData = function(data,location,session){
#   
#   print("mapdata")
#   
#   print(class(data)) #"leaflet"    "htmlwidget"
#   print(data$leaflet) #NULL
#   if(is.null(data$leaflet)) return()
#   print(data)
#   
#   if(is.null(data)) return(NULL)
#   
#   glimpse(data)
#          # if getMapData(map)) Error in nrow(tbl) : object 'map' not found
#   # if getMapData()) argument "data" is missing, with no default
# }


output$densityMap <- renderLeaflet({
  
  
  print(input$year)
  
  names(countries)[1]  <- "Country"
  # specific  combine with countries
  popData <- avPop %>% 
    filter(Location %in% countries$Country&Time==2015) %>% 
    rename(Country=Location) %>% 
    left_join(countries)
  
  # need to set as data.frame
  popData <- data.frame(popData)
  
  pal <- colorQuantile("Reds", NULL, n = 6)
  
  # create popup
  names(popData)
  popData$popUp <- paste0("<strong>", popData$Country, "</strong><br>",
                          
                          "<br><strong>Popuation (m): </strong>", popData$PopTotal,
                          "<br><strong>Density (per sq Km): </strong>", round(popData$PopDensity))
  
  popData$densityRange <-cut(popData$PopDensity,c(0,10,50,100,300,1000,30000))
  
  # now merge with map info
  countries2 <- sp::merge(mapData, 
                          popData, 
                          by.x = "iso_a3", 
                          by.y = "iso_a3",                    
                          sort = FALSE)
  # In .local(x, y, ...) : 9 records in y cannot be matched to x
  
  labs <- c("0-9","10-50","50-100","100-300","300-1000","1000-30000","NA")
  
  leaflet(data = countries2) %>%
    addTiles() %>%
    setView(lng=0,lat=0,zoom= 1.1) %>% 
    addPolygons(fillColor = ~pal(PopDensity), 
                fillOpacity = 0.6, 
                color = "#BDBDC3", 
                weight = 1, 
                popup = countries2$popUp) %>% 
    # addLegend(pal=pal, values = ~densityRange) %>% 
    #     addLegend(#colors = c(RColorBrewer::brewer.pal(6, "YlGnBu"), "#808080"),  
    #               colors = c(RColorBrewer::brewer.pal(6, "Reds"), "#808080"), 
    #               bins = 7, 
    #               position = 'bottomright', 
    #               title = "Density Range", 
    #               labels = labs) %>% 
    mapOptions(zoomToLimits="first")
  
#   print(input$year)
#   
#   names(countries)[1]  <- "Country"
#   # specific  combine with countries
#   popData <- avPop %>% 
#     filter(Location %in% countries$Country&Time==input$year) %>% 
#     rename(Country=Location) %>% 
#     left_join(countries)
#   
#   # need to set as data.frame
#   popData <- data.frame(popData)
#   
#   pal <- colorQuantile("Reds", NULL, n = 6)
#   
#   # create popup
#   names(popData)
#   popData$popUp <- paste0("<strong>",popData$Time," ", popData$Country, "</strong><br>",
#                           
#                           "<br><strong>Popuation (m): </strong>", popData$PopTotal,
#                           "<br><strong>Density (per sq Km): </strong>", round(popData$PopDensity))
#   
#   popData$densityRange <-cut(popData$PopDensity,c(0,10,50,100,300,1000,30000))
#   
#   # now merge with map info
#   countries2 <- sp::merge(mapData, 
#                           popData, 
#                           by.x = "iso_a3", 
#                           by.y = "iso_a3",                    
#                           sort = FALSE)
#   # In .local(x, y, ...) : 9 records in y cannot be matched to x
#   
#   labs <- c("0-9","10-50","50-100","100-300","300-1000","1000-30000","NA")
#   print("got here")
#   
#   
#  map <- leaflet(data = countries2) %>%
#     addTiles()
#  
# # print(str(map))
#  map
# 
# #   leaflet(data = countries2) %>%
# #     addTiles() %>%
# #     setView(lng=0,lat=0,zoom= 1.1) %>% 
# #     addPolygons(fillColor = ~pal(PopDensity), 
# #                 fillOpacity = 0.6, 
# #                 color = "#BDBDC3", 
# #                 weight = 1, 
# #                 layerId = countries2$name,
# #                 popup = countries2$popUp) %>% 
# #     
# #     # addLegend(pal=pal, values = ~densityRange) %>% 
# #     #     addLegend(#colors = c(RColorBrewer::brewer.pal(6, "YlGnBu"), "#808080"),  
# #     #               colors = c(RColorBrewer::brewer.pal(6, "Reds"), "#808080"), 
# #     #               bins = 7, 
# #     #               position = 'bottomright', 
# #     #               title = "Density Range", 
# #     #               labels = labs) %>% 
# #     mapOptions(zoomToLimits="first")
  
})



# output$mapData <- renderText(
#   #print("test data")
#   #print(input$densityMap_shape_click)
#   #input$densityMap_shape_click$lat
#   input$densityMap_shape_click$id
# )


output$countryMapChart <- renderPlot({
  
  
  if (is.null(input$densityMap2015_shape_click$id)) return()
  countryId <-input$densityMap2015_shape_click$id
  print(countryId)
  
  ctries <- avPop %>% 
    filter(Location==countryId)
  
  ctries <- cbind(ctries, id = seq_len(nrow(ctries)))
  
  ctrie_values <- function(x) {
    if(is.null(x)) return(NULL)
    row <- ctries[ctries$id == x$id,c("Time","PopTotal") ]
    paste0( format(row), collapse = "<br />")
  }
  
  ctries   %>% 
   
    ggvis(~Time,~PopTotal, key:=~id) %>% 
    layer_points(size :=20,fill := "red") %>% 
    add_tooltip(ctrie_values, "hover") %>%
    
    add_axis("x",title="Year",format="####") %>% 
    add_axis("y",title="") %>% 
    set_options(height = 400, width = 400) %>% 
    #  hide_legend("fill") %>% 
    bind_shiny()
  
})


# ## want to add this once I have click info sorted
# 
# observe({
#   
# #   if(is.null(input$country)) return()
# #   print(input$country)
# #   ctries <- avPop %>% 
# #     filter(Location==input$country)
# #   
#   print("enter observe")
# print(input$year)
#     ctries <- avPop %>% 
#       filter(Location=="India")
#     
#     print(glimpse(countries))
#   
#   ctries <- cbind(ctries, id = seq_len(nrow(ctries)))
#   
#   ctrie_values <- function(x) {
#     if(is.null(x)) return(NULL)
#     row <- ctries[ctries$id == x$id,c("Time","PopTotal") ]
#     paste0( format(row), collapse = "<br />")
#   }
#   
#   print(glimpse(ctries))
#   
#   ctries   %>% 
#     #group_by(Country) %>% 
#     #summarize(totPop=sum(PopTotal)) %>% 
#     ggvis(~Time,~PopTotal, key:=~id) %>% 
#     layer_points(size :=20,fill := "red") %>% 
#     add_tooltip(ctrie_values, "hover") %>%
#     # layer_lines(stroke =~Location, strokeWidth :=3) %>% 
#     add_axis("x",title="Year",format="####") %>% 
#     add_axis("y",title="") %>% 
#     set_options(height = 400, width = 400) %>% 
#     #  hide_legend("fill") %>% 
#     bind_shiny("countryMapChart")
#   
# })
