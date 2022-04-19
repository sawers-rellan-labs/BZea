sb <- vroom::vroom("Data/data.csv")
zm <- vroom::vroom("Data/data2.csv")


ui <- fluidPage(
  selectInput("cropID", "Crop Type", 
              c("Maize" = "maize",
                "Sorghum" = "sorghum")),
  tableOutput("crop_data")
    
)
server <- function(input, output, session){

  maize_data <- data.frame(zm)
  sorghum_data <- data.frame(sb)

  datasetInput <- reactive({
    if(input$cropID == "maize"){
      dataset <- maize_data
    }
    else if (input$cropID == "sorghum"){
      dataset <- sorghum_data
    }
    return(dataset)
  })
  output$crop_data <- renderTable({
    datasetInput()
  })
  output$mytable1 <- DT::renderDataTable({
    DT::datatable(sorghum, options = list(orderClasses = TRUE))
  })
}
shinyApp(ui, server)






