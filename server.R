
shinyServer(function(input, output,session) {
  
  
  getCountries = function(data,location,session){
    
    if(is.null(data)) return(NULL)
    theSubGroup <- data$subGroup
    print(theSubGroup)
    
    observe({
      # determine countries for subGroup
      temp3 <- countries %>% 
        filter(subGroup==theSubGroup) %>% 
        select(Location=Country)
     
      print(glimpse(temp3)) 
      print(str(temp3))
      
      # collate data and produce graph
    ctries <-  temp3 %>% 
        left_join(avPop)# %>% 
       # filter(subGroup==theSubGroup) 
    
    print(glimpse(ctries))
      
    
    ctries <- cbind(ctries, id = seq_len(nrow(ctries)))
    
    ctrie_values <- function(x) {
      if(is.null(x)) return(NULL)
      row <- ctries[ctries$id == x$id,c("Time","Location","PopTotal") ]
      paste0( format(row), collapse = "<br />")
    }
    
      
    ctries   %>% 
        group_by(Location) %>% 
        #summarize(totPop=sum(PopTotal)) %>% 
        ggvis(~Time,~PopTotal) %>% 
      layer_points(size :=20,fill =~Location) %>% 
     # add_tooltip(ctrie_values, "hover") %>%
       # layer_lines(stroke =~Location, strokeWidth :=3) %>% 
        add_axis("x",title="Year",format="####") %>% 
        add_axis("y",title="") %>% 
      #  hide_legend("fill") %>% 
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
      temp2 <- countries %>% 
        filter(Continent==theContinent) %>% 
        select(Country,subGroup) 
      
      # collate data and produce graph
    groups <-  avPop %>% 
        left_join(temp2,by=c("Location"="Country")) %>% 
        filter(!is.na(subGroup)) %>% 
        group_by(subGroup,Time) %>% 
        summarize(totPop=sum(PopTotal))
   print(glimpse(groups)) 
    
    groups <- cbind(groups, id = seq_len(nrow(groups)))
    
    group_values <- function(x) {
      if(is.null(x)) return(NULL)
      row <- groups[groups$id == x$id,c("Time","subGroup","totPop") ]
      paste0( format(row), collapse = "<br />")
    }
      
      
    groups     %>% 
        ggvis(~Time,~totPop, key := ~id) %>% 
      #  layer_lines(stroke =~subGroup, strokeWidth :=5) %>% 
        layer_points(size :=20,fill =~subGroup) %>% 
         add_tooltip(group_values, "hover") %>%
        add_axis("x",title="Year",format="####") %>% 
        add_axis("y",title="") %>% 
        handle_click(getCountries) %>% 
        hide_legend("fill") %>% 
        bind_shiny("subGroups")
    
  })
  }
    
 
  
  conts <- avPop %>% 
    filter(Location %in% continents)

  
  
  
 # set up tooltip info
  conts <- cbind(conts, id = seq_len(nrow(conts)))
  
  continent_values <- function(x) {
    if(is.null(x)) return(NULL)
    row <- conts[conts$id == x$id,c("Time","Location","PopTotal") ]
    paste0( format(row), collapse = "<br />")
  }
  
  print(glimpse(conts))
  
 conts %>% 
   group_by(Location) %>% 
    ggvis(~Time,~PopTotal) %>% # once key := ~id is removed charts hows
   layer_points(size :=20,fill = ~Location) %>% 
  #  add_tooltip(continent_values, "hover") %>%
   # hide_legend("fill") %>% 
    add_axis("x",title="Year",format="####") %>% 
    add_axis("y",title="") %>% 
    handle_click(getGroups) %>% 
    bind_shiny("continents")




})

