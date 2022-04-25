<<<<<<< HEAD
#Data Management
zm.donor <- unique(zm$Donor_accession)
draw_plot <- function(plot_donor){
  filtered_donor <- zm %>%
    filter(Donor_accession == !!plot_donor)
  ggplot(filtered_donor, aes(Donor)) +
    geom_histogram()
}

=======
>>>>>>> f69b51adb9b2cc2b1b91cb5ebad50ca0b81d7f76
#UI
ui <- fluidPage(
  tags$h2("The Alvarez Lines"),
  
  radioButtons(
    inputId = "dataset",
    label = "Data:",
    choices = c("Maize" = "zm",
                "Sorghum" = "sb"
      
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
      DT::dataTableOutput(outputId = "table")
     
    )
  )
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
  
}

#Running App
shinyApp(ui, server)
