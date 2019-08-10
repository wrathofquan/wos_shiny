library(RPostgres)
library(RPostgreSQL)
library(odbc)
library(dbplyr)
library(tidyverse)
library(shiny)
library(DBI)



ui <- fluidPage(
  headerPanel("Web of Science WebUI"),
  numericInput("nrows", "Enter the number of rows to display:", 5),
  tableOutput("tbl"),
  downloadButton("downloadData", "Download")
  
)

server <- function(input, output, session) {
  output$tbl <- renderTable({
    con <- dbConnect(drv = RPostgres::Postgres(),
                dbname = "wos",
                host = "localhost",
                user = "wos_admin",
                port = "5432")
    on.exit(dbDisconnect(con), add = TRUE)
    dbGetQuery(con, paste0(
      "SELECT id, title FROM wos_titles LIMIT ", input$nrows, ";"))
  })
}

shinyApp(ui, server)


