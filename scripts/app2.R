#Packages required
#packages <- (c( "shiny","gapminder", "ggforce", "gh", "globals", "openintro", "profvis", "RSQLite", "shiny", "shinycssloaders", "shinyFeedback", "shinythemes", "testthat", "thematic", "tidyverse", "vroom", "waiter", "xml2", "zeallot","shinydashboard","shinydashboardPlus","shinyalert","shinyjs","shinyWidgets","datamods", "MASS"))

# Install packages not yet installed
# installed_packages <- packages %in% rownames(installed.packages())
# if (any(installed_packages == FALSE)) {
# install.packages(packages[!installed_packages])
#  }

#Loading packages
#invisible(lapply(packages, library, character.only = TRUE))

#Loading Data Table
#sb <- vroom::vroom("Data/data.csv")
#zm <- vroom::vroom("Data/data2.csv")
#sb <- read.table("Data/data.csv", sep=",")
#zm <- read.table("Data/data2.csv", sep=",")


datetime <- data.frame(
  date = seq(Sys.Date(), by = "day", length.out = 300),
  datetime = seq(Sys.time(), by = "hour", length.out = 300),
  num = sample.int(1e5, 300)
)

one_column_numeric <- data.frame(
  var1 = rnorm(100)
)


# Define UI for random distribution app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Alvarez Lines"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Select the random distribution type ----
      radioButtons(
        inputId = "dist", 
        label = "Crop type:",
        choices = c("Maize" = "zm",
                     "Sorghum" = "sb"),
        inline = TRUE),
      # # br() element to introduce extra vertical spacing ----
      # br(),
      # 
      # # Input: Slider for the Phosphorus and Altitude ----
      # sliderInput("range.phophorus",
      #             "Phosphorus content:",
      #             value = c(0,100),
      #             min = 0,
      #             max = 100,
      # ),
      # sliderInput("n.a",
      #             "Altitude:",
      #             value = c(0,5000),
      #             min = 0,
      #             max = 5000,
      # )
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Tabset w/ plot, summary, and table ----
      tabsetPanel(type = "tabs",
                  tabPanel("Table", tableOutput("table"),
                           fluidRow(
                             column(
                               width = 3,
                               filter_data_ui("filtering", max_height = "500px")
                             ),
                             column(
                               width = 9,
                               progressBar(
                                 id = "pbar", value = 100,
                                 total = 100, display_pct = TRUE
                               ),
                               DT::dataTableOutput(outputId = "table"),
                               tags$b("Filtered data:"),
                               verbatimTextOutput(outputId = "res_str")
                             )
                           )),
                  tabPanel("Phosphorus Plot", plotOutput("p.plot")),
                  tabPanel("Altitude Plot", plotOutput("a.plot")),
                  tabPanel("PCA", tableOutput("PCA")),
                  tabPanel("Summary", verbatimTextOutput("summary"))
      )
      
    )
  )
)

server <- function(input,output){
  data <- reactive({
    get(input$dataset)
  })
  ?filter_data_server()
  res_filter <- filter_data_server(
    id = "filtering",
    data = data,
    name = reactive(input$dataset),
    vars = vars,
    widget_num = "slider",
    widget_date = "slider",
    label_na = "Missing"
  )
  
  observeEvent(res_filter$filtered(), {
    updateProgressBar(
      session = session, id = "pbar",
      value = nrow(res_filter$filtered()), total = nrow(data())
    )
  })
  df <- eventReactive(input$dist, {
    if(input$dist == "zm"){
      data_internal <- zm
    } else {
      data_internal <- sb
    }
  })

  
  output$table <- DT::renderDT({
    res_filter$filtered(df())
  }, options = list(pageLength = 5))
  
  output$code_dplyr <- renderPrint({
    res_filter$code()
  })
  output$code <- renderPrint({
    res_filter$expr()
  })
  
  output$res_str <- renderPrint({
    str(res_filter$filtered())
  })
  
  
  # Reactive expression to generate the requested distribution ----
  # This is called whenever the inputs change. The output functions
  # defined below then use the value computed from this expression
  # d <- reactive({
  #   dist <- switch(input$dist,
  #                  p.plot = dist$Phosphorus,
  #                  a.plot = dist$Altitude)
  #   
  #   dist(input$n)
  # })
  
  # Generate a table view of the data ----
  # df <- eventReactive(input$dist, {
  #   if(input$dist == "zm"){
  #     data_internal <- zm
  #   } else {
  #     data_internal <- sb
  #   }
  # })
  # 
  # output$table <- renderTable({
  #   df()
  # })
  
  # output$table <- renderTable({
  #   df<- df[df$Year >= input$range.phosphoruss[1] & df$Phosphorus <= input$range.phosphorus[2],]
  #   df[,c(Phosphorus,input$dist)]
  # },include.rownames=FALSE)
  
  
  # Generate a plot of the data ----
  # Also uses the inputs to build the plot label. Note that the
  # dependencies on the inputs and the data reactive expression are
  # both tracked, and all expressions are called in the sequence
  # implied by the dependency graph.
  # output$p.plot <- renderPlot({
  #   dist <- input$dist
  #   p.plot = dist$Phosphorus
  #   
  #   hist(d(),
  #        main = paste("r", dist, "(", n, ")", sep = ""),
  #        col = "#75AADB", border = "white")
  # })
  # 
}

shinyApp(ui,server)
