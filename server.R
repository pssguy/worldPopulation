
shinyServer(function(input, output,session) {
  
  source("code/charts.R", local=TRUE)
  source("code/maps.R", local=TRUE)

 output$table <- DT::renderDataTable({
   
   years <- c(1950,2015,2099)
   names(countries)[1]  <- "Country"
 avPop %>% 
   filter(Location %in% countries$Country&Time %in% years) %>% 
   rename(Country=Location) %>% 
   group_by(Time) %>% 
   arrange(desc(PopTotal)) %>% 
   mutate(rank=row_number())
 
 names(avPop)
 
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
 
 
#  rank2050<- avPop %>% 
#    filter(Location %in% countries$Country&Time==2050) %>% 
#    rename(Country=Location) %>% 
#    group_by(Time) %>% 
#    arrange(desc(PopTotal)) %>% 
#    mutate(rank=row_number(),pc=round(100*PopTotal/sum(PopTotal),2)) %>% 
#    ungroup() %>% 
#    select(Country,Pop_2050=PopTotal,pc_2050=pc,Rank_2050=rank)
 
 rank2099<- avPop %>% 
   filter(Location %in% countries$Country&Time==2099) %>% 
   rename(Country=Location) %>% 
   group_by(Time) %>% 
   arrange(desc(PopTotal)) %>% 
   mutate(rank=row_number(),pc=round(100*PopTotal/sum(PopTotal),2)) %>% 
   ungroup() %>% 
   select(Country,Pop_2099=PopTotal,pc_2099=pc,Rank_2099=rank)
 
 ## leave out 2050
 
 glimpse(rank1950)
 
 ranks <- rank1950 %>% 
   inner_join(rank2015) %>% 
   inner_join(rank2099) %>% 
   DT::datatable(container = sketch,rownames = FALSE)
 
})

})

