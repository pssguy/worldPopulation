output$sg_front <- renderStreamgraph({
  
  avPop %>% 
    filter(Location %in% continents) %>% 
    group_by(Time) %>% 
    mutate(worldPop=sum(PopTotal),pc=round(100*PopTotal/worldPop,1))%>%
    streamgraph(key="Location",value="pc",date="Time")
  
})