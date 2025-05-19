#!/usr/bin/env Rscript

library(jsonlite)
library(dplyr)
library(tidyr)
library(plotly)

url <- "http://localhost:3000/api/lab/swars/grade_segment.json?json_type=general"
json_data <- fromJSON(url)

data <- data.frame(
  棋力             = json_data$棋力,
  投了             = json_data$投了,
  詰まされ         = json_data$詰まされ,
  時間切れ         = json_data$時間切れ,
  切断逃亡         = json_data$切断逃亡,
  入玉             = json_data$入玉,
  連続王手の千日手 = json_data$連続王手の千日手,
  stringsAsFactors   = FALSE
)

grade_order_jp <- c(
  "十段", "九段", "八段", "七段", "六段", "五段", "四段", "三段", "二段", "初段",
  "1級", "2級", "3級", "4級", "5級", "6級", "7級", "8級", "9級", "10級"
)

data$棋力 <- factor(data$棋力, levels = grade_order_jp)

data_long <- pivot_longer(
  data,
  cols = c("投了", "詰まされ", "時間切れ", "切断逃亡", "入玉", "連続王手の千日手"),
  names_to = "metric",
  values_to = "value"
)

data_long$metric <- factor(
  data_long$metric,
  levels = c("投了", "詰まされ", "時間切れ", "切断逃亡", "入玉", "連続王手の千日手"),
  labels = c("投了", "詰まされ", "時間切れ", "切断逃亡", "入玉", "連続王手の千日手")
)

palette_muted <- c(
  "#AFCBE3",
  "#E2C6A7",
  "#B2D8C2",
  "#D8B2D1",
  "#CCCCCC",
  "#E3A6A6"
)

p <- plot_ly(
  data = data_long,
  x = ~value,
  y = ~棋力,
  color = ~metric,
  colors = palette_muted,
  type = 'bar',
  orientation = 'h',
  text = ~paste(棋力, "x", metric, ": ", scales::percent(value, accuracy = 0.1)),
  textposition = "none",
  hoverinfo = 'text+name',
  hoverlabel = list(namelength = 0)
)

p <- layout(
  p,
  font = list(color = "black"),
  plot_bgcolor = "#FFFFFF",
  paper_bgcolor = "#FFFFFF",
  barmode = 'stack',
  title = list(
    text = "<b>将棋ウォーズ：棋力別 負け方の実態と傾向</b>",
    font = list(size = 28, color = "black")
  ),
  yaxis = list(
    categoryorder = "array",
    categoryarray = grade_order_jp,
    tickvals = grade_order_jp,
    ticktext = grade_order_jp,
    tickfont = list(size = 14, color = "black"),
    ticklen = 0,
    tickwidth = 1,
    tickcolor = 'black',
    automargin = TRUE,
    zeroline = FALSE,
    showline = FALSE,
    title = "",
    showgrid = FALSE
  ),
  xaxis = list(
    tickformat = "%",
    zeroline = FALSE,
    automargin = TRUE,
    title = "",
    showticklabels = FALSE,
    showline = FALSE,
    showgrid = TRUE,
    gridcolor = "#DDDDDD",
    tickfont = list(color = "black")
  ),
  margin = list(
    l = 100, r = 10,
    t = 100, b = 100
  ),
  legend = list(
    title = list(text = ""),
    orientation = 'h',
    x = 0.48,
    y = -0.03,
    xanchor = "center",
    yanchor = "top",
    font = list(color = "black"),
    traceorder = "reversed"
  )
)

p <- config(p, displayModeBar = TRUE)

if (interactive()) {
  p
} else {
  full_path <- "~/src/shogi-extend/nuxt_side/static/lab/swars/lose-pattern.html"
  htmlwidgets::saveWidget(p, full_path, selfcontained = TRUE)
  system(sprintf("open -a 'Google Chrome' %s", full_path))
}
