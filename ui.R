library(shiny)

shinyUI(fluidPage(
  ui <- fluidPage(
    includeCSS("style.css"),
  ),
  
  tableOutput("title"),
  
  tabsetPanel(
    tabPanel("Général",
             tableOutput("table_data")
    ),
    tabPanel("Poste",
    ),
    tabPanel("Team",
    ),
    tabPanel("Player",
    ),
  )
))