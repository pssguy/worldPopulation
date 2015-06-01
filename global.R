library(shiny)
library(ggvis)
library(dplyr)
library(readr)
library(streamgraph)


countries <-read_csv("countries.csv")
avPop <- read_csv("PopEstimates.csv")
## puts reuslt in millions
avPop$PopTotal <- round(avPop$PopTotal/1000,2)
## add an id 
#avPop <- cbind(avPop, id = seq_len(nrow(avPop)))



continents <- c("Africa","Northern America","Europe","Oceania","Latin America and the Caribbean","Asia" )