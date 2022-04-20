sb <- vroom::vroom("Data/data.csv")
zm <- vroom::vroom("Data/data2.csv")


ui <- fluidPage(
  selectInput("cropID", "Crop Type", 
              c("Maize" = "maize",
                "Sorghum" = "sorghum")),
  #tableOutput("crop_data"),
  
  fluidRow(
    column(12,
           DTOutput("crop_data")
    )
  ),
)
server <- function(input, output, session){

  datasetInput <- reactive({
    if(input$cropID == "maize"){
      dataset <- zm
    }
    else if (input$cropID == "sorghum"){
      dataset <- sb
    }
    return(dataset)
  })
  
  output$crop_data <- renderTable({
    datasetInput()
  })
  
  output$table <- renderDT(dataset,
                           filter = "top",
                           options = list(
                             pageLength = 5
                           )
  )
  
  output$mytable1 <- DT::renderDataTable({
    DT::datatable(sorghum, options = list(orderClasses = TRUE))
  })

}

shinyApp(ui, server)

?paste()

y




https://dataviz.shef.ac.uk/blog/05/02/2021/Shiny-Template