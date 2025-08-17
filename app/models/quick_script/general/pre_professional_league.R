#!/usr/bin/env Rscript
library(jsonlite)
library(plotly)
library(htmlwidgets)

# データ取得
# api_url <- "http://localhost:3000/api/lab/general/pre-professional-league.json?json_type=general"
api_url <- "https://www.shogi-extend.com/api/lab/general/pre-professional-league.json?json_type=general"
df <- fromJSON(api_url)

# 期次順に並べる
期次_order <- sort(unique(df$期次))
df$期次 <- factor(df$期次, levels = 期次_order)

# プロット初期化
p <- plot_ly()

# 全棋士の名前を取得
names_list <- unique(df$名前)

# 各棋士ごとにトレース追加
for (i in seq_along(names_list)) {
  name_i <- names_list[i]
  sub_df <- subset(df, 名前 == name_i)

  # 期次を因子のまま使う場合でも、開始点判定用に数値に変換
  sub_df$期次_num <- as.numeric(as.character(sub_df$期次))

  # その棋士の最後の期次だけテキスト表示
  sub_df$テキスト <- ifelse(sub_df$期次_num == max(sub_df$期次_num), name_i, "")

  # ホバーテキスト
  sub_df$hover <- paste0(
    "<b>", sub_df$名前, "</b><br>",
    sub_df$勝数, "勝",
    ifelse(sub_df$結果 == "維持", "", paste0(" ", sub_df$結果))
  )

  # 最初の4人だけ表示、その他は非表示
  visible_status <- if (i <= 4) TRUE else "legendonly"

  # マーカーサイズ（昇段は大きく、次点も個別に指定、その他は通常）
  sub_df$marker_size <- ifelse(
    sub_df$結果 == "昇段", 18,
    ifelse(sub_df$結果 == "次点", 18,  # 次点は 14 に設定
      10  # それ以外は 10
    )
  )

  # マーカー形状（結果ごとに指定）
  sub_df$marker_symbol <- ifelse(
    sub_df$結果 == "昇段", "star",
    ifelse(sub_df$結果 == "次点", "circle",
      ifelse(sub_df$結果 == "降段", "triangle-down",
        ifelse(sub_df$結果 == "維持", "circle", "circle")  # 維持は丸
      )
    )
  )

  # テキストは最後の期次だけ名前を表示
  sub_df$テキスト <- ifelse(sub_df$期次_num == max(sub_df$期次_num), name_i, "")

  # 前の点との差分を計算
  sub_df$勝数_diff <- c(NA, diff(sub_df$勝数))

  # textposition を決定
  # - 勝数が前の期次より下がっている場合 → "bottom center"
  # - それ以外 → "top center"
  sub_df$text_position <- ifelse(
    sub_df$勝数_diff < 0, "bottom center", "top center"
  )

  # 最初の点は NA なので top にしておく
  sub_df$text_position[1] <- "top center"

  p <- add_trace(
    p,
    data = sub_df,
    x = ~期次,
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
    categoryorder = "array",
    categoryarray = 期次_order,
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
