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
# ui <- fluidPage(
#   fileInput("upload", NULL)
# )
# shinyApp(ui, server)


## Action Buttons
# ui <- fluidPage(
#   actionButton("click", "Click Me!"),
#   actionButton("drink", "Drink me!", icon = icon("cocktail"))
# )
# shinyApp(ui,server)


### Customize appearance
# ui <- fluidPage(
#   fluidRow(actionButton("Click", "Click", class = "btn-danger"), #red button
#            actionButton("drink", "Drink", class = "btn-lg btn-success") #bigger green button
#     ),
#   fluidRow(
#     actionButton("eat","EAT", class = "btn-block") #big button
#   )
# )
# shinyApp(ui,server)


# #Outputs
# ## Text
# ### Output regular text with textOutput() and fixed width text (e.g., console output) with verbatimTextOutput()
# ui <- fluidPage(
#   textOutput("text"),
#   verbatimTextOutput("code")
# )
# server <- function(input, output, session){
#   output$text <- renderText({
#     "Hello Friend!!"
#   })
#   output$code <- renderPrint({
#     summary(1:10)
#   })
# }
# shinyApp(ui, server)

#renderText() This combines the result into a single string and is usually paired with textOutput() . 
#renderPrint() This prints the result, as if you were in an R console, and is usually paired with verbatimTextOutput()

#Difference between textOutput() and verbatimTextOutput
# ui <- fluidPage(
#   textOutput("text"),
#   verbatimTextOutput("print")
# )
# server <- function(input, output, session){
#   output$text <- renderText("hello")
#   output$print <- renderPrint("hello")
# }
# shinyApp(ui,server)


##Tables
#tableOutput() and renderTable() These render a static table of data, showing all the data at once. 
#dataTableOutput() and renderDataTable() These render a dynamic table, showing a fixed number of rows along with controls to change which rows are visible.

# ui <- fluidPage(
#   tableOutput("static"),
#   dataTableOutput("dynamic")
# )
# server <- function(input, output, session){
#   output$static <- renderTable(head(mtcars))
#   output$dynamic <- renderDataTable(mtcars, options = list(pageLength = 5))
# }
# shinyApp(ui,server)

#If you want greater control over the output of dataTableOutput() , I highly recommend the reactable package by Greg Lin


##Plots
# ui <- fluidPage(
#   plotOutput("plot", width = "400px")
# )
# server <- function(input, output, session) {
#   output$plot <- renderPlot(plot(1:5), res = 96)
# }
# shinyApp(ui, server)



##Reactive programming

###Both input and output
# ui <- fluidPage(
#   textInput("name", "Name?"),
#   textOutput("greeting")
# )
# server <- function(input, output, session) {
#   output$greeting <- renderText({
#     paste0("Hello ", input$name, "!")
#   })
# }
# shinyApp(ui,server)

#Comparing two Data
# library(ggplot2)
# freqpoly <- function(x1, x2, binwidth = 0.1, xlim = c(-3, 3)){
#   df <- data.frame(
#     x = c(x1, x2),
#     g = c(rep("x1", length(x1)), rep("x2", length(x2)))
#   )
#   ggplot(df, aes(x, colour =g)) +
#     geom_freqpoly(binwidth = binwidth, size = 1) +
#     coord_cartesian(xlim = xlim)
# }
# 
# t_test <- function(x1,x2){
#   test <- t.test(x1,x2)
#   #use sprintf() to format t.test() results compactly
#   sprintf(
#     "p value: %0.3f\n[%0.2f, %0.2f]",
#     test$p.value, test$conf.int[1], test$conf.int[2]
#   )
# }
# #Stimulated data, use function to compare two variables
# x1 <- rnorm(100, mean = 0, sd = 0.5)
# x2 <- rnorm(200, mean = 0.15, sd = 0.9)
# 
# freqpoly(x1,x2)
# cat(t_test(x1, x2))
# 
# ui <- fluidPage(
#   fluidRow(
#     column(4,
#            "Distribution 1",
#            numericInput("n1", label = "n", value = 1000, min = 1),
#            numericInput("mean1", label = "μ", value =0, step = 0.1),
#            numericInput("sd1", label = "σ", value = 0.5, min = 0.1, step = 0.1)
#     ),
#     column(4,
#            "Distribution 2",
#            numericInput("n2", label = "n", value = 1000, min = 1),
#            numericInput("mean2", label = "μ", value = 0, step = 0.1),
#            numericInput("sd2", label = "σ", value = 0.5, min = 0.1, step = 0.1)
#            ),
#     column (4, 
#             "Frequency polygon" , 
#             numericInput ("binwidth" , label = "Bin width" , value = 0.1, step = 0.1), 
#             sliderInput ("range" , label = "range" , value = c(-3, 3), min = -5, max = 5)
#     )        
#   ),
#   fluidRow(
#     column(9, plotOutput("hist")),
#     column(3, verbatimTextOutput("ttest"))
#   )
# )
# 
# server <- function(input, output, session){
#   output$hist <- renderPlot({
#     x1 <- rnorm(input$n1, input$mean1, input$sd1)
#     x2 <- rnorm(input$n2, input$mean, input$sd2)
#     
#     freqpoly(x1, x2, binwidth = input$binwidth, xlim = input$range)
#   }, res = 96)
#   output$ttest <- renderText({
#     x1 <- rnorm(input$n1, input$mean1, input$sd1)
#     x2 <- rnorm(input$n2, input$mean2, input$sd2)
#     
#     t_test(x1, x2)
#   })
# }
# 
# shinyApp(ui, server)





#Chapter 4 
## Case Study: ER Injuries

## Getting data
dir.create("neiss")
download <- function(name) {
  url <- "https://github.com/hadley/mastering-shiny/raw/master/neiss/" 
  download.file(paste0(url, name), paste0("neiss/", name), quiet = TRUE)
}
download("injuries.tsv.gz")
download("population.tsv")
download("products.tsv")

###Main dataset
injuries <- vroom::vroom("neiss/injuries.tsv.gz")
injuries

### Data sets to connect
products <- vroom::vroom("neiss/products.tsv")
products

population <- vroom::vroom("neiss/population.tsv")
population


##Explore the data
selected <- injuries %>% filter(prod_code == 649)
nrow(selected)
### Basic summary: location, body part and diagnosis of toilet related injuries
selected %>% count(location, wt = weight, sort = TRUE)
selected %>% count(body_part, wt = weight, sort = TRUE)
selected %>% count(diag, wt = weight, sort = TRUE)
summary <- selected %>%
  count(age, sex, wt = weight)
summary

###GRAPH
summary %>%
  ggplot(aes(age, n, colour = sex)) +
  geom_line() +
  labs(y = "Estimated number of injuries")

### no. of older people fewer than younger so graph may be wrong. So normalize the data per 10,000
summary <- selected %>%
  count(age, sex, wt = weight) %>%
  left_join(population, by = c("age", "sex")) %>%
  mutate(rate = n / population * 1e4)
summary

summary %>%
  ggplot(aes(age, rate, colour = sex)) +
  geom_line(na.rm = TRUE) +
  labs(y = "Injuries per 10k people")

##Making hypothesis: random sample of 10
selected %>%
  sample_n(10) %>%
  pull(narrative)


#Prototype
### 1 row for the input, 1 row for all three tables( 4 columns, 1/3 of the 12- column width), 1 row for plot:
# prod_codes <- setNames(products$prod_code, products$title)
# ui <- fluidPage(
#   fluidRow(
#     column(6,
#            selectInput("code", "Product", choices = prod_codes)
#            )
#   ),
#   fluidRow(
#     column(4, tableOutput("diag")),
#     column(4, tableOutput("body_part")),
#     column(4, tableOutput("location"))
#   ),
#   fluidRow(
#     column(12, plotOutput("age_sex"))
#   )
# )


# server <- function(input, output, session) { 
#   selected <- reactive(injuries %>% filter(prod_code == input$code)) 
#   
#   output$diag <- renderTable( 
#     selected() %>% count(diag, wt = weight, sort = TRUE) 
#   ) 
#   output$body_part <- renderTable( 
#     selected() %>% count(body_part, wt = weight, sort = TRUE) 
#   ) 
#   output$location <- renderTable( 
#     selected() %>% count(location, wt = weight, sort = TRUE) 
#   ) 
#   summary <- reactive({ 
#     selected() %>% 
#       count(age, sex, wt = weight) %>%
#       left_join(population, by = c("age", "sex")) %>%
#       mutate(rate = n / population * 1e4) 
#   }) 
#   
#   output$age_sex <- renderPlot({ 
#     summary() %>%
#       ggplot(aes(age, n, colour = sex)) +
#       geom_line() +
#       labs(y = "Estimated number of injuries") 
#   }, res = 96)
# }


##Improving the APP
### Too much info on tables, just the highlights.
### Truncate the tables using forcats funcction
### Convert the variable to a factor, order by the frequency of the levels, and then lump together all levels after the top five:

injuries %>%
  mutate(diag = fct_lump(fct_infreq(diag), n = 5)) %>%
  group_by(diag) %>%
  summarize(n = as.integer(sum(weight)))

## Automate for every variable: a function
count_top <- function(df, var, n = 5){
  df %>%
    mutate({{ var }} := fct_lump(fct_infreq({{ var }}), n = n)) %>%
    group_by({{ var }}) %>%
    summarize(n = as.integer(sum(weight)))
}

### Use this in the Server function
# output$diag <- renderTable(count_top(selected(), diag), width = "100%")
# output$body_part <- renderTable(count_top(selected(), body_part), width = "100%")
# output$location <- renderTable(count_top(selected(), location), width = "100%")



# server <- function(input, output, session) { 
#   selected <- reactive(injuries %>% filter(prod_code == input$code)) 
#   
#   output$diag <- renderTable(count_top(selected(), diag), width = "100%")
#   output$body_part <- renderTable(count_top(selected(), body_part), width = "100%")
#   output$location <- renderTable(count_top(selected(), location), width = "100%")
#   
#   summary <- reactive({ 
#     selected() %>% 
#       count(age, sex, wt = weight) %>%
#       left_join(population, by = c("age", "sex")) %>%
#       mutate(rate = n / population * 1e4) 
#   }) 
#   
#   output$age_sex <- renderPlot({ 
#     summary() %>%
#       ggplot(aes(age, n, colour = sex)) +
#       geom_line() +
#       labs(y = "Estimated number of injuries") 
#   }, res = 96)
# }
# shinyApp(ui,server)


##Rate VS Count
### give user the choice between visualizing multi plots
### Add a control to the UI
# fluidRow( 
#   column(8,
#          selectInput("code", "Product",
#                      choices = setNames(products$prod_code, products$title),
#                      width = "100%"
#                      ) 
#          ), 
#   column(2, selectInput("y", "Y axis", c("rate", "count"))) 
#   ),





prod_codes <- setNames(products$prod_code, products$title)
ui <- fluidPage (
  fluidRow( 
    column(8,
           selectInput("code", "Product",
                       choices = setNames(products$prod_code, products$title),
                       width = "100%"
           ) 
    ), 
    column(2, selectInput("y", "Y axis", c("rate", "count"))) 
  ),
  fluidRow(
    column(8, 
           selectInput("code", "Product",
                       choices = setNames(products$prod_code, products$title),
                       width = "100%"
           )
    ),
    column(2, selectInput("y", "Y axis", c("rate", "count")))
    ),
  fluidRow(
    column(6,
           selectInput("code", "Product", choices = prod_codes)
    )
  ),
  fluidRow(
    column(4, tableOutput("diag")),
    column(4, tableOutput("body_part")),
    column(4, tableOutput("location"))
  ),
  fluidRow(
    column(12, plotOutput("age_sex"))
  )
)

### Conditioned on that input
# output$age_sex <- renderPlot({
#   if(input$y == "count") {
#     summary() %>%
#       ggplot(aes(age, n, colour = sex)) +
#       geom_line() +
#       labs(y = "Estimated number of injuries")
#   } else {
#     summary() %>%
#       ggplot(aes(age, rate, coulout = sex)) +
#       geom_line(na.rm = TRUE) +
#       labs(y = "Injuries per 10,000 people")
#   }
# }, res = 96)



server <- function(input, output, session) { 
  selected <- reactive(injuries %>% filter(prod_code == input$code)) 
  
  output$diag <- renderTable(count_top(selected(), diag), width = "100%")
  output$body_part <- renderTable(count_top(selected(), body_part), width = "100%")
  output$location <- renderTable(count_top(selected(), location), width = "100%")
  
  summary <- reactive({ 
    selected() %>% 
      count(age, sex, wt = weight) %>%
      left_join(population, by = c("age", "sex")) %>%
      mutate(rate = n / population * 1e4) 
  }) 
  
  output$age_sex <- renderPlot({
    if(input$y == "count") {
      summary() %>%
        ggplot(aes(age, n, colour = sex)) +
        geom_line() +
        labs(y = "Estimated number of injuries")
    } else {
      summary() %>%
        ggplot(aes(age, rate, coulout = sex)) +
        geom_line(na.rm = TRUE) +
        labs(y = "Injuries per 10,000 people")
    }
  }, res = 96)
}
shinyApp(ui,server)