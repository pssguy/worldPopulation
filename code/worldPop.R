output$worldPop <- renderInfoBox({
  invalidateLater(1000, session)
  popMid2015 <- 7324780000
  persec <- 2.541385
  
  then <-  strptime("2015-06-01 00:00:00 PDT", "%Y-%m-%d %H:%M:%OS")
  timeDiff <- as.numeric(difftime(Sys.time(),then,units="secs"))
  pop <- format(popMid2015+round((timeDiff)*persec), big.mark = ",")
  
  
  infoBox(
    "World Population", pop, icon = icon("calculator"),
    color = "purple"
  )
})