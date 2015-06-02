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
      menuItem("Maps", tabName = "maps"),
      menuItem("Charts", tabName = "charts"),
      menuItem("Tables", tabName = "tables"),
      menuItem("Countries", tabName = "countries")
    )
    
  ),
  dashboardBody(
    tabItems(
      tabItem("maps"),
              
      tabItem("charts",
             
              box(
                width = 8, status = "info", solidHeader = TRUE,
                title = "Continents",
                ggvisOutput("continents")
                
              )
              
      ),
      tabItem("tables"),
      tabItem("countries")
              
    )
  )
)
