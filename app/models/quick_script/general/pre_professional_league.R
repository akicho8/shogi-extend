#!/usr/bin/env Rscript
library(jsonlite)
library(plotly)
library(htmlwidgets)

# データ読み込み（直接文字列から）
json_data <- '[{"名前":"斎藤慎太郎","昇段時の年齢":18,"昇段時の期":50,"昇段時の勝数":15,"在籍期間":8,"年齢から":14,"年齢まで":18,"次点回数":1,"最大勝数":15,"成績":{"43":11,"44":12}}]'
df <- fromJSON(json_data)

# 「成績」を安全にデータフレーム化
成績_list <- df$成績[[1]]

成績_df <- if (!is.null(成績_list) && length(成績_list) > 0) {
  data.frame(
    期 = as.integer(names(成績_list)),
    勝ち数 = as.integer(unlist(成績_list)),
    stringsAsFactors = FALSE
  )
} else {
  data.frame(
    期 = integer(0),
    勝ち数 = integer(0),
    stringsAsFactors = FALSE
  )
}

# hover 用に名前を追加
成績_df$hover <- if (nrow(成績_df) > 0) {
  paste0(
    "<b>", df$名前[1], "</b><br>",
    "期: ", 成績_df$期, "<br>",
    "勝ち数: ", 成績_df$勝ち数
  )
} else {
  paste0("<b>", df$名前[1], "</b><br>勝ち数データなし")
}

# プロット
p <- plot_ly(
  data = 成績_df,
  x = ~期,
  y = ~勝ち数,
  type = "scatter",
  mode = if (nrow(成績_df) > 0) "lines+markers+text" else "text",
  text = if (nrow(成績_df) > 0) ~勝ち数 else "データなし",
  textposition = "top center",
  hovertext = ~hover,
  hoverinfo = "text",
  marker = list(size = 8, line = list(width = 2)),
  line = list(width = 2),
  name = df$名前[1]
)

# レイアウト
p <- layout(
  p,
  title = list(
    text = paste0("<b>", df$名前[1], "：期ごとの勝ち数</b>"),
    font = list(color = "white", size = 20)
  ),
  xaxis = list(
    title = list(text = "期", font = list(color = "#aaa", size = 16)),
    tickfont = list(color = "#aaa"),
    gridcolor = "#444",
    zerolinecolor = "#444",
    showline = TRUE,
    linecolor = "#444"
  ),
  yaxis = list(
    title = list(text = "勝ち数", font = list(color = "#aaa", size = 16)),
    tickfont = list(color = "#aaa"),
    gridcolor = "#444",
    zerolinecolor = "#444",
    showline = TRUE,
    linecolor = "#444"
  ),
  plot_bgcolor = "#333",
  paper_bgcolor = "#333",
  hoverlabel = list(bgcolor = "#333", font = list(color = "#aaa"), bordercolor = "#444"),
  margin = list(l = 80, r = 80, b = 80, t = 100)
)

# 表示または保存
if (interactive()) {
  p
} else {
  full_path <- "~/src/shogi-extend/nuxt_side/static/lab/general/pre-professional-league.html"
  saveWidget(p, full_path, selfcontained = TRUE)
  system(sprintf("open -a 'Google Chrome' %s", full_path))
}
