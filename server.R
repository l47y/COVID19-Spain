library(data.table)
library(magrittr)
library(readr)
source("helpers.R")
source("config.R")

shinyServer(function(input, output, session) {
  
  data_list <- list(
    "altas" = read_csv(url("https://raw.githubusercontent.com/datadista/datasets/master/COVID%2019/ccaa_covid19_altas_long.csv")),
    "casos" = read_csv(url("https://raw.githubusercontent.com/datadista/datasets/master/COVID%2019/ccaa_covid19_casos_long.csv")),
    "falle" = read_csv(url("https://raw.githubusercontent.com/datadista/datasets/master/COVID%2019/ccaa_covid19_fallecidos_long.csv")),
    "hospi" = read_csv(url("https://raw.githubusercontent.com/datadista/datasets/master/COVID%2019/ccaa_covid19_fallecidos_long.csv"))
  )
  my_data <- join_data(data_list)
  current_lan <- reactiveVal("ES")
  
  shinyjs::hide("ccaa")
  
  observe ({
    if (input$total_or_ccaa != "Total") {
      shinyjs::show("ccaa")
    } else {
      shinyjs::hide("ccaa")
    }
  })
  
 
  
  observeEvent(input$lan_en, {
    current_lan("EN")
    updateSelectInput(session, "choose_data", label = choose_data_label_en, choices = choose_data_choices_en)
    updateSelectInput(session, "total_or_ccaa", label = total_or_ccaa_label_en, choices = total_or_ccaa_choices_en)
    updateSelectInput(session, "stat", label = stat_label_en, choices = stat_choices_en)
    updateSelectInput(session, "ccaa", label = ccaa_label_en)
  })
  
  observeEvent(input$lan_es, {
    current_lan("ES")
    updateSelectInput(session, "choose_data", label = choose_data_label_es, choices = choose_data_choices_es)
    updateSelectInput(session, "total_or_ccaa", label = total_or_ccaa_label_es, choices = total_or_ccaa_choices_es)
    updateSelectInput(session, "stat", label = stat_label_es, choices = stat_choices_es)
    updateSelectInput(session, "ccaa", label = ccaa_label_es)
  })
  
  get_plot_infos <- reactive({
    if (current_lan() == "ES") {
      if (input$stat %in% c("Cambio absoluto", "Absolute change")) {yaxis <- "Cambio del número absoluto respecto al día anterior"}
      else if (input$stat %in% c("Cambio relativo", "Relative change")) { yaxis <- "% cambio respecto al día anterior"}
      else {yaxis <- "Número acumulado" } 
      xaxis <- "Fecha"
      title <- paste0(input$stat, " de ", input$choose_data, " por fecha")
    } else {
      if (input$stat %in% c("Cambio absoluto", "Absolute change")) {yaxis <- "Absolute change with respect to previous day"}
      else if (input$stat %in% c("Cambio relativo", "Relative change")) { yaxis <- "% change with respect to previous day"}
      else {yaxis <- "Absolute number" } 
      xaxis <- "Day"
      title <- paste0(input$stat, " of ", input$choose_data, " per day")
    }
    list(title=title, yaxis=yaxis, xaxis=xaxis)
  })
  
  output$mainplot <- renderPlotly({
    tmp <- copy(my_data)
 
    
    if (input$total_or_ccaa == "Total") {
      tmp <- tmp[CCAA == "Total", ]
    } else {
      if (!is.null(input$ccaa)) {
        tmp <- tmp[tmp$CCAA %in% input$ccaa]
      }
    }
    if (input$choose_data %in% c("Fallecidos", "Deaths")) {my_col <- "total_falle"}
    else if (input$choose_data %in% c("Casos", "Cases")) {my_col <- "total_casos"}
    else if (input$choose_data %in% c("Hospitalizados", "Hospitalized")) {my_col <- "total_hospi"}
    else if (input$choose_data %in% c("Altas", "Recovered")) {my_col <- "total_altas"}
    else if (input$choose_data %in% c("Activos", "Actives")) {my_col <- "activos"}
    
    tmp[, total := tmp[[my_col]]]
    
    tmp[, lag_total := c(NA, total[-.N]), by=CCAA]
    tmp[, diff := total - lag_total] 
    tmp[, diff_rel := ((total / lag_total) * 100) - rep(100, nrow(tmp))]
    if (input$stat %in% c("Cambio absoluto", "Absolute change")) {
      show_col <- "diff"
      yaxis <- "Cambio del número absoluto respecto al día anterior"
    } else if (input$stat %in% c("Cambio relativo", "Relative change")) {
      show_col <- "diff_rel"
      yaxis <- "% cambio respecto al día anterior"
    } else {
      show_col <- "total"
      yaxis <- "Número acumulado"
    }
    infos <- get_plot_infos()
    plot_ly(x = tmp$fecha, y = tmp[[show_col]], color = tmp$CCAA, type="bar") %>% 
      layout(title = infos$title, 
             xaxis = list(title = infos$xaxis, tickmode='linear'), 
             yaxis = list(title = infos$yaxis))
  })
  
})