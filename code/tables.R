output$table <- DT::renderDataTable({
  
  years <- c(1950,2015,2099)
  names(countries)[1]  <- "Country"

  
  
  if (input$pop=="Population") {
  rank1950<- avPop %>% 
    filter(Location %in% countries$Country&Time==1950) %>% 
    rename(Country=Location) %>% 
    group_by(Time) %>% 
    arrange(desc(PopTotal)) %>% 
    mutate(rank=row_number(),pc=round(100*PopTotal/sum(PopTotal),2)) %>% 
    ungroup() %>% 
    select(Country,Pop_1950=PopTotal,pc_1950=pc,Rank_1950=rank)
  
  
  rank2015<- avPop %>% 
    filter(Location %in% countries$Country&Time==2015) %>% 
    rename(Country=Location) %>% 
    group_by(Time) %>% 
    arrange(desc(PopTotal)) %>% 
    mutate(rank=row_number(),pc=round(100*PopTotal/sum(PopTotal),2)) %>% 
    ungroup() %>% 
    select(Country,Pop_2015=PopTotal,pc_2015=pc,Rank_2015=rank)  
  
  
  
  rank2099<- avPop %>% 
    filter(Location %in% countries$Country&Time==2099) %>% 
    rename(Country=Location) %>% 
    group_by(Time) %>% 
    arrange(desc(PopTotal)) %>% 
    mutate(rank=row_number(),pc=round(100*PopTotal/sum(PopTotal),2)) %>% 
    ungroup() %>% 
    select(Country,Pop_2099=PopTotal,pc_2099=pc,Rank_2099=rank)
  
  ranks <- rank1950 %>% 
    inner_join(rank2015) %>% 
    inner_join(rank2099) %>% 
    DT::datatable(container = pop,rownames = FALSE)
  
  } else {
    rank1950<- avPop %>% 
      filter(Location %in% countries$Country&Time==1950) %>% 
      rename(Country=Location) %>% 
      group_by(Time) %>% 
      arrange(desc(PopDensity)) %>% 
      mutate(rank=row_number(),Den_1950=round(PopDensity,0)) %>% 
      ungroup() %>% 
      select(Country,Den_1950,Rank_1950=rank)
    
    
    rank2015<- avPop %>% 
      filter(Location %in% countries$Country&Time==2015) %>% 
      rename(Country=Location) %>% 
      group_by(Time) %>% 
      arrange(desc(PopDensity)) %>% 
      mutate(rank=row_number(),Den_2015=round(PopDensity,0)) %>% 
      ungroup() %>% 
      select(Country,Den_2015,Rank_2015=rank)
    
    rank2099<- avPop %>% 
      filter(Location %in% countries$Country&Time==2099) %>% 
      rename(Country=Location) %>% 
      group_by(Time) %>% 
      arrange(desc(PopDensity)) %>% 
      mutate(rank=row_number(),Den_2099=round(PopDensity,0)) %>% 
      ungroup() %>% 
      select(Country,Den_2099,Rank_2099=rank)
    
    
    ranks <- rank1950 %>% 
      inner_join(rank2015) %>% 
      inner_join(rank2099) %>% 
      DT::datatable(container = density,rownames = FALSE)
    
  }
  
  
  
})