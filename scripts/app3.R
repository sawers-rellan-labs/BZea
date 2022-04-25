#UI
ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "sandstone"),
  tags$h2("The Alvarez Lines"),
  
  radioButtons(
    inputId = "dataset",
    label = "Data:",
    choices = c("Maize" = "zm",
                "Lasky_sorghum" = "sb",
                "Sorghum Association Panel" = "sap"
      
    ),
    inline = TRUE
  ),
  
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
      plotOutput("plot.alt"),
      plotOutput("plot.phos")
      
    )
  ),
  
  
)

#Server
server <- function(input, output, session) {
  
  data <- reactive({
    get(input$dataset)
  })
  
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
  }, options = list(pageLength = 10))

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
  
}

#Running App
shinyApp(ui, server)
