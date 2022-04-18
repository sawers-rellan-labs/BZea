maize <- vroom::vroom("Data/data.csv")


ui <- fluidPage(
  #selectInput("dataset", label = "Dataset",  c("Maize" = "zm", "Sorghum" = "sb")),
  #titlePanel("Maize"),
    sidebarLayout(
      sidebarPanel(
        conditionalPanel(
          'input.dataset' == "maize"
        )
      ),
      mainPanel(
        tabsetPanel(
          id = 'dataset',
          tabPanel("maize", DT::dataTableOutput("mytable1"))
        )
      )
    )
)
server <- function(input, output, session){
  output$mytable1 <- DT::renderDataTable({
    DT::datatable(maize, options = list(orderClasses = TRUE))
  })
}
shinyApp(ui, server)

