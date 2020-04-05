library(data.table)
library(magrittr)
library(readr)
library(shiny)
library(shinythemes)
library(plotly)
library(shinyjs)
library(shinyWidgets)
source("helpers.R")


# For the inputs and texts across the whole app, there is a spanish and english version.
# When changing to a language the corresponding inputs are updated. 
# Suffix "en" stands for english, and "es" for spanish. 


# -------------- App header 
header_es <- "COVID-19 en España"
header_en <- "COVID-19 in Spain"

descr1_es <- "Créditos para los datos:"
descr1_en <- "Credits for the data:"
descr2_es <- "Esta app Shiny:"
descr2_en <- "This Shiny app:"

# -------------- Inputs
choose_data_label_es <- "Elige datos"
choose_data_label_en <- "Choose data"
choose_data_choices_es <- c("Casos totales", "Casos activos", "Altas", "Fallecidos", "Hospitalizados")
choose_data_choices_en <- c("Total cases", "Active cases", "Recovered", "Deaths", "Hospitalized", "Deaths")

total_or_ccaa_label_es <- "Total o por CCAA"
total_or_ccaa_label_en <- "Total or per CCAA"
total_or_ccaa_choices_es <- c("Total", "Por CCAA")
total_or_ccaa_choices_en <- c("Total", "Per CCAA")

relative_change_label_es <- "Muestra cambio en porcentaje"
relative_change_label_en <- "Show change in percent"

stat_label_es <- "Elige estadística"
stat_label_en <- "Choose statistics"
stat_choices_es <- c("Acumulado", "Nuevos por día")
stat_choices_en <- c("Cumulative", "New per day")

ccaa_label_es <- "Filtro CCAA"
ccaa_label_en <- "Filter CCAA"
