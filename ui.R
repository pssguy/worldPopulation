

dashboardPage(
  dashboardHeader(title = "World Population",
                  dropdownMenu(type = "messages", badgeStatus = "success",
                               messageItem("Support Team",
                                           "This is the content of a message.",
                                           time = "5 mins"
                               ),
                               messageItem("Support Team",
                                           "This is the content of another message.",
                                           time = "2 hours"
                               ),
                               messageItem("New User",
                                           "Can I get some help?",
                                           time = "Today"
                               )
                  )
                  ),
  dashboardSidebar(
    
    
    sidebarMenu(
      menuItem("Summary", tabName = "summary"),
      menuItem("Maps", tabName = "maps"),
      menuItem("Charts", tabName = "charts"),
      menuItem("Tables", tabName = "tables"),
      menuItem("Countries", tabName = "countries"),
      menuItem("", icon = icon("twitter-square"),
               href = "https://twitter.com/pssGuy"),
      menuItem("", icon = icon("envelope"),
               href = "mailto:agcur@rogers.com")
      
    )
  ),
  dashboardBody(
    tabItems(
      tabItem("summary",
              fluidRow(
                box(
                  width = 8, status = "info", solidHeader = TRUE,
                  title = "Intro",
                  includeMarkdown("about.md")
                  
                ),
              infoBoxOutput("worldPop")
              ),
              fluidRow(
                box(
                  width = 7, status = "info", solidHeader = TRUE,
#                   title = "Population density 2015.  Click on country for details    ",
#                   
#                   leafletOutput("densityMap2015")
                    title ="The population peaks this century for most bur not some of biggest countries Click points for details
of Country, year and population in millions",
                    ggvisOutput("maxYear")
                  
                  
                ),
                box(
                  width = 5, status = "info", solidHeader = TRUE,
                  title = "Africa will more than quadruple its share in 150 years ",
                  
                  streamgraphOutput("sg_front")
                  
                )
              )
              
      ),
      tabItem("maps",
             
             box(
                 width = 6, status = "info", solidHeader = TRUE,
                 title = "Population density.   Select Year   Click on country for details    Pan/Zoom as desired",
                 sliderInput("year","",min=1950,max=2099,value=2015,sep = ""),
                   textOutput("mapData"),
                  leafletOutput("densityMap")
                 
             ),
             box(
               width = 6, status = "info", solidHeader = TRUE,
               title = "Population by Year", 
               ggvisOutput("countryMapChart")
               
             )
             ),
              
      tabItem("charts",
             
              box(collapsible = TRUE,
                width = 10, status = "info", solidHeader = TRUE,
                title = "Continents",
                ggvisOutput("continents")
                
              ),
              box(collapsible = TRUE,
                width = 10, status = "info", solidHeader = TRUE,
                title = "Sub Continents",
                ggvisOutput("subGroups")
                
              ),
              box(collapsible = TRUE,
                width = 10, status = "info", solidHeader = TRUE,
                title = "Countries",
                ggvisOutput("countries")
                
              )
              
      ),
      tabItem("tables",
              box(
                width = 2, status = "info", solidHeader = TRUE,
                helpText(p("Here is sortable, searchable table of Populations by country"),
                           p("View data as either population in millions ore as a density
                             of people per square kilometre")),
                radioButtons("pop","",c("Population","Density"))
                
              ),
              box(
                  width = 10, status = "info", solidHeader = TRUE,
                  title = "Population Summary by country",
                  DT::dataTableOutput("table")
                  
              )
              ),
      tabItem("countries",
              fluidRow(
              box(
                width = 2,
                title = "Select Country", status = "warning", solidHeader = TRUE,
                selectInput("country","",countryChoice,selected="India")
              ),
              
              
              infoBoxOutput("countryPop"),
              infoBoxOutput("countryPopRank",width = 3),
              infoBoxOutput("countryPopDen", width = 3)
              ),
              box(
                width = 4, status = "info", solidHeader = TRUE,
                title = "Population by Year", #height = 300,
                ggvisOutput("countryChart")
                
              )
             
              )
              
    ) # tabItems
  ) # body
) # page
