library(shiny)
library(ggvis)
library(dplyr)
library(readr)
library(streamgraph)


countries <-read_csv("countries.csv")
avPop <- read_csv("PopEstimates.csv")


continents <- c("Africa","Northern America","Europe","Oceania","Latin America and the Caribbean","Asia" )