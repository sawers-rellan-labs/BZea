sorghum <- vroom::vroom("Data/data.csv")
maize <- vroom::vroom("Data/data2.csv")


ui <- fluidPage(
  selectInput("cropID", "Crop Type", 
              c("Maize" = "maize",
                "Sorghum" = "sorghum")),
  tableOutput("crop_data")
)
server <- function(input, output, session){
  # maize_data <- DT::renderDataTable({
  #  DT::datatable(maize, options = list(orderClasses = TRUE))
  # })
  # sorghum_data <- DT::renderDataTable({
  #  DT::datatable(sorghum, options = list(orderClasses = TRUE))
  # })
  maize_data <- data.frame(maize)
  sorghum_data <- data.frame(sorghum)
  
  datasetInput <- reactive({
    if(input$cropID == "Maize"){
      dataset <- maize_data
    }
    else if (input$cropID == "Sorghum"){
      dataset <- sorghum_data
    }
    return(dataset)
  })
  output$crop_data <- renderTable({
    datasetInput()
  })
}
shinyApp(ui, server)


maize_data <- DT::renderDataTable({
  DT::datatable(maize, options = list(orderClasses = TRUE))
 })  
