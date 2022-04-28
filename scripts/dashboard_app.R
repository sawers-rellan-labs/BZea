## ui.R ##
ui <-  dashboardPage(
  
  dashboardHeader(title = "The GEMMA Lab- Genetics, Evolution and Metabolism of Maize Adaptation Lab",
                  titleWidth = 700),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Data", tabName = "data", icon = icon("database")),
      menuItem("Filter", tabName = "filter", icon = icon("filter")),
      menuItem("Table", tabName = "table", icon = icon("table")),
      menuItem("Chart", tabName = "plots", icon = icon("chart-area")),
      menuItem("Map", tabName = "map", icon = icon("globe")),
      menuItem("Download", tabName = "download", icon = icon("download")),
      menuItem("About us", tabName = "about_us", icon = icon("user"))
    )
  ),
  
  dashboardBody(
    tabItems(
      #First tab-data content
      tabItem(tabName = "data",
              fluidPage(
                radioButtons(
                  inputId = "dataset",
                  label = "Data:",
                  choices = c("Maize-Metadata.R2" = "zm",
                              "Lasky_sorghum" = "sb",
                              "Sorghum Association Panel" = "sap"
                              
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
              fluidRow(
                splitLayout(cellWidths = c("50%", "50%"), plotOutput("plot.alt"), plotOutput("plot.phos"))
              )
      ),
      
      # Fourth tab content
      tabItem(tabName = "map",
              plotOutput("map", height = 700, dblclick = "map_dblclick", brush = brushOpts(id = "map_brush", resetOnNew =  TRUE)),
              "Drag and double click to zoom"
      ),
      
      
      # Fifth tab content
      tabItem(tabName = "download",
              downloadButton('downloads',"Download the data"),
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
  }, options = list(pageLength = 25))
  
  output$plot.alt = renderPlot({
    ggplot(res_filter$filtered(), aes(x = Altitude)) +
      geom_histogram(color="black", fill="white") +
      geom_vline(aes(xintercept=mean(Altitude)),
                 color="blue", linetype="dashed", size=1)
  })
  output$plot.phos = renderPlot({
    ggplot(res_filter$filtered(), aes(x = Phosphorus)) +
      geom_histogram(color="black", fill="white") +
      geom_vline(aes(xintercept=mean(Phosphorus)),
                 color="blue", linetype="dashed", size=1)
  })
  
  mapWorld <- borders("world", colour="gray50", fill="white")
  output$map = renderPlot({
    ggplot( ) + mapWorld + geom_point(data = res_filter$filtered(), aes(x = Longitude, y = Latitude, color = Country), alpha = 0.5) +
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
  
  output$downloads <- downloadHandler(
    filename = function(){"table.csv"}, 
    content = function(fname){
      write.csv(data, fname)
    }
  )
  
  

  
}

shinyApp(ui, server)


