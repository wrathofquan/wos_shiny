library(RPostgres)
library(RPostgreSQL)
library(odbc)
library(dbplyr)
library(tidyverse)
library(shiny)
library(DBI)
library(shinydashboard)


ui <- dashboardPage(skin = 'black',
  dashboardHeader(title = "Web of Science Query Tool", titleWidth = 300),
  dashboardSidebar(
    textInput("query",label = "Enter SQL Query:", placeholder = "SELECT * FROM wos_address_organizations, wos_summary_names WHERE organization LIKE 'Stanford%'", value = "SELECT * FROM wos_address_organizations, wos_summary_names WHERE organization LIKE 'Stanford%'" ),
    numericInput("nrows", "Enter the number of rows to display:", 10),
    downloadButton("downloadData", "Download")),
  dashboardBody(
    fluidRow(div(style = 'overflow-x: scroll', tableOutput("tbl")))
    ))
    

  
server <- function(input, output, session) {

    
  output$tbl <- renderTable({
    con <- dbConnect(drv = RPostgres::Postgres(),
                     dbname = "wos",
                     host = "localhost",
                     user = "wos_admin",
                     port = "5432")
    on.exit(dbDisconnect(con), add = TRUE)
    dbGetQuery(con, paste0(input$query, paste0("LIMIT "),input$nrows, ";"))
  })
  
  
  
  output$downloadData <- downloadHandler(
    filename = function() { paste('selectedQuery',".csv",sep = "") },
    content = function(file) {
      write.csv(tbl, file)
      
    })
}

shinyApp(ui, server)
