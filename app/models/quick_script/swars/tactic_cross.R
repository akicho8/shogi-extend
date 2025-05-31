#!/usr/bin/env Rscript

library(jsonlite)
library(plotly)
library(htmlwidgets)

# 定数定義 ------------------------------------------------------------

# API エンドポイント（本番とローカルどちらもあり、後者が優先される）
# api_url <- "http://localhost:3000/api/lab/swars/tactic-cross.json?json_type=general"
api_url <- "https://www.shogi-extend.com/api/lab/swars/tactic-cross.json?json_type=general"

visible_names <- c("居飛車", "振り飛車", "急戦", "持久戦")

# 棋力の表示順
rank_order <- c(
  "10級", "9級", "8級", "7級", "6級", "5級", "4級", "3級", "2級", "1級",
  "初段", "二段", "三段", "四段", "五段", "六段", "七段", "八段", "九段"
)

# 凡例（戦法の一覧）を取得 ------------------------------------------------------------

message("凡例リスト読み込み: 開始")
target_names_json <- system(
  "cd ~/src/shogi-extend && rails runner 'QuickScript::Swars::TacticCrossScript::LegendGenerator.generate'",
  intern = TRUE
)
target_names <- fromJSON(paste(target_names_json, collapse = ""))
message("凡例リスト読み込み: 完了")
# target_names <- visible_names

# データ取得と整形 ------------------------------------------------------------

raw_data <- fromJSON(api_url)
data <- subset(raw_data, 棋力 %in% rank_order)
data$棋力 <- factor(data$棋力, levels = rank_order)

filtered_data <- subset(data, 名前 %in% target_names)
filtered_data <- filtered_data[order(filtered_data$名前, filtered_data$棋力), ]

# グラフ生成 ------------------------------------------------------------

fig <- plot_ly()

for (name in target_names) {
  tactic_data <- subset(filtered_data, 名前 == name)

  if (nrow(tactic_data) == 0) {
    message(sprintf("データなしのためスキップ: %s", name))
    next
  }

  # ホバーに表示する詳細情報
  tactic_data$hover <- paste(
    tactic_data$名前, tactic_data$棋力, "<br>",
    "勝率:", sprintf("%.3f", tactic_data$勝率), "<br>",
    "頻度:", sprintf("%.4f", tactic_data$頻度), "<br>",
    "勝ち:", tactic_data$勝ち, "<br>",
    "負け:", tactic_data$負け, "<br>",
    "引分:", tactic_data$引分, "<br>",
    "出現:", tactic_data$出現数
  )

  # ラベルは10級だけに表示
  tactic_data$label <- ifelse(tactic_data$棋力 == "10級", tactic_data$名前, "")

  # ラベル色：10級は白、他は勝率に応じた色
  tactic_data$label_color <- ifelse(
    tactic_data$棋力 == "10級",
    "white",
    ifelse(tactic_data$勝率 >= 0.5,
           hcl(h = 20, c = 85, l = 50),   # オレンジ
           hcl(h = 207, c = 85, l = 50))  # 青
  )

  # ラベル位置
  tactic_data$text_position <- "top center"

  # シンボル（勝率によって塗りあり・なし）
  tactic_data$symbol <- ifelse(tactic_data$勝率 >= 0.5, "circle", "circle-open")

  fig <- add_trace(
    fig,
    data = tactic_data,
    x = ~棋力,
    y = ~頻度,
    type = "scatter",
    mode = "lines+markers+text",
    name = name,
    text = ~label,
    textposition = ~text_position,
    textfont = list(color = ~label_color, size = 16),
    hovertext = ~hover,
    hoverinfo = "text",
    visible = if (name %in% visible_names) TRUE else "legendonly",
    marker = list(size = 12, symbol = ~symbol, opacity = 0.8),
    line = list(width = 2, shape = "spline")
  )
}

# レイアウト設定 ------------------------------------------------------------

fig <- layout(
  fig,
  title = list(
    text = "<b>将棋ウォーズ：棋力で変わる戦法の使用率推移</b>",
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
    title = "",
    # type = "log",
    titlefont = list(size = 20, color = "#aaa"),
    showgrid = TRUE,
    gridcolor = "#444",
    tickfont = list(color = "#aaa", size = 18)
  ),
  legend = list(
    x = 1.02,
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
  margin = list(l = 100, r = 200, t = 100, b = 100),
  annotations = list(
    list(
      text = "🦉右の凡例を<b>2回</b>ダブルクリックすると切り替えれるぞ",
      xref = "paper",
      yref = "paper",
      x = 0.5,
      y = -0.06,  # y=0より小さいと下に表示される
      showarrow = FALSE,
      font = list(size = 12, color = "#aaa"),
      align = "left"
    )
  )
)

# 出力保存 ------------------------------------------------------------

if (interactive()) {
  fig
} else {
  output_file <- "~/src/shogi-extend/nuxt_side/static/lab/swars/tactic-cross.html"
  saveWidget(fig, output_file, selfcontained = TRUE)
  system(sprintf("open -a 'Google Chrome' %s", output_file))
}
