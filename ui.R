library(shiny)

shinyUI(fluidPage(
  ui <- fluidPage(
    includeCSS("style.css"),
  ),
  
  includeHTML("INCLUDE/header.html"),
  
  tabsetPanel(
    tabPanel("Général",
      plotOutput("plot_gen_1"),
    ),
    tabPanel("Poste",
    ),
    tabPanel("Team",
    ),
    tabPanel("Player",
    ),
  )
))