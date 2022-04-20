library(shiny)

sb <- vroom::vroom("Data/data.csv")
zm <- vroom::vroom("Data/data2.csv")

# Define UI for random distribution app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Alvarez Lines"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Select the random distribution type ----
      radioButtons("dist", "Crop type:",
                   c("Maize" = "zm",
                     "Sorghum" = "sb")),
      
      # br() element to introduce extra vertical spacing ----
      br(),
      
      # Input: Slider for the Phosphorus and Altitude ----
      sliderInput("n",
                  "Phosphorus content:",
                  value = c(40,60),
                  min = 1,
                  max = 100,
                  ),
      sliderInput("n.a",
                "Altitude:",
                value = c(2000,3000),
                min = 1,
                max = 5000,
                )
    
  ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Tabset w/ plot, summary, and table ----
      tabsetPanel(type = "tabs",
                  tabPanel("Table", tableOutput("table")),
                  tabPanel("Phosphorus Plot", plotOutput("p.plot")),
                  tabPanel("Altitude Plot", plotOutput("a.plot")),
                  tabPanel("PCA", tableOutput("PCA")),
                  tabPanel("Summary", verbatimTextOutput("summary"))
      )
      
    )
  )
)


#Define server logic for random distribution app ----
  server <- function(input, output){
    
    # Reactive expression to generate the requested distribution ----
    # This is called whenever the inputs change. The output functions
    # defined below then use the value computed from this expression
    d <- reactive({
      dist <- switch(input$dist,
                     norm = rnorm,
                     unif = runif,
                     lnorm = rlnorm,
                     exp = rexp,
                     rnorm)

      dist(input$n)
    })
    
    # data_active <- reactive({
    #   # if user switches to internal data, switch in-app data
    #   observeEvent(input$sample_or_real_button){
    #     if(input$sample_or_real == "zm"){
    #       data <- zm
    #     } else {
    #       data <- sb
    #     }
    #   }) 
    
    
    
    # Generate a plot of the data ----
    # Also uses the inputs to build the plot label. Note that the
    # dependencies on the inputs and the data reactive expression are
    # both tracked, and all expressions are called in the sequence
    # implied by the dependency graph.
    output$plot <- renderPlot({
      dist <- input$dist
      n <- input$n
      
      hist(d(),
           main = paste("r", dist, "(", n, ")", sep = ""),
           col = "#75AADB", border = "white")
    })
    
    # Generate a summary of the data ----
    output$summary <- renderPrint({
      summary(d())
    })
    
    # Generate an HTML table view of the data ----
    df <- eventReactive(input$dist, {
        data_internal <- zm
      } else {
        data_internal <- sb
      }
    )
    # output$table <- renderTable({
    #   df()
    # })
    output$table <- DT::renderTable({
      DT::datatable(data = df(), options = list(pageLength = 25),
                    rownames = FALSE, class = 'display', escape = FALSE)
    })
    # output$mtable <- DT::renderDataTable({
    #   DT::datatable(data = fully_filtered(), options = list(pageLength = 10),
    #                 rownames = FALSE, class = 'display', escape = FALSE)
  }


shinyApp(ui,server)
