
shinyServer(function(input, output,session) {
  
  
  getCountries = function(data,location,session){
    
    if(is.null(data)) return(NULL)
    theSubGroup <- data$subGroup
    
    observe({
      # determine countries for subGroup
      temp2 <- countries %>% 
        filter(subGroup==theSubGroup) %>% 
        select(Country)
      
      
      # collate data and produce graph
      avPop %>% 
        left_join(temp,by=c("Location"="Country")) %>% 
        filter(subGroup==theSubGroup) %>% 
        group_by(Location) %>% 
        #summarize(totPop=sum(PopTotal)) %>% 
        ggvis(~Time,~PopTotal) %>% 
        layer_lines(stroke =~Location, strokeWidth :=3) %>% 
        add_axis("x",title="Year",format="####") %>% 
        add_axis("y",title="") %>% 
        hide_legend("fill") %>% 
        bind_shiny("countries")
      
    })
    
  }
  
  getGroups = function(data,location,session){
    print(data)
    if(is.null(data)) return(NULL)
    print(glimpse(data))
    
    theContinent <- data$Location
    session$output$check <- renderText({
      
      theContinent })
    
   # session$output$subGroup <- renderPlot({
      observe({
      # determine countries for subGroup
      temp <- countries %>% 
        filter(Continent==theContinent) %>% 
        select(Country,subGroup) 
      
      # collate data and produce graph
      avPop %>% 
        left_join(temp,by=c("Location"="Country")) %>% 
        filter(!is.na(subGroup)) %>% 
        group_by(subGroup,Time) %>% 
        summarize(totPop=sum(PopTotal)) %>% 
        ggvis(~Time,~totPop) %>% 
        layer_lines(stroke =~subGroup, strokeWidth :=5) %>% 
        add_axis("x",title="Year",format="####") %>% 
        add_axis("y",title="") %>% 
        handle_click(getCountries) %>% 
        hide_legend("fill") %>% 
        bind_shiny("subGroups")
    
  })
  }
    
    #    session$output$standings <- DT::renderDataTable({
    #     theDivision <-  all %>% 
    #         filter(Season==theSeason&team==input$team) %>% 
    #         .$division
    #       
    #       all %>% 
    #         filter(Season==theSeason&division==theDivision) %>% 
    #         arrange(Position) %>% 
    #         
    #         select(team,Pl=GP,W,D,L,GD=gd,Pts) %>% 
    #         
    #         DT::datatable(options= list(scrollY = 500,paging = FALSE, searching = FALSE,info=FALSE))
    #       
    #     })
    #     
    #     session$output$results <- DT::renderDataTable({
    #       df %>% 
    #         filter(Season==theSeason&(home==input$team|visitor==input$team)) %>% 
    #         mutate(result=paste(hgoal,vgoal,sep=" - ")) %>% 
    #         select(Date,home,result,visitor) %>% 
    #         arrange(Date) %>% 
    #         DT::datatable(options= list(paging = FALSE, searching = FALSE,info=FALSE))
    #       
    #     })
    #     

  
  
  
  
  ## initial line graph by continent - no reactive
  avPop %>% 
    filter(Location %in% continents) %>% 
    group_by(Location) %>% 
    ggvis(~Time,~PopTotal) %>% 
    #layer_points(size :=3,fill =~Location) %>% 
    layer_lines(stroke =~Location, strokeWidth :=5) %>%
    add_axis("x",title="Year",format="####") %>% 
    add_axis("y",title="") %>% 
    handle_click(getGroups) %>% 
    bind_shiny("continents")




})

  ## function that receives season
  
#   getCountries = function(data,location,session){
#     
#     if(is.null(data)) return(NULL)
#     print(glimpse(data))
#     
#     theContinent <- data$Location
#     session$output$check <- renderText({
#       
#       theContinent })
    
#    session$output$standings <- DT::renderDataTable({
 #     theDivision <-  all %>% 
#         filter(Season==theSeason&team==input$team) %>% 
#         .$division
#       
#       all %>% 
#         filter(Season==theSeason&division==theDivision) %>% 
#         arrange(Position) %>% 
#         
#         select(team,Pl=GP,W,D,L,GD=gd,Pts) %>% 
#         
#         DT::datatable(options= list(scrollY = 500,paging = FALSE, searching = FALSE,info=FALSE))
#       
#     })
#     
#     session$output$results <- DT::renderDataTable({
#       df %>% 
#         filter(Season==theSeason&(home==input$team|visitor==input$team)) %>% 
#         mutate(result=paste(hgoal,vgoal,sep=" - ")) %>% 
#         select(Date,home,result,visitor) %>% 
#         arrange(Date) %>% 
#         DT::datatable(options= list(paging = FALSE, searching = FALSE,info=FALSE))
#       
#     })
#     
