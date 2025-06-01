#!/usr/bin/env Rscript
library(jsonlite)
library(plotly)
library(htmlwidgets)

# データ読み込み
df <- fromJSON("https://www.shogi-extend.com/api/lab/swars/tactic-list.json?json_type=general")

# フィルタリング
df <- df[!is.na(df$勝率), ]
df <- df[df$種類 == "戦法" | df$種類 == "囲い", ]
df <- df[df$名前 != "力戦" & df$名前 != "居玉", ]
df <- df[0.3 <= df$勝率 & df$勝率 <= 0.7, ]

# 色分け用ベクトル作成

df$color <- ifelse(
  df$種類 == "戦法",
  hcl(h = 0, c = 0, l = 80),  # 明るめのグレー（ほぼ白に近い）
  hcl(h = 0, c = 0, l = 50)   # 中間のグレー
)

# plot_ly の設定
p <- plot_ly(
  data = df,
  x = ~相対頻度,
  y = ~勝率 * 100,
  type = 'scatter',
  mode = 'text',
  text = ~名前,
  hoverinfo = 'none',
  textfont = ~list(color = df$color, size = 18)
)

# layout を適用
p <- layout(
  p,
  title = list(
    text = "<b>将棋ウォーズ：人気と勝率で見る戦法分布</b>",
    font = list(color = "white", size = 24)
  ),
  xaxis = list(
    title = list(text = "人気", font = list(color = "white", size = 20)),
    type = "log",
    tickfont = list(color = "white"),
    gridcolor = "#444",
    zerolinecolor = "#444",
    showline = TRUE,
    linecolor = "#444"
  ),
  yaxis = list(
    title = list(text = "勝率（％）", font = list(color = "white", size = 20)),
    tickfont = list(color = "white"),
    gridcolor = "#444",
    zerolinecolor = "#444",
    showline = TRUE,
    linecolor = "#444",
    range = c(30, 70)
  ),
  plot_bgcolor = "#333",
  paper_bgcolor = "#333",
  margin = list(l=80, r=80, b=80, t=100)
)

# 非インタラクティブ環境ならHTML保存してChromeで開く
if (interactive()) {
  p
} else {
  full_path <- "~/src/shogi-extend/nuxt_side/static/lab/swars/tactic-stat.html"
  saveWidget(p, full_path, selfcontained = TRUE)
  system(sprintf("open -a 'Google Chrome' %s", full_path))
}
