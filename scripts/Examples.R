# #Ask your Age and Name and Greet 
# ui <- fluidPage(
#   numericInput("age","How old are you", value = NA),
#   textInput("name", "Name?"),
#   textOutput("greeting"),
#   
# )
# server <- function(input, output, session){
#   tableOutput("mortgage")
#   output$greeting <- renderText({
#     paste0("Hello ", input$name)
#   })
# }
# 
# shinyApp(ui, server)


##q Slider input for product
# ui <- fluidPage(
#   sliderInput("x", label = "If x is", min = 1, max = 50, value = 1),
#   "then x times 5 is",
#   textOutput("product")
# )
# 
# server <- function(input, output, session){
#   output$product <- renderText({
#     input$x * 5
#   })
# }
# shinyApp(ui, server)



#q Extend the app from the previous exercise to allow the user to set the value of the multiplier, y, 
#so that the app yields the value of x * y. 

#ui <- fluidPage(
#   sliderInput("x", label = "If x is", min = 1, max = 50, value = 1),
#   sliderInput("y", label = "and y is", min = 1, max = 50, value = 1),
#   "then x times 5 is",
#   textOutput("product")
# )
# 
# server <- function(input, output, session){
#   output$product <- renderText({
#     input$x * input$y
#   })
# }
# shinyApp(ui, server)



#Q4
# Remove duplication
# ui <- fluidPage( 
#   sliderInput("x", "If x is", min = 1, max = 50, value = 30), 
#   sliderInput("y", "and y is", min = 1, max = 50, value = 5), 
#   "then, (x * y) is", textOutput("product"), 
#   "and, (x * y) + 5 is", textOutput("product_plus5"), 
#   "and (x * y) + 10 is", textOutput("product_plus10")
#   )
# 
# server <- function(input, output, session) { 
#   output$product <- renderText({ 
#     product <- input$x * input$y 
#     product }) 
#   output$product_plus5 <- renderText({ 
#     product <- input$x * input$y 
#     product + 5 
#     }) 
#   output$product_plus10 <- renderText({ 
#     product <- input$x * input$y 
#     product + 10 
#     })
#   }
# shinyApp(ui, server)

#Answer

# ui <- fluidPage(
#   sliderInput("x", "If x is", min = 1, max = 50, value = 30),
#   sliderInput("y", "and y is", min = 1, max = 50, value = 5),
#   "then, (x * y) is", textOutput("product"),
#   "and, (x * y) + 5 is", textOutput("product_plus5"),
#   "and (x * y) + 10 is", textOutput("product_plus10")
# )
# 
# server <- function(input, output, session) {
#   
#   product <- reactive(input$x * input$y)
#   
#   output$product <- renderText( product() )
#   output$product_plus5 <- renderText( product() + 5 )
#   output$product_plus10 <- renderText( product() + 10 )
# }
# shinyApp(ui, server)



#Q5
#Uses ggplot dataset. Fix it

# datasets <- data(package = "ggplot2")$results[c(2, 4, 10), "Item"]
# 
# ui <- fluidPage(
#   selectInput("dataset", "Dataset", choices = datasets),
#   verbatimTextOutput("summary"),
#   # 1. Change tableOutput to plotOutput.
#   plotOutput("plot")
# )
# 
# server <- function(input, output, session) {
#   dataset <- reactive({
#     get(input$dataset, "package:ggplot2")
#   })
#   # 2. Change summry to summary.
#   output$summary <- renderPrint({
#     summary(dataset())
#   })
#   output$plot <- renderPlot({
#     # 3. Change dataset to dataset().
#     plot(dataset())
#   })
# }
# 
# shinyApp(ui, server)



#Chapter 2

##q1
#Text box space name
#textInput("text", "", placeholder = "Your name")


##q2
#Date slider
# sliderInput(
#   "dates",
#   "When should we deliver?",
#   min = as.Date("2019-08-09"),
#   max = as.Date("2019-08-16"),
#   value = as.Date("2019-08-10")
# )


##q3
# ui <- fluidPage(
#   selectInput(
#     "breed",
#     "Select breed",
#     choices = 
#       list(`dogs` = list('German Shepherd', 'Bulldog', 'Labrador'),
#            `cats` = list('Persian', 'Benga', "Siamese")),
#   )
# )
# shinyApp(ui,server)


##q4
#Slider with range
# ui <- fluidPage(
#   sliderInput("number", "A number?",
#               min = 0, max = 100, value = 0,
#               step = 5, animate = TRUE) #animate = increase the slider by 5 periodically
# )
# shinyApp(ui,server)


##q5.1
#Re-create the Shiny app from the plots section, this time setting height to 300px and width to 700px.
# library(shiny)
# 
# ui <- fluidPage(
#   plotOutput("plot", width = "700px", height = "300px")
# )
# 
# server <- function(input, output, session) {
#   output$plot <- renderPlot(plot(1:5), res = 96)
# }
# 
# shinyApp(ui, server)


## q5.2
#library(shiny)

#TABLE WITH SEARCH
# ui <- fluidPage(
#   dataTableOutput("table")
# )
# server <- function(input, output, session) {
#   output$table <- renderDataTable(mtcars, options = list(pageLength = 5))
# }


#TABLE WITHOUT SEARCH
# ui <- fluidPage( 
#   dataTableOutput("table")
# )
# 
# server <- function(input, output, session) {
#   output$table <- renderDataTable(
#     mtcars, options = list(ordering = FALSE, searching = FALSE))
# }

#shinyApp(ui, server)



## q 6.1
#Create an app that contains two plots, each of which takes up half the app 
# 
# library(shiny)
# 
# ui <- fluidPage(
#   fluidRow(
#     column(width = 4, plotOutput("plot1")),
#     column(width = 4, plotOutput("plot2"))
#   )
# )
# server <- function(input, output, session) {
#   output$plot1 <- renderPlot(plot(1:5))
#   output$plot2 <- renderPlot(plot(1:5))
# }
# 
# shinyApp(ui, server)


## q 6.2
