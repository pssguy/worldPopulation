
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
    "Country Population", pop, icon = icon("calculator"),
    color = "purple"
  )
})