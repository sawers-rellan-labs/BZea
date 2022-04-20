#Packages required
# packages <- (c( "shiny","gapminder", "ggforce", "gh", "globals", "openintro", "profvis", "RSQLite", "shiny", "shinycssloaders", "shinyFeedback", "shinythemes", "testthat", "thematic", "tidyverse", "vroom", "waiter", "xml2", "zeallot","shinydashboard","shinydashboardPlus","shinyalert","shinyjs"))

# Install packages not yet installed
#installed_packages <- packages %in% rownames(installed.packages())
#if (any(installed_packages == FALSE)) {
#  install.packages(packages[!installed_packages])
#}

#Loading packages
# invisible(lapply(packages, library, character.only = TRUE))

#Loading Data Table
# sb <- vroom::vroom("Data/data.csv")
# zm <- vroom::vroom("Data/data2.csv")


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
      sliderInput("range.phophorus",
                  "Phosphorus content:",
                  value = c(0,100),
                  min = 0,
                  max = 100,
      ),
      sliderInput("n.a",
                  "Altitude:",
                  value = c(0,5000),
                  min = 0,
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

server <- function(input,output){
  
  # Reactive expression to generate the requested distribution ----
  # This is called whenever the inputs change. The output functions
  # defined below then use the value computed from this expression
  d <- reactive({
    dist <- switch(input$dist,
                   p.plot = dist$Phosphorus,
                   a.plot = dist$Altitude)
    
    dist(input$n)
  })
  
  # Generate a table view of the data ----
  df <- eventReactive(input$dist, {
    if(input$dist == "zm"){
      data_internal <- zm
    } else {
      data_internal <- sb
    }
  })
  
  output$table <- renderTable({
    df()
  })
  
  # Generate a plot of the data ----
  # Also uses the inputs to build the plot label. Note that the
  # dependencies on the inputs and the data reactive expression are
  # both tracked, and all expressions are called in the sequence
  # implied by the dependency graph.
  output$p.plot <- renderPlot({
    dist <- input$dist
    p.plot = dist$Phosphorus
    
    hist(d(),
         main = paste("r", dist, "(", n, ")", sep = ""),
         col = "#75AADB", border = "white")
  })
  
}

shinyApp(ui,server)
