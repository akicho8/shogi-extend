#!/usr/bin/env Rscript
library(jsonlite)
library(plotly)
library(htmlwidgets)

# データ取得
api_url <- "http://localhost:3000/api/lab/general/pre-professional-league.json?json_type=general"
# api_url <- "https://www.shogi-extend.com/api/lab/general/pre-professional-league.json?json_type=general"
all = fromJSON(api_url)
df <- all$成績行列

# 「シーズン名」は文字列として保持
df$シーズン名 <- as.character(df$シーズン名)

# プロット初期化
p <- plot_ly()

# 全棋士の名前を取得
names_list <- unique(df$名前)

# 各棋士ごとにトレース追加
for (i in seq_along(names_list)) {
  name_i <- names_list[i]
  sub_df <- subset(df, 名前 == name_i)

  # シーズンインデックス順にソート
  sub_df <- sub_df[order(sub_df$シーズンインデックス), ]

  # 最後のシーズン名だけ名前を表示
  sub_df$テキスト <- ifelse(sub_df$シーズンインデックス == max(sub_df$シーズンインデックス), name_i, "")

  # ホバーテキスト
  sub_df$hover <- paste0(
    "<b>", sub_df$名前, "</b><br>",
    sub_df$勝数, "勝",
    ifelse(sub_df$結果 == "維持", "", paste0(" ", sub_df$結果))
  )

  # 最初の4人だけ表示、その他は非表示
  visible_status <- if (i <= 4) TRUE else "legendonly"

  # マーカーサイズ
  sub_df$marker_size <- ifelse(
    sub_df$結果 == "昇段", 18,
    ifelse(sub_df$結果 == "次点", 18, 10)
  )

  # マーカー形状
  sub_df$marker_symbol <- ifelse(
    sub_df$結果 == "昇段", "star",
    ifelse(sub_df$結果 == "次点", "circle",
      ifelse(sub_df$結果 == "降段", "triangle-down", "circle")
    )
  )

  # 前の点との差分
  sub_df$勝数_diff <- c(NA, diff(sub_df$勝数))
  sub_df$text_position <- ifelse(sub_df$勝数_diff < 0, "bottom center", "top center")
  sub_df$text_position[1] <- "top center"

  p <- add_trace(
    p,
    data = sub_df,
    x = ~シーズンインデックス,   # 数値インデックスで描画
    y = ~勝数,
    type = "scatter",
    mode = "lines+markers+text",
    name = name_i,
    line = list(width = 3, shape = "spline"),
    marker = list(size = ~marker_size, opacity = 0.8, symbol = ~marker_symbol),
    text = ~テキスト,
    textposition = ~text_position,
    hovertext = ~hover,
    hoverinfo = "text",
    visible = visible_status
  )
}

# レイアウト設定（ダークテーマ）
p <- layout(
  p,
  title = list(
    text = "<b>奨励会三段リーグ成績推移</b>",
    font = list(size = 24, color = "white")
  ),
  xaxis = list(
    tickvals = unique(df$シーズンインデックス),
    ticktext = unique(df$シーズン名),
    tickfont = list(color = "#aaa"),
    showgrid = TRUE,
    gridcolor = "#444",
    zeroline = FALSE,
    title = "シーズン"
  ),
  yaxis = list(
    tickfont = list(color = "#aaa"),
    showgrid = TRUE,
    gridcolor = "#444",
    zeroline = FALSE,
    title = "勝数"
  ),
  plot_bgcolor = "#333",
  paper_bgcolor = "#333",
  font = list(color = "white"),
  hoverlabel = list(bgcolor = "#333", font = list(color = "#aaa", size = 16), bordercolor = "#aaa"),
  margin = list(l = 70, r = 70, t = 100, b = 70),
  annotations = list(
    list(x = 1.0, y = 1.03,
         text = paste("最終更新:", format(Sys.time(), "%Y-%m-%d")),
         showarrow = FALSE, xref = "paper", yref = "paper",
         font = list(size = 12, color = "#aaa"))
  )
)

p <- config(p, displayModeBar = TRUE)

# 表示 or 保存
if (interactive()) {
  p
} else {
  out_path <- "~/src/shogi-extend/nuxt_side/static/lab/general/pre-professional-league.html"
  saveWidget(p, out_path, selfcontained = TRUE)
  system(sprintf("open -a 'Google Chrome' %s", out_path))
}
