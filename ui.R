library(shiny)

shinyUI(fluidPage(
  ui <- fluidPage(
    includeCSS("style.css"),
  ),
  
  tableOutput("title"),
  
  tabsetPanel(
    mainPanel(
      tableOutput("graph_gen")
    ),
    sidebarPanel(
      uiOutput("opt_team"),
      uiOutput("opt_pays"),
      uiOutput("opt_player"),
      selectInput("opt_var", "Variable Principale", c('Tous', 'AGE', 'POSTE', 'VALEUR', 'MINUTE', 'BUT', 'PASSE D', 'EFFICACITE', 'EFF/MIN')),
      tableOutput("resume_panel")
    )
  )
))