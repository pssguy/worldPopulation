# front page map for current year
output$densityMap2015 <- renderLeaflet({
  
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
  
  print(names(countries2))
  print(countries2$Country)
  
  leaflet(data = countries2) %>%
    addTiles() %>%
    setView(lng=0,lat=0,zoom= 1.1) %>% 
    addPolygons(fillColor = ~pal(PopDensity), 
                fillOpacity = 0.6, 
                color = "#BDBDC3", 
                weight = 1, 
                layerId = ~Country,
                popup = countries2$popUp) %>% 
    # addLegend(pal=pal, values = ~densityRange) %>% 
    #     addLegend(#colors = c(RColorBrewer::brewer.pal(6, "YlGnBu"), "#808080"),  
    #               colors = c(RColorBrewer::brewer.pal(6, "Reds"), "#808080"), 
    #               bins = 7, 
    #               position = 'bottomright', 
    #               title = "Density Range", 
    #               labels = labs) %>% 
    mapOptions(zoomToLimits="first")
  
})


#output$countryMapChart <- renderPlot({
observe({
print("enter")
  print(input$densityMap2015_shape_click$id)
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
    bind_shiny("countryMapChart")
  
})