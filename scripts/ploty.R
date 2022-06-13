library(shiny)
library(plotly)
library(ggplot2)

ui <- fluidPage(
  fluidRow(
    column(width = 3, offset = 9, 
           selectInput("y", "y", colnames(mtcars)),style="z-index:1002;")
  ),
  fluidRow(plotlyOutput("plot"))
)

server <- function(input, output, session) {
  output$plot <- renderPlotly({
    g <- ggplot(mtcars, aes_string("disp", input$y)) +
      geom_point()
    g <- ggplotly(g) %>%
      config(displayModeBar = TRUE)
    g
  })
}

shinyApp(ui, server) 

is.numeric(mtcars$mpg)


library(shiny)
library(ggplot2)

shinyApp(
  ui = fluidPage(
    varSelectInput("variable", "Variable:", Filter(is.numeric, iris),
                   selected = NULL),
    
    plotOutput("data")
  ),
  server = function(input, output) {
    output$data <- renderPlot({
      ggplot(iris, aes(.data[[input$variable]])) + geom_histogram()
    })
  }
)

library(shiny)
library(ggplot2)

shinyApp(
  ui = fluidPage(
    varSelectInput("variable", "Variable:", Filter(is.numeric, iris),
                   selected = NULL),
    
    plotOutput("data")
  ),
  server = function(input, output) {
    output$data <- renderPlot({
      ggplot(iris, aes(.data[[input$variable]])) + geom_histogram()
    })
  }
)