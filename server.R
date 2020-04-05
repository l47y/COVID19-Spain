library(data.table)
library(magrittr)
library(readr)
source("helpers.R")
source("config.R")

shinyServer(function(input, output, session) {
  
  # ------------------ Load dataset 
  data_list <- list(
    "altas" = read_csv(url("https://raw.githubusercontent.com/datadista/datasets/master/COVID%2019/ccaa_covid19_altas_long.csv")),
    "casos" = read_csv(url("https://raw.githubusercontent.com/datadista/datasets/master/COVID%2019/ccaa_covid19_casos_long.csv")),
    "falle" = read_csv(url("https://raw.githubusercontent.com/datadista/datasets/master/COVID%2019/ccaa_covid19_fallecidos_long.csv")),
    "hospi" = read_csv(url("https://raw.githubusercontent.com/datadista/datasets/master/COVID%2019/ccaa_covid19_hospitalizados_long.csv"))
  )
  my_data <- join_data(data_list)
  
  # ------------------ Reactive values and initial configurations
  current_lan <- reactiveVal("ES")
  shinyjs::hide("ccaa")
  
  # ------------------ When "CCAA" is selected, show the select input for CCAAs
  observe ({
    if (input$total_or_ccaa != "Total") {
      shinyjs::show("ccaa")
    } else {
      shinyjs::hide("ccaa")
    }
  })
  
  # ------------------ Change input labels/choices based on language selection
  observeEvent(input$lan_en, {
    current_lan("EN")
    html("app_header", html = header_en)
    html("app_descr1", html = descr1_en)
    html("app_descr2", html = descr2_en)
    updateSelectInput(session, "choose_data", label = choose_data_label_en, choices = choose_data_choices_en)
    updateSelectInput(session, "total_or_ccaa", label = total_or_ccaa_label_en, choices = total_or_ccaa_choices_en)
    updateSelectInput(session, "stat", label = stat_label_en, choices = stat_choices_en)
    updateSelectInput(session, "ccaa", label = ccaa_label_en)
    updateCheckboxInput(session, "relative_change", label = relative_change_label_en)
  })
  
  observeEvent(input$lan_es, {
    current_lan("ES")
    html("app_header", html = header_es)
    html("app_descr1", html = descr1_es)
    html("app_descr2", html = descr2_es)
    updateSelectInput(session, "choose_data", label = choose_data_label_es, choices = choose_data_choices_es)
    updateSelectInput(session, "total_or_ccaa", label = total_or_ccaa_label_es, choices = total_or_ccaa_choices_es)
    updateSelectInput(session, "stat", label = stat_label_es, choices = stat_choices_es)
    updateSelectInput(session, "ccaa", label = ccaa_label_es)
    updateCheckboxInput(session, "relative_change", label = relative_change_label_es)
  })
  
  # ------------------ Produce axis labels and plot title based on language and inputs
  get_plot_infos <- reactive({
    if (current_lan() == "ES") {
      my_choices <- choose_data_choices_es
      my_choices_stat <- stat_choices_es
      if (input$stat == my_choices_stat[2]) {
        yaxis <- "Casos nuevos por día"
        title <- paste0("Nuevos ", input$choose_data, " por día")
      } else {
        yaxis <- "Número acumulado" 
        title <- paste0("Número acumulado de ", input$choose_data, " por día")
      } 
      if (input$relative_change == TRUE) { 
        yaxis <- "Porcentaje de cambio respecto al día anterior"
        title <- paste0("Porcentaje de cambio de ", input$choose_data, " respecto al día anterior")
      }
      xaxis <- "Fecha"
    } else {
      my_choices <- choose_data_choices_en
      my_choices_stat <- stat_choices_en
      if (input$stat == my_choices_stat[2]) {
        yaxis <- "New cases per day"
        title <- paste0("New ", input$choose_data, " per day")
      } else {
        yaxis <- "Acumulative number" 
        title <- paste0("Acumulative of ", input$choose_data, " per day")
      } 
      if (input$relative_change == TRUE) { 
        yaxis <- "Porcentage of change with respect to previous day"
        title <- paste0("Porcentage of change of ", input$choose_data, " per day")
      }
      xaxis <- "Day"
    }
    list(title=title, yaxis=yaxis, xaxis=xaxis)
  })
  
  
  
  # ------------------ Main plot
  output$mainplot <- renderPlotly({
    tmp <- copy(my_data)
    
    # Filter data based on CCAA selection (or only total)
    if (input$total_or_ccaa == "Total") {
      tmp <- tmp[CCAA == "Total", ]
    } else {
      if (!is.null(input$ccaa)) {
        tmp <- tmp[tmp$CCAA %in% input$ccaa]
      }
    }
    
    # Take the corresponding language vector 
    if (current_lan() == "ES") {
      my_choices <- choose_data_choices_es
      my_choices_stat <- stat_choices_es
    }
    else {
      my_choices <- choose_data_choices_en
      my_choices_stat <- stat_choices_en
    }
    
    # Based on the selection of "choose_data", define the column which will be used
    if (input$choose_data == my_choices[1]) {my_col <- "total_casos"}
    else if (input$choose_data == my_choices[2]) {my_col <- "activos"}
    else if (input$choose_data == my_choices[3]) {my_col <- "total_altas"}
    else if (input$choose_data == my_choices[4]) {my_col <- "total_falle"}
    else if (input$choose_data == my_choices[5]) {my_col <- "total_hospi"}
    tmp[, total := tmp[[my_col]]]
    
    # Define lag variables and relative change variables 
    tmp[, lag_total := c(NA, total[-.N]), by=CCAA]
    tmp[, diff := total - lag_total] 
    tmp[, diff_lag := c(NA, diff[-.N]), by=CCAA]
    if (input$stat == my_choices_stat[2]) {
      tmp[, diff_rel := ((diff / diff_lag) * 100) - rep(100, nrow(tmp))]
    } else {
      tmp[, diff_rel := ((total / lag_total) * 100) - rep(100, nrow(tmp))]
    }
    
    # Based on the state of the inputs "stat" and "relative_change", determine which column will be shown
    if (input$relative_change == TRUE) {
      show_col <- "diff_rel"
    } else {
      if (input$stat == my_choices_stat[2]) {
        show_col <- "diff"
      } else {
        show_col <- "total"
      }
    }
    
    # Draw plotly bar plot
    infos <- get_plot_infos()
    plot_ly(x = tmp$fecha, y = tmp[[show_col]], color = tmp$CCAA, type="bar") %>% 
      layout(title = infos$title, 
             xaxis = list(title = infos$xaxis, tickmode='linear'), 
             yaxis = list(title = infos$yaxis))
  })
})