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




