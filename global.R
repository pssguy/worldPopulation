library(shiny)
library(shinydashboard)
library(ggvis)
library(dplyr)
library(readr)
library(streamgraph)
library(rgdal)
library(leaflet)

# standard map data for world
mapData <- readOGR(dsn=".",
                   layer = "ne_50m_admin_0_countries", 
                   encoding = "UTF-8",verbose=FALSE)


countries <-read_csv("countries.csv")
avPop <- read_csv("PopEstimates.csv")
## puts reuslt in millions
avPop$PopTotal <- round(avPop$PopTotal/1000,2)
## add an id 
#avPop <- cbind(avPop, id = seq_len(nrow(avPop)))



continents <- c("Africa","Northern America","Europe","Oceania","Latin America and the Caribbean","Asia" )