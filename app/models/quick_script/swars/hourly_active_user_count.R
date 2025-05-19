#!/usr/bin/env Rscript

library(jsonlite)
library(plotly)
library(htmlwidgets)
library(viridisLite)

# JSONデータを取得するURL
# url <- "http://localhost:3000/api/lab/swars/hourly_active_user.json?json_type=general"
url <- "https://www.shogi-extend.com/api/lab/swars/hourly_active_user.json?json_type=general"

# URLからJSONデータを取得して、Rの「データフレーム」（表形式のデータ）に変換
data <- fromJSON(url)

# 曜日の順番を決める
weekday_order <- c("日", "月", "火", "水", "木", "金", "土")

# 「曜日」の列を「factor」（順番のあるカテゴリ）として登録して、表示順を指定
data$day_of_week <- factor(data$day_of_week, levels = weekday_order)

# 「時間」（0〜23時）も順番通りに並ぶようにfactor化（文字列として扱う）
data$hour <- factor(data$hour, levels = as.character(0:23))

p_plotly <- plot_ly(
  data = data,
  x = ~day_of_week,
  y = ~hour,
  z = ~relative_uniq_user_count,
  type = "heatmap",
  # colors = colorRamp(c("blue", "cyan", "green", "yellow", "orange", "red")),
  # colors = colorRamp(brewer.pal(11, "Spectral")),
  # colors = colorRamp(viridisLite::turbo(100)),
  # colors = c("white", "darkred"),
  colors = colorRamp(viridisLite::turbo(100)),
  showscale = TRUE,
  hoverinfo = "skip",

  # カラーバーの設定
  colorbar = list(
    title = "人数",
    titleside = "top",
    # tickvals = NULL,
    # ticks = "",
    x = 1.01,
    y = 0.66,
    len = 0.33
  )
)

# --- グラフの見た目を調整（余白・タイトルなど） -------------------

p_plotly <- layout(
  p_plotly,

  font = list(color = "white"),       # その他テキストの色（白）
  plot_bgcolor = "#181818",           # グラフ領域の背景色（暗めのグレー）
  paper_bgcolor = "#181818",           # グラフ全体の背景色（暗めのグレー）

  # グラフのタイトルを設定
  title = list(
    text = "<b>将棋ウォーズ：時間帯別対局者数の推移</b>", # タイトルの文字（太字にして表示）
    font = list(size = 28),
    x = 0.5                            # 横方向の中央に配置（0〜1の範囲）
  ),

  # グラフ全体の余白を設定（単位はピクセル）
  margin = list(
    t = 80,   # 上の余白（タイトルがかぶらないように）
    l = 60,   # 左の余白（時間ラベルが見えるように）
    r = 80,   # 右の余白（カラーバーを表示するためのスペース）
    b = 60    # 下の余白（曜日ラベルが見えるように）
  ),

  # x軸（横軸：曜日）の設定
  xaxis = list(
    title = "",             # 軸のタイトル（非表示）
    showticklabels = TRUE,  # 曜日のラベルは表示する
    ticks = "",             # 軸の目盛り（ヒゲ）は非表示
    ticklen = 0,             # 念のため、ヒゲの長さも0にする
    tickfont = list(size = 18)
  ),

  # y軸（縦軸：時間）の設定
  yaxis = list(
    title = "",
    showticklabels = TRUE,
    ticks = "",
    ticklen = 0,
    autorange = "reversed",
    tickfont = list(size = 18)
  )
)

if (interactive()) {
  p_plotly
} else {
  full_path <- "~/src/shogi-extend/nuxt_side/static/lab/swars/hourly-active-user-count.html"
  saveWidget(p_plotly, full_path, selfcontained = TRUE)
  system(sprintf("open -a 'Google Chrome' %s", full_path))
}
