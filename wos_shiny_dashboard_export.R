library(RPostgres)
library(RPostgreSQL)
library(odbc)
library(dbplyr)
library(shiny)
library(DBI)
library(shinydashboard)
library(DT)

ui <- dashboardPage(skin = 'black',
                    dashboardHeader(title = "Web of Science Query Tool", titleWidth = 300,
                                    dropdownMenu(type = "notifications",
                                                 notificationItem(
                                                   text = "Read me",
                                                   icon("glasses")
                                                 ))),
                    dashboardSidebar(
                      textAreaInput("query",label = "Enter SQL Query:", placeholder = "SELECT * FROM wos_address_organizations, wos_summary_names WHERE organization LIKE 'Stanford%'", value = "SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname	= 'public' " ),
                      numericInput("nrows", "Enter the number of rows to display:", min = 1, 20),
                      downloadButton("downloadData", "Download")),
                    dashboardBody(
                      fluidRow(div(style = 'overflow-x: scroll', dataTableOutput("tbl")))
                    ))



server <- function(input, output, session) {
  table <- eventReactive(list(input$query, input$nrows),{
    conn <- dbConnect(drv = RPostgres::Postgres(),
                      dbname = "wos",
                      host = "wos.cxo3wqeijrjm.us-east-2.rds.amazonaws.com",
                      user = "wos_admin",
                      password = "ssds3141",
                      port = "5432")
    on.exit(dbDisconnect(conn), add = TRUE)
    dbGetQuery(conn, paste0(input$query, paste0("LIMIT "),input$nrows, ";"))
  })
  
  output$tbl<-renderDataTable({table()}) 
  
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
