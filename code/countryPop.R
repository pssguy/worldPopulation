
output$countryPopDen <- renderInfoBox({
  
  pop <- popRank %>% 
    filter(Location==input$country) %>% 
    .$denRank
  
  infoBox(
    "Density Rank", pop, icon = icon("calculator"),
    color = "purple"
  )
  
  
})
output$countryPopRank <- renderInfoBox({
  
  pop <- popRank %>% 
    filter(Location==input$country) %>% 
    .$popRank
  
  infoBox(
    "Population Rank", pop, icon = icon("calculator"),
    color = "purple"
  )
  
  
})

output$countryPop <- renderInfoBox({
  invalidateLater(1000, session)
  years <- c(2015,2016)
  df <- avPop %>% 
    filter(Location==input$country&Time %in% years)
  
  pop2015 <- df$PopTotal[1]*1000000
  pop2016 <- df$PopTotal[2]*1000000
  
  persec <- (pop2016-pop2015)/31557600
  
  
  then <-  strptime("2015-06-01 00:00:00 PDT", "%Y-%m-%d %H:%M:%OS")
  timeDiff <- as.numeric(difftime(Sys.time(),then,units="secs"))
  pop <- format(pop2015+round((timeDiff)*persec), big.mark = ",")
  
  
  infoBox(
    "Current Population", pop, icon = icon("calculator"),
    color = "purple"
  )
  
  
})



observe({
#  output$countryChart <- renderPlot({
  if(is.null(input$country)) return()
  print(input$country)
  ctries <- avPop %>% 
    filter(Location==input$country)
 
  
  
  ctries <- cbind(ctries, id = seq_len(nrow(ctries)))
  
  ctrie_values <- function(x) {
    if(is.null(x)) return(NULL)
    row <- ctries[ctries$id == x$id,c("Time","PopTotal") ]
    paste0( format(row), collapse = "<br />")
  }
  
  print(glimpse(ctries))
  
  ctries   %>% 
    #group_by(Country) %>% 
    #summarize(totPop=sum(PopTotal)) %>% 
    ggvis(~Time,~PopTotal, key:=~id) %>% 
    layer_points(size :=20,fill := "red") %>% 
     add_tooltip(ctrie_values, "hover") %>%
    # layer_lines(stroke =~Location, strokeWidth :=3) %>% 
    add_axis("x",title="Year",format="####") %>% 
    add_axis("y",title="") %>% 
    set_options(height = 300, width = 300) %>% 
    #  hide_legend("fill") %>% 
    bind_shiny("countryChart")
  
})
