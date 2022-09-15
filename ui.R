library(shiny)

shinyUI(fluidPage(
  ui <- fluidPage(
    includeCSS("style.css"),
  ),
  
  includeHTML("INCLUDE/header.html"),
  
  tabsetPanel(
    tabPanel("Général",
      tableOutput("table_data"),
    ),
    tabPanel("Poste",
    ),
    tabPanel("Team",
    ),
    tabPanel("Player",
    ),
  )
))