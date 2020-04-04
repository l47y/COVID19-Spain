library(shiny)
library(shinythemes)
library(plotly)
library(shinyjs)

shinyUI(fluidPage(
  includeCSS("www/styles.css"),
  useShinyjs(),
  theme = shinytheme("cerulean"),
  
  fluidRow(
    tags$div(class="app_header", "Some description here")
  ),
  
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
      ),
      hidden(
        selectInput(
          "ccaa", 
          "Filtro CCAA", 
          choices = c("Andalucía","Aragón","Asturias","Baleares","C. Valenciana","Canarias","Cantabria","Castilla y León",
                          "Castilla-La Mancha","Cataluña","Ceuta","Extremadura","Galicia","La Rioja","Madrid","Melilla","Murcia",
                          "Navarra","País Vasco"),
          multiple = TRUE
        )
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
