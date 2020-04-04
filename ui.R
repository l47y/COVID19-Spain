library(shiny)
library(shinythemes)
library(plotly)
library(shinyjs)
library(shinyWidgets)
source("config.R")

shinyUI(fluidPage(
  includeCSS("www/styles.css"),
  useShinyjs(),
  theme = shinytheme("cerulean"),
  
  fluidRow(
    column(
      10,
      tags$div(class="app_header", "Some description here")
    ), 
    column(
      2,
      actionGroupButtons(
        c("lan_es", "lan_en"),
        c("ES", "EN"),
        status = "primary",
        size = "normal",
        direction = "horizontal",
        fullwidth = TRUE
      )
     
    )
  ),
  
  fluidRow(
    column(
      2, 
      selectInput(
        "choose_data", 
        choose_data_label_es, 
        choices = choose_data_choices_es
      ),
      selectInput(
        "total_or_ccaa",
        total_or_ccaa_label_es, 
        total_or_ccaa_choices_es
      ),
      selectInput(
        "stat", 
        stat_label_es,
        stat_choices_es,
      ),
      hidden(
        selectInput(
          "ccaa", 
          ccaa_label_es, 
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
