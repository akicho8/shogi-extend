#!/usr/bin/env Rscript

library(jsonlite)
library(dplyr)
library(plotly)

# url <- "http://localhost:3000/api/lab/swars/grade-segment.json?json_type=general"
url <- "https://www.shogi-extend.com/api/lab/swars/grade_segment.json?json_type=general"
json_data <- fromJSON(url)

data <- data.frame(
  棋力 = json_data$棋力,
  手数 = json_data$手数,
  stringsAsFactors = FALSE
)

# 段級位の順序（強い順）
grade_order_jp <- c(
  "十段", "九段", "八段", "七段", "六段", "五段", "四段", "三段", "二段", "初段",
  "1級", "2級", "3級", "4級", "5級", "6級", "7級", "8級", "9級", "10級"
  # "11級", "12級", "13級", "14級", "15級", "16級", "17級", "18級", "19級", "20級",
  # "21級", "22級", "23級", "24級", "25級", "26級", "27級", "28級", "29級", "30級"
)

data$棋力 <- factor(data$棋力, levels = grade_order_jp)

min_val <- floor(min(data$手数)   / 10) * 10 - 1
max_val <- ceiling(max(data$手数) / 10) * 10 + 1

p <- plot_ly(
  data = data,
  x = ~手数,
  y = ~棋力,
  type = "bar",
  orientation = "h",
  text = ~paste(round(手数, 1)),
  textposition = "none",
  hoverinfo = "text",
  # marker = list(color = data$手数, colorscale = "Viridis")
  # marker = list(color = "#357ABD")
  # marker = list(color = "#FF69B4")  # 緑系（明るめ）に変更
  marker = list(color = "#ADD8E6")

)

# レイアウト調整（背景やフォント、軸など）
p <- layout(
  p,
  title = list(
    text = "<b>将棋ウォーズ：棋力別の平均手数</b>",
    font = list(size = 24, color = "black")
  ),
  font = list(color = "black"),
  yaxis = list(
    title = "",
    categoryorder = "array",
    categoryarray = grade_order_jp,
    # autorange = "reversed",
    tickfont = list(color = "black")
  ),
  xaxis = list(
    title = "平均手数 (スプリントを除く)",
    tickfont = list(color = "black"),
    showgrid = FALSE,
    gridcolor = "#e0e0e0",
    range = c(min_val, max_val)
  ),
  margin = list(l = 100, r = 10, t = 100, b = 100),
  hoverlabel = list(
    bgcolor = "white",
    font = list(color = "black"),
    bordercolor = "white"
  )
)

# グラフ表示
p <- config(p, displayModeBar = TRUE)

if (interactive()) {
  p
} else {
  full_path <- "~/src/shogi-extend/nuxt_side/static/lab/swars/turn-average.html"
  htmlwidgets::saveWidget(p, full_path, selfcontained = TRUE)
  system(sprintf("open -a 'Google Chrome' %s", full_path))
}
