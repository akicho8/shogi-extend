#!/usr/bin/env Rscript
library(jsonlite)
library(plotly)
library(htmlwidgets)

# データ取得
# api_url <- "http://localhost:3000/api/lab/swars/tactic-stat.json?json_type=general"
api_url <- "https://www.shogi-extend.com/api/lab/swars/tactic-stat.json?json_type=general"
df <- fromJSON(api_url)
df <- df[["infinite"]]

# 不要な行を除去
df <- df[!is.na(df$勝率), ]
df$種類 <- factor(df$種類, levels = c("戦法", "囲い", "手筋", "備考"))

# hover表示用のテキスト整形
df$hover <- paste(
  "<b>", df$名前, "</b>", "\n",
  "勝率:", sprintf("%.3f", df$勝率), "\n",
  "出現率:", sprintf("%.4f", df$出現率), "\n",
  "人気度:", sprintf("%.4f", df$人気度), "\n",
  "勝ち:", df$勝ち, "\n",
  "負け:", df$負け, "\n",
  "引分:", df$引分, "\n",
  "出現回数:", df$出現回数, "\n",
  "使用人数:", df$使用人数
)

# プロット初期化
p <- plot_ly()

for (kind in levels(df$種類)) {
  df_sub <- df[df$種類 == kind, ]
  p <- add_trace(
    p,
    data = df_sub,
    type = "scatter",
    mode = "markers+text",
    x = ~勝率,
    y = ~出現率,
    text = ~名前,
    color = ~種類,
    hovertext = ~hover,
    hoverinfo = "text",
    marker = list(size = 8, symbol = "circle", line = list(width = 2)),
    textfont = list(size = 14),
    textposition = "top center",
    name = paste0(kind, "（出現率）"),
    legendgroup = paste0(kind, "_freq"),
    showlegend = TRUE,
    yaxis = "y2"
  )
}

for (kind in levels(df$種類)) {
  df_sub <- df[df$種類 == kind, ]
  p <- add_trace(
    p,
    data = df_sub,
    type = "scatter",
    mode = "markers+text",
    x = ~勝率,
    y = ~人気度,
    text = ~名前,
    color = ~種類,
    hovertext = ~hover,
    hoverinfo = "text",
    marker = list(size = 8, symbol = "circle-open", line = list(width = 2)),
    textfont = list(size = 14),
    textposition = "top center",
    name = paste0(kind, "（人気度）"),
    legendgroup = paste0(kind, "_pop"),
    showlegend = TRUE,
    yaxis = "y1"
  )
}

# レイアウト設定
p <- layout(
  p,
  title = list(
    text = "<b>将棋ウォーズ：強さと人気・出現率で見る戦法分布</b>",
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
    title = list(text = "出現率", font = list(color = "#aaa", size = 16)),
    type = "log",
    tickfont = list(color = "#aaa"),
    gridcolor = "#444",
    zerolinecolor = "#444",
    showline = TRUE,
    linecolor = "#444"
  ),
  yaxis2 = list(
    title = list(text = "人気", font = list(color = "#aaa", size = 16)),
    type = "log",
    tickfont = list(color = "#aaa"),
    overlaying = "y",
    side = "right",
    showgrid = FALSE
  ),
  legend = list(
    font = list(color = "white")
  ),
  hoverlabel = list(bgcolor = "#333", font = list(color = "#aaa"), bordercolor = "#444"),
  plot_bgcolor = "#333",
  paper_bgcolor = "#333",
  margin = list(l = 80, r = 80, b = 80, t = 100),
  annotations = list(list(
    x = 1.0, y = 1.03,
    text = paste("最終更新:", format(Sys.time(), "%Y-%m-%d")),
    showarrow = FALSE, xref = "paper", yref = "paper",
    font = list(size = 12, color = "#aaa")
  ))
)

# 表示または保存
if (interactive()) {
  p
} else {
  full_path <- "~/src/shogi/shogi-extend/nuxt_side/static/lab/swars/tactic-stat.html"
  saveWidget(p, full_path, selfcontained = TRUE)
  system(sprintf("open -a 'Google Chrome' %s", full_path))
}
