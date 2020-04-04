library(data.table)

join_data <- function(data_list) {
  tmp_a <- data.table(data_list$altas)
  tmp_c <- data.table(data_list$casos)
  tmp_f <- data.table(data_list$falle)
  tmp_h <- data.table(data_list$hospi)
  tmp_a[, total_altas := total] 
  tmp_c[, total_casos := total]
  tmp_f[, total_falle := total]
  tmp_h[, total_hospi := total]
  tmp1 <- merge(tmp_c, tmp_a, by = c("fecha", "CCAA"), all.x=TRUE)
  tmp2 <- merge(tmp1, tmp_f, by = c("fecha", "CCAA"), all.x=TRUE)
  tmp3 <- merge(tmp2, tmp_h, by = c("fecha", "CCAA"), all.x=TRUE)
  cols <- c("fecha", "CCAA", "total_altas", "total_falle", "total_casos", "total_hospi")
  tmp3 <- tmp3[, ..cols]
  tmp3[is.na(total_falle), total_falle := 0]
  tmp3[is.na(total_altas), total_altas := 0]
  tmp3[is.na(total_hospi), total_hospi := 0]
  tmp3[, activos := total_casos - (total_falle + total_altas)]
  return (tmp3)
}

# data_list <- list(
#   "altas" = read_csv(url("https://raw.githubusercontent.com/datadista/datasets/master/COVID%2019/ccaa_covid19_altas_long.csv")),
#   "casos" = read_csv(url("https://raw.githubusercontent.com/datadista/datasets/master/COVID%2019/ccaa_covid19_casos_long.csv")),
#   "falle" = read_csv(url("https://raw.githubusercontent.com/datadista/datasets/master/COVID%2019/ccaa_covid19_fallecidos_long.csv")),
#   "hospi" = read_csv(url("https://raw.githubusercontent.com/datadista/datasets/master/COVID%2019/ccaa_covid19_hospitalizados_long.csv"))
# )
# 
# my_dat <- join_data(data_list)
# View(my_dat)

