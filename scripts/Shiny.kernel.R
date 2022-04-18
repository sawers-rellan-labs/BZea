sorghum <- vroom::vroom("Data/data.csv")
maize <- vroom::vroom("Data/data2.csv")


ui <- fluidPage(
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
)
server <- function(input, output, session){
  output$mytable1 <- DT::renderDataTable({
    DT::datatable(maize, options = list(orderClasses = TRUE))
  })
  output$mytable1 <- DT::renderDataTable({
    DT::datatable(sorghum, options = list(orderClasses = TRUE))
  })
}
shinyApp(ui, server)

