library(shiny)
library(shinythemes)
library(plotly)

shinyUI(fluidPage(
  includeCSS("www/styles.css"),
  theme = shinytheme("cerulean"),
  fluidRow(
    column(
      2, 
      selectInput(
        "choose_data", 
        "Elige datos", 
        choices = c("Casos", "Altas", "Hospitalizados", "Fallecidos", "Activos")
      ),
      selectInput(
        "total_or_ccaa",
        "Total o por CCAA", 
        choices = c("Total", "Por CCAA")
      ),
      selectInput(
        "stat", 
        "Elige estadística",
        choices=c("Acumulado", "Cambio absoluto", "Cambio relativo")
      )
    ),
    column(
      10, 
      plotlyOutput(
        "mainplot",
        height=800
      )
    )
  )
))
