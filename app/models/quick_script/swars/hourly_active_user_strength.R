#!/usr/bin/env Rscript

library(jsonlite)
library(plotly)
library(htmlwidgets)
library(viridisLite)

# --- データの読み込み ----------------------------------------------

# url <- "http://localhost:3000/api/lab/swars/hourly_active_user.json?json_type=general"
url <- "https://www.shogi-extend.com/api/lab/swars/hourly_active_user.json?json_type=general"

data <- fromJSON(url)

weekday_order <- c("日", "月", "火", "水", "木", "金", "土", "祝日")

data$day_of_week <- factor(data$day_of_week, levels = weekday_order)

data$hour <- factor(data$hour, levels = as.character(0:23))

p_plotly <- plot_ly(
  data = data,
  x = ~day_of_week,
  y = ~hour,
  z = ~relative_strength,
  type = "heatmap",
  colors = colorRamp(viridisLite::turbo(100)),
  showscale = TRUE,
  hoverinfo = "skip",

  colorbar = list(
    title = "棋力",
    titleside = "top",
    # tickvals = NULL,
    # ticks = "",
    x = 1.01,
    y = 0.66,
    len = 0.33
  )
)

p_plotly <- layout(
  p_plotly,

  font = list(color = "white"),
  plot_bgcolor = "#333",
  paper_bgcolor = "#333",

  title = list(
    text = "<b>将棋ウォーズ：時間帯による棋力の傾向分析</b>",
    font = list(size = 28),
    x = 0.5
  ),

  margin = list(t = 80, l = 60, r = 80, b = 60),

  xaxis = list(
    title = "",
    showticklabels = TRUE,
    ticks = "",
    ticklen = 0,
    tickfont = list(size = 18)
  ),

  yaxis = list(
    title = "",
    showticklabels = TRUE,
    ticks = "",
    ticklen = 0,
    autorange = "reversed",
    tickfont = list(size = 18)
  )
)

if (interactive()) {
  p_plotly
} else {
  full_path <- "~/src/shogi-extend/nuxt_side/static/lab/swars/hourly-active-user-strength.html"
  saveWidget(p_plotly, full_path, selfcontained = TRUE)
  system(sprintf("open -a 'Google Chrome' %s", full_path))
}
