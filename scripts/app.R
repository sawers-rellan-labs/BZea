#BOOK : Mastering Shiny- Hadley Wickham
#Answers: https://mastering-shiny-solutions.org/your-first-shiny-app.html

###CHAPTER 1

#Packages required
packages <- (c( "shiny","gapminder", "ggforce", "gh", "globals", "openintro", "profvis", "RSQLite", "shiny", "shinycssloaders", "shinyFeedback", "shinythemes", "testthat", "thematic", "tidyverse", "vroom", "waiter", "xml2", "zeallot"))

# Install packages not yet installed
#installed_packages <- packages %in% rownames(installed.packages())
#if (any(installed_packages == FALSE)) {
#  install.packages(packages[!installed_packages])
#}

#Loading packages
invisible(lapply(packages, library, character.only = TRUE))


#Creating an app directory and file
#Simple example
# library(shiny)
# ui <- fluidPage(
#   "Hello world!"
# )
# server <- function(input, output, session){
# }
# shinyApp(ui, server)


#Creating an app directory and file
# library(shiny)
# ui <- fluidPage(
#   selectInput("dataset", label = "Dataset", choices = ls("package:datasets")),
#   verbatimTextOutput("summary"),
#   tableOutput("table")
# )
# #fluidPage() <-  layout function. Basic visual strucyutre of page
# #selectInput() <-  input control. Let user interact with app by providing a value.
#                   #select box with the label "Dataset" and choose one of built-in dataset
# #verbatimTextoutput and tableOutput <-  output controls where to put rendered output
#                     #verbatrimTextOutput displays code and tableOutput displays tables
# server <- function(input, output, session){
# }
# shinyApp(ui, server)


#Adding behavior
# library(shiny)
# ui <- fluidPage(
#   selectInput("dataset", label = "Dataset", choices = ls("package:datasets")),
#   verbatimTextOutput("summary"),
#   tableOutput("table")
# )
# 
# server <- function(input, output, session){
#   output$summary <- renderPrint({
#     dataset <- get(input$dataset, "package:datasets")
#     summary(dataset)
#   })
#   output$table <- renderTable({
#     dataset <- get(input$dataset, "package:datasets")
#     dataset
#   })
# }
# 
# #output$ID <- providing the recipe for the Shiny output with that ID
#             #Right hand side of the assignment uses a render function to wrap some code you provide
#             #each render{Type} function procdes different output (texts, tables and plots)
#             # and is paired with {type}Output function
#             #E.g. renderPrint() is paired with verbatimTextOutput() to display summary with fixed-width (verbatim) text,
#             # and renderTable() is paired with tableOutput() to show the input data
# 
# 
# shinyApp(ui, server)


#Reducing Duplication with Reactive Expressions
#Reactive expressions
#A reactive expression only runs the first time it is called, 
#and then it caches its result until it needs to be updated

# library(shiny)
# ui <- fluidPage(
#   selectInput("dataset", label = "Dataset", choices = ls("package:datasets")),
#   verbatimTextOutput("summary"),
#   tableOutput("table")
# )
# 
# server <- function(input, output, session){
#   #create a reactive expression
#   dataset <- reactive({
#     get(input$dataset, "package:datasets")
#   })
#   output$summary <- renderPrint({
#     #Use a reactive expression by calling it like a function
#     summary(dataset())
#   })
#   output$table <- renderTable({
#     dataset()
#   })
# }
# shinyApp(ui, server)



#CHAPTER 2
##Free Text
# ui <- fluidPage(
#   textInput("name","Name?"),
#   passwordInput("password","Password?"),
#   textAreaInput("story","Hobbies?", rows = 4)
# )
# 
# shinyApp(ui, server)


## Numeric Inputs
# ui <- fluidPage(
#   numericInput("num", "Number 1", value = 0, min = 0, max = 100),
#   sliderInput("num2", "Numer 2", value = 50, min = 0, max = 100),
#   sliderInput("rng", "Range", value = c(10,20), min = 0, max = 100)
# )
# shinyApp(ui, server)


## Dates
# ui <- fluidPage(
#   dateInput("dob","DOB?"),
#   dateRangeInput("holiday", "Next vacay date?")
# )
# shinyApp(ui,server)


## Limited choice
# animals <- c("dog", "cat", "horse", "giraffe")
# ui <- fluidPage(
#   selectInput("state", "Fav state?", state.name),
#   radioButtons("animals", "Fav animal?", animals)
# )
# shinyApp(ui,server)

### Choice options
# ui <- fluidPage(
#   radioButtons("rb", "Choose",
#                choiceNames = list(
#                  icon("angry"),
#                  icon("smile"),
#                  icon("sad-tear")
#                ),
#                choiceValues = list("angry", "happy", "sad")
#               )
# )
# shinyApp(ui,server)


### Drop down
# ui <- fluidPage(
#   selectInput(
#     "state", "Fav state", state.name,
#     multiple = TRUE
#   )
# )
# shinyApp(ui,server)


### Check box
# ui <- fluidPage(
#   checkboxGroupInput("animal", "Animals?", animals)
# )
# shinyApp(ui,server)

#### Single check box
# ui <- fluidPage(
#   checkboxInput("cleanup", "Clean?", value = TRUE),
#   checkboxInput("shutdown", "Shutdown?")
# )
# shinyApp(ui,server)


## File Uploads
ui <- fluidPage(
  fileInput("upload", NULL)
)
shinyApp(ui, server)