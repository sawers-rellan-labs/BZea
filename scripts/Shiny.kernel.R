sorghum <- vroom::vroom("Data/data.csv")
maize <- vroom::vroom("Data/data2.csv")


ui <- fluidPage(
<<<<<<< HEAD
  selectInput("cropID", "Crop Type", 
              c("Maize" = "maize",
                "Sorghum" = "sorghum")),
  tableOutput("crop_data")
=======
  selectInput("dataset", "Crop Type", 
              c("Maize" = "maize",
                "Sorghum" = "sorghum")),
      sidebarLayout(
      sidebarPanel(
        conditionalPanel(
          'input.dataset' == "maize"
        ),
        conditionalPanel(
          'input.dataset' == "sorghum"
        )
      ),
      mainPanel(
        tabsetPanel(
          id = 'dataset',
          tabPanel("maize", DT::dataTableOutput("mytable1")),
          tabPanel("sorghum", DT::dataTableOutput("mytable2"))
        )
      )
    )
>>>>>>> ea23b57ee334de0574c3aaa20b44558afd437b6c
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
  output$mytable1 <- DT::renderDataTable({
    DT::datatable(sorghum, options = list(orderClasses = TRUE))
  })
}
shinyApp(ui, server)


maize_data <- DT::renderDataTable({
  DT::datatable(maize, options = list(orderClasses = TRUE))
 })  
