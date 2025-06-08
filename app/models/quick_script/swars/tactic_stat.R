#!/usr/bin/env Rscript
library(jsonlite)
library(plotly)
library(htmlwidgets)

# データ取得
# api_url <- "https://www.shogi-extend.com/api/lab/swars/tactic-stat.json?json_type=general"
api_url <- "http://localhost:3000/api/lab/swars/tactic-stat.json?json_type=general"
df <- fromJSON(api_url)
df <- df[["infinite"]]

# フィルタリング
df <- df[!is.na(df$勝率), ]
df$種類 <- factor(df$種類, levels = c("戦法", "囲い", "手筋", "備考"))

# プロット作成
p <- plot_ly(
  df,
  type = "scatter",
  mode = "markers+text",   # ドットとテキスト両方表示
  x = ~勝率,
  y = ~人気度,
  text = ~名前,
  color = ~種類,
  marker = list(size = 8),    # ドットサイズ
  textfont = list(size = 14),
  textposition = "top center",
  hovertemplate = paste(
    "%{text}<br>",
    "勝率: %{x:.5f}<br>",
    "人気度: %{y:.5f}",
    "<extra></extra>"
  )
)

# レイアウト調整
p <- layout(
  p,
  title = list(
    text = "<b>将棋ウォーズ：強さと人気で見る戦法分布</b>",
    font = list(color = "white", size = 24)
  ),
  xaxis = list(
    title = list(text = "強さ", font = list(color = "#aaa", size = 16)),
    tickfont = list(color = "#aaa"),
    gridcolor = "#444",
    zerolinecolor = "#444",
    showline = TRUE,
    linecolor = "#444"
  ),
  yaxis = list(
    title = list(text = "人気", font = list(color = "#aaa", size = 16)),
    type = "log",
    tickfont = list(color = "#aaa"),
    gridcolor = "#444",
    zerolinecolor = "#444",
    showline = TRUE,
    linecolor = "#444"
  ),
  legend = list(
    font = list(color = "white")
  ),
  hoverlabel = list(bgcolor = "#333", font = list(color = "#aaa"), bordercolor = "#444"),
  plot_bgcolor = "#333",
  paper_bgcolor = "#333",
  margin = list(l=80, r=80, b=80, t=100),
  annotations = list(list(x = 1.0, y = 1.03, text = paste("最終更新:", format(Sys.time(), "%Y-%m-%d")), showarrow = FALSE, xref = "paper", yref = "paper", font = list(size = 12, color = "#aaa")))
)

# 保存と表示
if (interactive()) {
  p
} else {
  full_path <- "~/src/shogi-extend/nuxt_side/static/lab/swars/tactic-stat.html"
  saveWidget(p, full_path, selfcontained = TRUE)
  system(sprintf("open -a 'Google Chrome' %s", full_path))
}
