shinyUI(fluidPage(
  titlePanel("Population, Income, and Area by U.S. State"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Graphically compare Population, Income, and Area for U.S. states.
                     Source (via state.x77 dataset):  
                    U.S. Department of Commerce, Bureau of the Census (1977) Statistical Abstract of the United States.
                    U.S. Department of Commerce, Bureau of the Census (1977) County and City Data Book."),
      
      # selectInput widget for getting user input
      selectInput("var", 
                  label="Choose a category to display",
                  choices=c("Population",
                            "Income",
                            "Area"
                            ),
                  selected="Population")
    ),
    
    mainPanel(plotOutput("map"))
  )
))