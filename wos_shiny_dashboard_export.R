library(RPostgres)
library(RPostgreSQL)
library(odbc)
library(dbplyr)
library(shiny)
library(DBI)
library(shinydashboard)
library(DT)

ui <- dashboardPage(skin = 'black',
                    dashboardHeader(title = "Web of Science Query Tool", titleWidth = 300),
                    dashboardSidebar(
                      textAreaInput("query", label = "Enter SQL Query:", placeholder = "SELECT * FROM wos_address_organizations WHERE organization LIKE 'Stanford%'", value = "SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname	= 'public' " ),
                      numericInput("nrows", "Enter the total number of observations to return:", min = 1, 100),
                      downloadButton("downloadData", "Download"),
                      br(),
                      br(),
                      menuItem("Source", icon = icon("github"), 
                               href = "https://github.com/wrathofquan/wos_shiny")),
                    dashboardBody(
                      fluidRow(div(style = 'overflow-x: scroll', DTOutput("tbl")))
                    ))



server <- function(input, output, session) {
  table <- eventReactive(list(input$query, input$nrows),{
    conn <- dbConnect(drv = RPostgres::Postgres(),
                      dbname = "wos",
                      host = "wos.cxo3wqeijrjm.us-east-2.rds.amazonaws.com",
                      user = "wos_admin",
                      password = "####",
                      port = "5432")
    on.exit(dbDisconnect(conn), add = TRUE)
    dbGetQuery(conn, paste0(input$query, paste0("  LIMIT "),input$nrows, ";"))
  })
  
  output$tbl<-renderDT(table(), filter = 'top', server = TRUE,
                       options = list(
                         search = list(regex = TRUE, caseInsensitive = TRUE))
  )
  
  
  
  # output$connectionlist <- eventReactive(input$list,{dbGetQuery(conn, "show processlist")})
  # 
  # tags$style(type="text/css",
  #            ".shiny-output-error { visibility: hidden; }",
  #            ".shiny-output-error:before { visibility: hidden; }"
  # )
  

  output$downloadData <- downloadHandler(
    filename = function() { paste(Sys.time(),".csv",sep = "") },
    content = function(file) {
      write.csv(table()[input[["tbl_rows_all"]], ], file)
      
    })
}

shinyApp(ui, server)
