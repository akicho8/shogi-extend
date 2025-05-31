#!/usr/bin/env Rscript

library(jsonlite)
library(dplyr)
library(tidyr)
library(plotly)

# URL からデータ取得
url <- "https://www.shogi-extend.com/api/lab/swars/grade_segment.json?json_type=general"
json_data <- fromJSON(url)

# データフレーム化
data <- data.frame(
  棋力             = json_data$棋力,
  投了             = json_data$投了,
  詰まされ         = json_data$詰まされ,
  時間切れ         = json_data$時間切れ,
  切断逃亡         = json_data$切断逃亡,
  入玉             = json_data$入玉,
  連続王手の千日手 = json_data$連続王手の千日手,
  stringsAsFactors = FALSE
)

# 棋力の表示順を設定（下から上にしないよう逆順に）
grade_order_jp <- rev(c(
  "十段", "九段", "八段", "七段", "六段", "五段", "四段", "三段", "二段", "初段",
  "1級", "2級", "3級", "4級", "5級", "6級", "7級", "8級", "9級", "10級"
))
data$棋力 <- factor(data$棋力, levels = grade_order_jp)

# ロング形式に変換
data_long <- pivot_longer(
  data,
  cols = c("投了", "詰まされ", "時間切れ", "切断逃亡", "入玉", "連続王手の千日手"),
  names_to = "metric",
  values_to = "value"
)

# metric の順序を固定
metric_levels <- c("投了", "詰まされ", "時間切れ", "切断逃亡", "入玉", "連続王手の千日手")
data_long$metric <- factor(data_long$metric, levels = metric_levels)

# 折れ線グラフ（スプライン）にして、色は自動
p <- plot_ly(
  data = data_long,
  x = ~棋力,
  y = ~value,
  color = ~metric,
  type = 'scatter',
  mode = 'lines+markers',
  text = ~paste(棋力, metric, ":", scales::percent(value, accuracy = 0.1)),
  hoverinfo = 'text+name',
  hoverlabel = list(namelength = 0),
  line = list(width = 2, shape = "spline"),  # ← スプライン
  marker = list(size = 12, opacity = 0.8)
)

# レイアウト設定
p <- layout(
  p,
  font = list(color = "white"),
  plot_bgcolor = "#333",
  paper_bgcolor = "#333",
  title = list(
    text = "<b>将棋ウォーズ：棋力別 負け方の実態と傾向</b>",
    font = list(size = 28)
  ),
  xaxis = list(
    title = "",
    categoryorder = "array",
    categoryarray = grade_order_jp,
    tickfont = list(size = 14, color = "white"),
    automargin = TRUE,
    zeroline = FALSE,
    showline = FALSE,
    showgrid = TRUE,
    gridcolor = "#444"
  ),
  yaxis = list(
    title = "",
    tickformat = ".0%",  # ← 50% の形式に
    zeroline = FALSE,
    automargin = TRUE,
    showticklabels = TRUE,
    showline = FALSE,
    showgrid = TRUE,
    gridcolor = "#444",
    tickfont = list(color = "white")
  ),
  legend = list(
    title = list(text = ""),
    orientation = 'v',
    x = 1.02,
    y = 1,
    xanchor = "left",
    yanchor = "top",
    font = list(color = "white")
  ),
  hoverlabel = list(
    bgcolor = "white",
    font = list(color = "#222"),
    bordercolor = "white"
  ),
  margin = list(l = 60, r = 160, t = 100, b = 100)
)

# 表示 or 保存
p <- config(p, displayModeBar = TRUE)

if (interactive()) {
  p
} else {
  full_path <- "~/src/shogi-extend/nuxt_side/static/lab/swars/lose-pattern.html"
  htmlwidgets::saveWidget(p, full_path, selfcontained = TRUE)
  system(sprintf("open -a 'Google Chrome' %s", full_path))
}
