
ui <- fluidPage(sidebarLayout(
  sidebarPanel(navlistPanel(
    widths = c(12, 12), "SidebarMenu",
    tabPanel(selectizeInput('case', 'Pick a case', selected="A", choices = c("A", "B"), multiple = FALSE)),
    tabPanel(numericInput('num', 'Number', min = 1, max = 10, value = 1, step = 1))
  )),
  mainPanel(navbarPage(title = NULL,
                       
                       tabPanel(h4("Perspective 1"),
                                tabsetPanel(
                                  tabPanel("Subtab 1.1",
                                           plotOutput("plot11")),
                                  tabPanel("Subtab 1.2")
                                )),
                       tabPanel(h4("Perspective 2"),
                                tabsetPanel(
                                  tabPanel("Subtab 2.1"),
                                  tabPanel("Subtab 2.2")
                                )))
            
  )
))

server <- function(input, output) {
  output$plot11 <- renderPlot({
    hist(rnorm(cases[[input$case]][input$num]))
  })
}

shinyApp(ui, server)
