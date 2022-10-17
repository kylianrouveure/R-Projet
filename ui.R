library(shiny)

shinyUI(fluidPage(
  ui <- fluidPage(
    includeCSS("style.css"),
  ),
  
  tableOutput("title"),
  
  mainPanel(
    actionButton("export_graph", "Exporter le graphique en PNG"),
    plotOutput("graph_data"),
    actionButton("export_data", "Exporter les données"),
    tableOutput("table_data")
  ),
  sidebarPanel(
    imageOutput("logoligue1"),
    uiOutput("opt_team"),
    uiOutput("opt_pays"),
    uiOutput("opt_player"),
    selectInput("opt_var", "Variable Principale", c('Tous', 'AGE', 'POSTE', 'VALEUR', 'MINUTE', 'BUT', 'PASSE D', 'EFFICACITE', 'EFF/MIN')),
    tableOutput("resume_panel"),
    id = "nav"
  )
))