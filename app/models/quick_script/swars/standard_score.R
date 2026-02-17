#!/usr/bin/env Rscript

library(jsonlite)
library(plotly)
library(htmlwidgets)

# JSONの取得
# api_url <- "http://localhost:3000/api/lab/swars/standard_score.json?json_type=general"
api_url <- "https://www.shogi-extend.com/api/lab/swars/standard_score.json?json_type=general"
json_data <- fromJSON(api_url)

# データフレーム作成
df <- as.data.frame(json_data)

# 棋力の並び順
rank_order <- c(
  paste0(30:11, "級"),
  "10級", "9級", "8級", "7級", "6級", "5級", "4級", "3級", "2級", "1級",
  "初段", "二段", "三段", "四段", "五段", "六段", "七段", "八段", "九段", "十段"
)
df$棋力 <- factor(df$棋力, levels = rank_order)

# 割合を計算
total <- sum(df$人数)
df$割合 <- df$人数 / total

# ホバーテキスト作成
hover_text <- sprintf(
  "%s: %d人 (%.1f%%)",
  df$棋力,
  df$人数,
  df$割合 * 100
)

# プロット作成
p <- plot_ly(
  data = df,
  x = ~棋力,
  y = ~人数,
  type = "scatter",
  mode = "lines+markers+text",
  line = list(width = 4, shape = "spline"),
  marker = list(size = 12, opacity = 0.8),
  # text = ~テキスト,
  textposition = "top center",
  hovertext = hover_text,
  hoverinfo = "text",
  showlegend = FALSE
)

# レイアウト設定
p <- layout(
  p,
  title = list(
    text = "<b>将棋ウォーズ：利用者数分布（全体）</b>",
    font = list(size = 24, color = "white")
  ),
  xaxis = list(
    categoryorder = "array",
    categoryarray = rank_order,
    tickfont = list(color = "#aaa"),
    showgrid = TRUE,
    gridcolor = "#444",
    zeroline = FALSE,
    title = ""
  ),
  yaxis = list(
    tickfont = list(color = "#aaa"),
    showgrid = TRUE,
    gridcolor = "#444",
    zeroline = FALSE,
    title = ""
  ),
  plot_bgcolor = "#333",
  paper_bgcolor = "#333",
  font = list(color = "white"),
  hoverlabel = list(bgcolor = "#333", font = list(color = "#aaa", size = 18), bordercolor = "#aaa"),
  margin = list(l = 70, r = 70, t = 100, b = 70),
  annotations = list(list(x = 1.0, y = 1.03, text = paste("最終更新:", format(Sys.time(), "%Y-%m-%d")), showarrow = FALSE, xref = "paper", yref = "paper", font = list(size = 12, color = "#aaa")))
)

p <- config(p, displayModeBar = TRUE)

# 表示 or 保存
if (interactive()) {
  p
} else {
  out_path <- "~/src/shogi/shogi-extend/nuxt_side/static/lab/swars/standard-score.html"
  saveWidget(p, out_path, selfcontained = TRUE)
  system(sprintf("open -a 'Google Chrome' %s", out_path))
}
