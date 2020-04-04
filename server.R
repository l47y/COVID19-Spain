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
  
  shinyjs::hide("ccaa")
  
  observe ({
    if (input$total_or_ccaa != "Total") {
      shinyjs::show("ccaa")
    } else {
      shinyjs::hide("ccaa")
    }
  })
  
  observeEvent(input$lan_en, {
    updateSelectInput(session, "choose_data", label = choose_data_label_en, choices = choose_data_choices_en)
    updateSelectInput(session, "total_or_ccaa", label = total_or_ccaa_label_en, choices = total_or_ccaa_choices_en)
    updateSelectInput(session, "stat", label = stat_label_en, choices = stat_choices_en)
    updateSelectInput(session, "ccaa", label = ccaa_label_en)
  })
  
  observeEvent(input$lan_es, {
    updateSelectInput(session, "choose_data", label = choose_data_label_es, choices = choose_data_choices_es)
    updateSelectInput(session, "total_or_ccaa", label = total_or_ccaa_label_es, choices = total_or_ccaa_choices_es)
    updateSelectInput(session, "stat", label = stat_label_es, choices = stat_choices_es)
    updateSelectInput(session, "ccaa", label = ccaa_label_es)
  })
  
  # get_data <- reactive({
  #   if (input$choose_data == "Casos") {tmp <- data_list$casos} 
  #   else if (input$choose_data == "Altas") {tmp <- data_list$altas}
  #   else if (input$choose_data == "Hospitalizados") {tmp <- data_list$hospi}
  #   else {tmp <- data_list$falle}
  #   setDT(tmp)
  # })
  
  output$mainplot <- renderPlotly({
    tmp <- copy(my_data)
    if (!is.null(input$ccaa)) {
      tmp <- tmp[tmp$CCAA %in% input$ccaa]
    }
    print(tmp)
    if (input$total_or_ccaa == "Total") {
      tmp <- tmp[CCAA == "Total", ]
    } else {
      tmp <- tmp[!CCAA == "Total", ]
    }
    if (input$choose_data == "Fallecidos") {my_col <- "total_falle"}
    else if (input$choose_data == "Casos") {my_col <- "total_casos"}
    else if (input$choose_data == "Hospitalizados") {my_col <- "total_hospi"}
    else if (input$choose_data == "Altas") {my_col <- "total_altas"}
    else if (input$choose_data == "Activos" ) {my_col <- "activos"}
    
    tmp[, total := tmp[[my_col]]]
    
    tmp[, lag_total := c(NA, total[-.N]), by=CCAA]
    tmp[, diff := total - lag_total] 
    tmp[, diff_rel := ((total / lag_total) * 100) - rep(100, nrow(tmp))]
    if (input$stat == "Cambio absoluto") {
      show_col <- "diff"
      yaxis <- "Cambio del número absoluto respecto al día anterior"
    } else if (input$stat == "Cambio relativo") {
      show_col <- "diff_rel"
      yaxis <- "% cambio respecto al día anterior"
    } else {
      show_col <- "total"
      yaxis <- "Número acumulado"
    }
    plot_ly(x = tmp$fecha, y = tmp[[show_col]], color = tmp$CCAA, type="bar") %>% 
      layout(title = paste0(input$stat, " de ", input$choose_data, " por fecha"), 
             xaxis = list(title = "Fecha", tickmode='linear'), 
             yaxis = list(title = yaxis))
  })
  
})