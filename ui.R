source("config.R")

shinyUI(fluidPage(
  
  theme = shinytheme("flatly"),
  includeCSS("www/styles.css"),
  useShinyjs(),
  
  # ------------------ App header and language button
  fluidRow(
    column(
      8,
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
  
  # ------------------ Description lines in upper part of the App
  fluidRow(
    fluidRow(
      column(2, 
         tags$div(id="app_descr1", descr1_es, style="font-size: 48dp; text-align: right;")
      ),
      column(2, 
         tags$div(id="app_descr1_link", tags$a(href="https://github.com/l47y/COVID19-Spain", "click"), 
                  style="font-size: 36dp; text-align_left;")
      )
    ),
    fluidRow(
      column(2, 
             tags$div(id="app_descr2", descr2_es, style="font-size: 36dp; text-align: right;")
      ),
      column(2, 
             tags$div(id="app_descr2_link", tags$a(href="https://github.com/l47y/COVID19-Spain", "click"), 
                      style="font-size: 36dp; text-align:left")
      )
    ),
    style="margin-bottom:4%; margin-top:1%"
  ),
  
  # ------------------ Left column with inputs
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
    
    # ------------------ Right column with plot
    column(
      10, 
      shiny::div(
        id = "plot_div",
        addSpinner(
          plotlyOutput(
            "mainplot",
            height="100%",
          ),
          spin = "circle", 
          color = "#112446"
        )
      )
    )
  )
))
