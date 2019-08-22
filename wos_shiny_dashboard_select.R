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
                      selectizeInput("table", label = "Select a table:", 
                                  choices = list("wos_abstracts","wos_abstract_paragraphs",
                                                 "wos_address_names", "wos_address_organizations",
                                                 "wos_address_suborganizations",
                                                 "wos_address_zip", "wos_addresses", "wos_book_desc",
                                                 "wos_book_notes", "wos_conference", "wos_conf_date", "wos_conf_info",
                                                 "wos_conf_location", "wos_conf_sponsor", "wos_conf_title",
                                                 "wos_contributors", "wos_doctypes", "wos_dynamic_identifiers",
                                                 "wos_edition","wos_grants", "wos_grant_alt_agencies", "wos_grant_ids",
                                                 "wos_headings", "wos_keywords", "wos_keywords_plus", "wos_languages",
                                                 "wos_normalized_languages", "wos_normalized_doctypes", "wos_page",
                                                 "wos_publisher_names", "wos_references", "wos_reviewed_authors",
                                                 "wos_reviewed_languages", "wos_subheadings", "wos_subjects",
                                                 "wos_summary", "wos_summary_names", "wos_titles"
                                                 ), multiple = FALSE, selected = "wos_abstract_paragraphs"),
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
  table <- eventReactive(list(input$table, input$nrows),{
    conn <- dbConnect(drv = RPostgres::Postgres(),
                      dbname = "wos",
                      host = "wos.cxo3wqeijrjm.us-east-2.rds.amazonaws.com",
                      user = "wos_admin",
                      password = "ssds3141",
                      port = "5432")
    on.exit(dbDisconnect(conn), add = TRUE)
    dbGetQuery(conn, paste0("SELECT * FROM ", paste0(input$table), paste0("  LIMIT "),input$nrows, ";"))
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

options(shiny.sanitize.errors = TRUE)
shinyApp(ui, server)
