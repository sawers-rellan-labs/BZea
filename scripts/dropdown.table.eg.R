library(tidyverse)
library(shiny)
a_df <- tibble(
  var_one = c("hadley", "charlotte", "rené", "raymond"),
  var_two = c("mutate", "filter", "slice", "spread"),
  var_three = c("an apple", "a pipe", "a cocktail", "a dog"),
  var_four = c("with", "without", "thanks", "out of"),
  var_five = c("tidyr", "magrittr", "purrr", "dplyr")
)

head(a_df)

ex_df <- expand.grid(a_df) # create a df with the 64 combinaisons
head(ex_df,20)
head(sample_n(ex_df, 40), 20)
tib <- as_tibble(sample_n(ex_df, 40))



shinyApp(
  ui = pageWithSidebar(
    headerPanel("Painting 8"),
    sidebarPanel(
      selectizeGroupUI(
        id = "my-filters",
        inline = FALSE,
        params = list(
          var_one = list(inputId = "var_one", title = "Select variable 1", placeholder = 'select'),
          var_two = list(inputId = "var_two", title = "Select variable 2", placeholder = 'select'),
          var_three = list(inputId = "var_three", title = "Select variable 3", placeholder = 'select'),
          var_four = list(inputId = "var_four", title = "Select variable 4", placeholder = 'select'),
          var_five = list(inputId = "var_five", title = "Select variable 5", placeholder = 'select')
        )
      )
    ),
    
    mainPanel(
      tableOutput("table")
    )
  ),
  
  server = function(input, output, session) {
    
    res_mod <- callModule(
      module = selectizeGroupServer,
      id = "my-filters",
      data = tib,
      vars = c("var_one", "var_two", "var_three", "var_four", "var_five")
    )
    
    output$table <- renderTable({
      res_mod()
    })
    
  },
  
  options = list(height = 500)
)
