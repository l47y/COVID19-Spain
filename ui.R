library(shiny)
library(shinythemes)
library(plotly)
library(shinyjs)
library(shinyWidgets)
source("config.R")

shinyUI(fluidPage(theme = shinytheme("flatly"),
  includeCSS("www/styles.css"),
  useShinyjs(),
  #theme = shinytheme("cerulean"),
  
  fluidRow(
    column(
      10,
      tags$div(id="app_header", header_es, style="font-size: 48px;")
    ), 
    column(
      2,
      actionGroupButtons(
        c("lan_es", "lan_en"),
        c("ES", "EN"),
        status = "primary",
        size = "normal",
        direction = "horizontal",
        fullwidth =FALSE
      )
     
    )
  ),
  
  fluidRow(
    fluidRow(
      column(2, 
         tags$div(id="app_descr1", descr1_es, style="font-size: 24px; text-align: right;")
      ),
      column(2, 
         tags$div(id="app_descr1_link", tags$a(href="https://github.com/l47y/COVID19-Spain", "click"), 
                  style="font-size: 24px; text-align_left;")
      )
    ),
    fluidRow(
      column(2, 
             tags$div(id="app_descr2", descr2_es, style="font-size: 24px; text-align: right;")
      ),
      column(2, 
             tags$div(id="app_descr2_link", tags$a(href="https://github.com/l47y/COVID19-Spain", "click"), 
                      style="font-size: 24px; text-align:left")
      )
    ),
    style="margin-bottom:4%; margin-top:1%"
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
        stat_choices_es
      ),
      checkboxInput(
        "relative_change",
        label = relative_change_label_es
        
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
      addSpinner(
        plotlyOutput(
          "mainplot",
          height=800
        ),
        spin = "circle", 
        color = "#112446"
      )
    )
  )
))
