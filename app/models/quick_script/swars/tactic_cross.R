#!/usr/bin/env Rscript

library(jsonlite)
library(plotly)
library(htmlwidgets)

# 定数定義 ------------------------------------------------------------

# API エンドポイント
# api_url <- "http://localhost:3000/api/lab/swars/tactic-cross.json?json_type=general"
api_url <- "https://www.shogi-extend.com/api/lab/swars/tactic-cross.json?json_type=general"

# visible_names <- c("居飛車", "振り飛車") # 初期表示する戦法
visible_names_s <- c("居飛車", "振り飛車") # 出現率
# visible_names_n <- c("四間飛車", "三間飛車", "中飛車") # 人気度
visible_names_n <- c("居飛車", "振り飛車") # 人気度

rank_order <- c(
  "10級", "9級", "8級", "7級", "6級", "5級", "4級", "3級", "2級", "1級",
  "初段", "二段", "三段", "四段", "五段", "六段", "七段", "八段", "九段"
)

# 凡例（戦法の一覧）を取得 ------------------------------------------------------------

message("凡例リスト読み込み: 開始")
target_names_json <- system("cd ~/src/shogi/shogi-extend && rails runner 'QuickScript::Swars::TacticCrossScript::LegendGenerator.generate'", intern = TRUE)
target_names <- fromJSON(paste(target_names_json, collapse = ""))
message("凡例リスト読み込み: 完了")
# target_names <- c("居飛車", "振り飛車") # 初期表示する戦法

# データ取得と整形 ------------------------------------------------------------

raw_data <- fromJSON(api_url)
data <- subset(raw_data, 棋力 %in% rank_order)
data$棋力 <- factor(data$棋力, levels = rank_order)

filtered_data <- subset(data, 名前 %in% target_names)
filtered_data <- filtered_data[order(filtered_data$名前, filtered_data$棋力), ]

# グラフ生成 ------------------------------------------------------------

fig <- plot_ly()

for (name in target_names) {
  df <- subset(filtered_data, 名前 == name)

  if (nrow(df) == 0) {
    message(sprintf("データなしのためスキップ: %s", name))
    next
  }

  df$hover <- paste(
    df$名前, df$棋力, "<br>",
    "勝率:", sprintf("%.3f", df$勝率), "<br>",
    "出現率:", sprintf("%.4f", df$出現率), "<br>",
    "人気度:", sprintf("%.4f", df$人気度), "<br>",
    "勝ち:", df$勝ち, "<br>",
    "負け:", df$負け, "<br>",
    "引分:", df$引分, "<br>",
    "出現回数:", df$出現回数, "<br>",
    "使用人数:", df$使用人数
  )

  ## ラベル名を分ける
  df$label_appearance <- ifelse(df$棋力 == "10級", paste(name, "(出現率)"), "")
  df$label_popularity <- ifelse(df$棋力 == "10級", paste(name, "(人気度)"), "")

  fig <- add_trace(
    fig,
    data = df,
    x = ~棋力,
    y = ~出現率,
    text = ~label_appearance,
    type = "scatter",
    mode = "lines+markers+text",
    name = paste(name, "(出現率)"),
    textposition = "top center",
    textfont = list(color = "white", size = 18),
    hovertext = ~hover,
    hoverinfo = "text",
    visible = if (name %in% visible_names_s) TRUE else "legendonly",
    marker = list(size = 12, symbol = "circle", opacity = 0.8),
    line = list(width = 4, shape = "spline"),
    yaxis = "y"
  )

  fig <- add_trace(
    fig,
    data = df,
    x = ~棋力,
    y = ~人気度,
    type = "scatter",
    mode = "lines+markers+text",
    name = paste(name, "(人気度)"),
    text = ~label_popularity,
    textposition = "top center",
    textfont = list(color = "white", size = 18),
    hovertext = ~hover,
    hoverinfo = "text",
    visible = if (name %in% visible_names_n) TRUE else "legendonly",
    marker = list(size = 12, symbol = "circle", opacity = 0.8),
    line = list(width = 4, dash = "dot", shape = "spline"),
    yaxis = "y2"
  )
}

# レイアウト設定 ------------------------------------------------------------

# データ全体から、人気度と出現率の最大・最小値を取得
# y_min <- min(c(df$人気度, df$出現率), na.rm = TRUE)
# y_max <- max(c(df$人気度, df$出現率), na.rm = TRUE)
# y_min <- 0.0
# y_max <- 1.0

fig <- layout(
  fig,
  title = list(
    text = "<b>将棋ウォーズ：棋力別に見る戦法人気度と出現率の変化</b>",
    font = list(size = 28)
  ),
  xaxis = list(
    title = "",
    titlefont = list(size = 20, color = "#aaa"),
    showgrid = TRUE,
    gridcolor = "#444",
    tickfont = list(color = "#aaa", size = 18)
  ),
  yaxis = list(
    title = "出現率",
    titlefont = list(size = 20, color = "#aaa"),
    tickfont = list(color = "#aaa", size = 18),
    showgrid = TRUE,
    gridcolor = "#444"
  ),
  yaxis2 = list(
    title = "人気度",
    # range = c(y_min, y_max),
    titlefont = list(size = 20, color = "#aaa"),
    tickfont = list(color = "#aaa", size = 18),
    overlaying = "y",
    side = "right",
    showgrid = FALSE
  ),
  legend = list(
    x = 1.05,
    y = 1,
    bgcolor = "#333",
    font = list(color = "#ffffff", size = 16)
  ),
  hoverlabel = list(
    bgcolor = "#333",
    font = list(color = "#aaa", size = 20),
    bordercolor = "#aaa"
  ),
  font = list(color = "white"),
  plot_bgcolor = "#333",
  paper_bgcolor = "#333",
  margin = list(l = 100, r = 350, t = 100, b = 70),
  annotations = list(
    list(
      text = "🦉ﾀﾞﾌﾞﾙｸﾘｯｸ<b>2回</b>で<br>　切り替えれるぞ",
      xref = "paper",
      yref = "paper",
      x = 1.05,
      y = 1.05,
      xanchor = "left",
      showarrow = FALSE,
      font = list(size = 12, color = "#aaa"),
      align = "left",
      opacity = 0.95
    ),
    list(
      x = 1.0,
      y = 1.03,
      text = paste("最終更新:", format(Sys.time(), "%Y-%m-%d")),
      showarrow = FALSE,
      xref = "paper",
      yref = "paper",
      font = list(size = 12, color = "#aaa")
    )
  )
)

# 出力保存 ------------------------------------------------------------

if (interactive()) {
  fig
} else {
  output_file <- "~/src/shogi/shogi-extend/nuxt_side/static/lab/swars/tactic-cross.html"
  saveWidget(fig, output_file, selfcontained = TRUE)
  system(sprintf("open -a 'Google Chrome' %s", output_file))
}
