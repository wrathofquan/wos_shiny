library(RPostgres)
library(RPostgreSQL)
library(odbc)
library(dbplyr)
library(tidyverse)
library(shiny)
library(DBI)

ui <- fluidPage(
  headerPanel("Web of Science WebUI"),
  textInput("query",label = "Enter SQL Query Here:", placeholder = "SELECT * FROM wos_summary;", value = "SELECT * FROM wos_summary LIMIT "),
  numericInput("nrows", "Enter the number of rows to display:", 5),
  downloadButton("downloadData", "Download"),
  tableOutput("tbl")
  
)

server <- function(input, output, session) {
  output$tbl <- renderTable({
    con <- dbConnect(drv = RPostgres::Postgres(),
                     dbname = "wos",
                     host = "localhost",
                     user = "wos_admin",
                     port = "5432")
    on.exit(dbDisconnect(con), add = TRUE)
    dbGetQuery(con, paste0(input$query,  input$nrows, ";"))
  })
  
}

shinyApp(ui, server)


