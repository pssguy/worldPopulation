
## year of max pop
names(countries)[1]  <- "Country"
names(avPop)
temp <- avPop %>% 
  filter(Location %in% countries$Country) %>% 
  arrange(desc(PopTotal)) %>% 
  rename(Country=Location) %>% 
  group_by(Country) %>% 
  slice(1) %>% 
  select(Country,Time,PopTotal) %>% 
  ungroup() %>% 
  arrange(Time,Country) %>% #232
  filter(PopTotal>=0.1) %>%  # knock out smallest 30 countries at least 100,000 sometime
  left_join(countries)
#names(countries)




temp <- cbind(temp, id = seq_len(nrow(temp)))

tt <- function(x) {
  if(is.null(x)) return(NULL)
  row <- temp[temp$id == x$id,c("Country","Time","PopTotal") ]
  paste0( format(row), collapse = "<br />")
}

temp %>% 
  ggvis(~Time,~log(100*PopTotal),key := ~id) %>% 
  layer_points(fill =~ Continent) %>% 
  add_tooltip(tt, "click") %>%
  add_axis("x",title="",format="####") %>% 
  add_axis("y",title="log Country Population") %>% 
  bind_shiny("maxYear")

