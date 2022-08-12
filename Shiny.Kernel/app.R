# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#


library(shiny)
library(gapminder)
library(ggforce)
library(gh)
library(globals)
library(openintro)
library(profvis)
library(RSQLite)
library(shinycssloaders)
library(shinyFeedback)
library(shinythemes)
library(testthat)
library(thematic)
library(tidyverse)
library(vroom)
library(waiter)
library(xml2)
library(zeallot)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyalert)
library(shinyjs)
library(shinyWidgets)
library(datamods)
library(MASS)
library(ggplot2)
library(dplyr)
library(ggmap)
library(maptools)
library(maps)
library(dashboardthemes)
library(sf)

#Loading Data Table
sb <- vroom::vroom("Data/data.csv")
zm <- vroom::vroom("Data/B73xTEO-LR-Pops-Metadata_all.csv")
zm_lr <- zm[which(zm$Population == "LANDB"), ]
zm_teo <- zm[which(zm$Population == "R2Teo" | zm$Population == "J2Teo" ), ]
sap <- vroom::vroom("Data/SAP.csv")

# Define UI for application that draws a histogram
ui <-  dashboardPage(
  
  dashboardHeader(title =  "BZea"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Data", tabName = "data", icon = icon("database")),
      menuItem("Filter", tabName = "filter", icon = icon("filter")),
      menuItem("Table", tabName = "table", icon = icon("table")),
      menuItem("Chart", tabName = "plots", icon = icon("chart-area")),
      menuItem("Map", tabName = "map", icon = icon("globe")),
      menuItem("About us", tabName = "about_us", icon = icon("user"))
    )
  ),
  
  dashboardBody(
    #shinyDashboardThemes(
    #  theme = "grey_dark"
    #),
    tabItems(
      #First tab-data content
      tabItem(tabName = "data",
              fluidPage(
                radioButtons(
                  inputId = "dataset",
                  label = "Data:",
                  choices = c("B73xTEO Introgression Lines" = "zm"
                              
                              
                  ),
                  inline = FALSE
                ),
              )
      ),
      
      
      # Second tab content
      tabItem(tabName = "filter",
              fluidPage(
                fluidRow(
                  column(
                    width = 5,
                    filter_data_ui("filtering", max_height = "600px")
                  ),
                  column(
                    width = 7,
                    h2("Data available:"),
                    progressBar(
                      id = "pbar", value = 100,
                      total = 100, display_pct = TRUE
                    )),
                  tags$b("Expression:"),
                  verbatimTextOutput(outputId = "code"),
                  tags$b("Filtered data:"),
                  verbatimTextOutput(outputId = "res_str" )
                )
              )
      ),
      
      # Second tab content
      tabItem(tabName = "table",
              DT::dataTableOutput(outputId = "table")
      ),
      
      # Third tab content
      tabItem(tabName = "plots",
              # fluidPage(
              #   varSelectInput("variable","Variable:", Filter(is.numeric, data),
              #                  selected = NULL),
              #   plotOutput("data")
              # )
              # fluidRow(
              #   splitLayout(cellWidths = c("50%", "50%"), plotOutput("plot.alt"), plotOutput("plot.phos")),
              #   column(width = 3, offset = 9,
              #          varSelectInput("y", "y", colnames(data), Filter(is.numeric, data), selected = NULL), style="z-index:1002;")
              # ),
              # fluidRow(plotlyOutput("plot"))
              fluidRow(
                splitLayout(cellWidths = c("50%", "50%"), plotOutput("plot.alt"), plotOutput("plot.phos"))
              )
      ),
      
      # Fourth tab content
      tabItem(tabName = "map",
              plotOutput("map", height = 700, dblclick = "map_dblclick", brush = brushOpts(id = "map_brush", resetOnNew =  TRUE)),
              "Drag and double click to zoom"
      )
    )
  )
)





server <- function(input, output, session){
  data <- reactive({
    get(input$dataset)
  })
  
  ranges <- reactiveValues(x = NULL, y = NULL)
  
  vars <- reactive({
    if (identical(input$dataset, "mtcars")) {
      setNames(as.list(names(mtcars)[1:5]), c(
        "Miles/(US) gallon",
        "Number of cylinders",
        "Displacement (cu.in.)",
        "Gross horsepower",
        "Rear axle ratio"
      ))
    } else {
      NULL
    }
  })
  
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
  
  output$table <- DT::renderDT({
    res_filter$filtered()
  }, extensions = 'Buttons', options = list(dom = 'Bfrtip',
                             buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
                             pageLength = 100)
                    )
  
  output$plots <- renderPlot({
    ggplot(res_filter$filtered(), aes(.data[[input$variable]])) + geom_histogram()
  
    # g <- ggplot(res_filter$filtered(), aes_string("disp", data$y)) +
    #   geom_point()
    # g <- ggplotly(g) %>%
    #   config(displayModeBar = TRUE)
    # g
  })
  
  # output$plot.alt = renderPlot({
  #   ggplot(res_filter$filtered(), aes(x = Altitude)) +
  #     geom_histogram(color="black", fill="white") +
  #     geom_vline(aes(xintercept=mean(Altitude)),
  #                color="blue", linetype="dashed", size=1)
  # })
  # output$plot.phos = renderPlot({
  #   # g <- ggplot(res_filter$filtered(), aes_string("Phosphorus"))+
  #   #   geom_point()
  #   # g <- ggplotly(g) %>%
  #   #   config(displayModeBar = TRUE)
  #   # g
  #   g <- ggplot(res_filter$filtered(), aes(x = Phosphorus)) +
  #     geom_histogram(color="black", fill="white") +
  #     geom_vline(aes(xintercept=mean(Phosphorus)),
  #                color="blue", linetype="dashed", size=1)
  #   g <- ggplotly(g) %>%
  #       config(displayModeBar = TRUE)
  #   g
  # })
  
  mapWorld <- borders("world", colour="gray50", fill="white")
  output$map = renderPlot({
    ggplot( ) + mapWorld + geom_point(data = res_filter$filtered(), aes(x = Longitude, y = Latitude, color = Race), alpha = 0.5) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE) 
       
      
  })
  
  observeEvent(input$map_dblclick, {
    brush <- input$map_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$code_dplyr <- renderPrint({
    res_filter$code()
  })
  output$code <- renderPrint({
    res_filter$expr()
  })
  
  output$res_str <- renderPrint({
    str(res_filter$filtered())
  })
  
  

}

shinyApp(ui, server)



