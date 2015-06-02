
shinyServer(function(input, output,session) {
  
  source("code/charts.R", local=TRUE)
  source("code/maps.R", local=TRUE)
  source("code/maps2015.R", local=TRUE)
  source("code/tables.R", local=TRUE)
  source("code/worldPop.R", local=TRUE)
  
  
  output$sg_front <- renderStreamgraph({
    
    avPop %>% 
      filter(Location %in% continents) %>% 
      group_by(Time) %>% 
      mutate(worldPop=sum(PopTotal),pc=round(100*PopTotal/worldPop,1))%>%
      streamgraph(key="Location",value="pc",date="Time")

  })

})

