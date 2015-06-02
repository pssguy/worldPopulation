# 
# shinyUI(fluidPage(
# 
#   # Application title
#   titlePanel("World Population"),
# 
#   # Sidebar with a slider input for number of bins
# #   sidebarLayout(
# #     sidebarPanel(
# #       sliderInput("bins",
# #                   "Number of bins:",
# #                   min = 1,
# #                   max = 50,
# #                   value = 30)
# #     ),
# 
#     # Show a plot of the generated distribution
#     mainPanel(
#       textOutput("check"),
#       ggvisOutput("continents"),
#       textOutput(h3("check")),
#       ggvisOutput("subGroups"),
#       ggvisOutput("countries")
# 
#   )
# ))
# 


dashboardPage(
  dashboardHeader(title = "World Population"),
  dashboardSidebar(
    includeMarkdown("about.md"),
    
    sidebarMenu(
      menuItem("Summary", tabName = "summary"),
      menuItem("Maps", tabName = "maps"),
      menuItem("Charts", tabName = "charts"),
      menuItem("Tables", tabName = "tables"),
      menuItem("Countries", tabName = "countries")
    )
    
  ),
  dashboardBody(
    tabItems(
      tabItem("summary",
              
              infoBoxOutput("worldPop")
      ),
      tabItem("maps",
             
             box(
                 width = 10, status = "info", solidHeader = TRUE,
                 title = "Population density.   Select Year   Click on country for details    Pan/Zoom as desired",
                 sliderInput("year","",min=1950,max=2099,value=2015,sep = ""),
                  leafletOutput("densityMap")
                 
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
                  width = 10, status = "info", solidHeader = TRUE,
                  title = "Population Summary by country",
                  DT::dataTableOutput("table")
                  
              )
              ),
      tabItem("countries")
              
    )
  )
)
