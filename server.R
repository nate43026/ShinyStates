library(shiny)
library(ggplot2)
library(maps)
library(datasets)

states <-data.frame(state = tolower(rownames(state.x77)), state.x77)

shinyServer(function(input, output){
  output$map <- renderPlot({
    data <- switch(input$var,
                   "Population" = states[,c("state", "Population")],
                   "Income" = states[,c("state", "Income")],
                   "Area" = states[,c("state", "Area")]
                   )
    color <- switch(input$var,
                    "Income" = "green",
                    "Population" = "darkblue",
                    "Area" = "darkviolet")
    datamap(data, color)
  })
})


datamap <- function(data, color){
  states_map <-map_data("state")
  cnames <- aggregate(cbind(long, lat) ~ region, data=states_map, FUN=function(x)mean(range(x)))
  cnames <- cnames[-8,]
  state.abb <- subset(state.abb, !state.abb %in% c("AK","HI"))
  names(cnames)[names(cnames)=='region'] <- 'state'
  cnames <- cbind(state.abb, cnames)
  names(cnames)[names(cnames)=='state.abb'] <- 'abb'
  values <- data[,2]
  ggplot(data, aes(map_id = state), environment = environment()) +
    geom_map(aes(fill = values), map = states_map) +
    expand_limits(x = states_map$long, y = states_map$lat) +
    # legend customization to be prettier
    theme(legend.position="bottom",
          axis.ticks=element_blank(),
          axis.title=element_blank(),
          axis.text=element_blank(),
          panel.grid=element_blank(),
          panel.background=element_rect(fill='white')) +
    scale_fill_gradient(low="white", high=color, name='') +
    guides(fill=guide_colorbar(barwidth=10, barheight=.5)) +
    geom_text(data=cnames, aes(long, lat, label=abb), size=3)
}