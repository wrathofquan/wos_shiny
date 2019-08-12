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
                      textAreaInput("query",label = "Enter SQL Query:", placeholder = "SELECT * FROM wos_address_organizations, wos_summary_names WHERE organization LIKE 'Stanford%'", value = "SELECT * FROM wos_address_organizations, wos_summary_names WHERE organization LIKE 'Stanford%'" ),
                      numericInput("nrows", "Enter the number of rows to display:", 10),
                      downloadButton("downloadData", "Download")),
                    dashboardBody(
                      fluidRow(div(style = 'overflow-x: scroll', tableOutput("tbl")))
                    ))



server <- function(input, output, session) {
  table <- eventReactive(list(input$query, input$nrows),{
    conn <- dbConnect(drv = RPostgres::Postgres(),
                      dbname = "wos",
                      host = "localhost",
                      user = "wos_admin",
                      port = "5432")
    on.exit(dbDisconnect(conn), add = TRUE)
    dbGetQuery(conn, paste0(input$query, paste0("LIMIT "),input$nrows, ";"))
  })
  
  output$tbl<-renderTable(table())
  
  # output$connectionlist <- eventReactive(input$list,{dbGetQuery(conn, "show processlist")})
  # 
  # tags$style(type="text/css",
  #            ".shiny-output-error { visibility: hidden; }",
  #            ".shiny-output-error:before { visibility: hidden; }"
  # )
  
  output$downloadData <- downloadHandler(
    filename = function() { paste(Sys.time(),".csv",sep = "") },
    content = function(file) {
      write.csv(table(), file)
      
    })
}

shinyApp(ui, server)
