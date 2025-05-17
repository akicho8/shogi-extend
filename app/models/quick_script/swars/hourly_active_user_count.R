#!/usr/bin/env Rscript

# --- ライブラリの読み込み ------------------------------------------

# JSON形式のデータを読み込むためのライブラリ
library(jsonlite)

# グラフを作るためのライブラリ（マウス操作で動かせるインタラクティブなグラフが作れる）
library(plotly)

# グラフをHTMLファイルとして保存するためのライブラリ
library(htmlwidgets)

# --- データの読み込み ----------------------------------------------

# JSONデータを取得するURL
# url <- "http://localhost:3000/api/lab/swars/hourly_active_user.json?json_type=general"
url <- "https://www.shogi-extend.com/api/lab/swars/hourly_active_user.json?json_type=general"

# URLからJSONデータを取得して、Rの「データフレーム」（表形式のデータ）に変換
data <- fromJSON(url)

# --- データの加工（見た目を整える準備） ---------------------------

# 曜日の順番を決める
weekday_order <- c("日", "月", "火", "水", "木", "金", "土")

# 「曜日」の列を「factor」（順番のあるカテゴリ）として登録して、表示順を指定
data$day_of_week <- factor(data$day_of_week, levels = weekday_order)

# 「時間」（0〜23時）も順番通りに並ぶようにfactor化（文字列として扱う）
data$hour <- factor(data$hour, levels = as.character(0:23))

# --- ヒートマップ（色のついた表）を作る --------------------------

# plot_ly()関数でヒートマップを作成
p_plotly <- plot_ly(
  data = data,                     # データを指定（上で作った表形式のデータ）
  x = ~day_of_week,                # 横軸に「曜日」を表示
  y = ~hour,                       # 縦軸に「時間」を表示
  z = ~relative_uniq_user_count,   # 各マスの色に使う値（対局者数の相対的な数）
  type = "heatmap",                # グラフの種類をヒートマップに指定
  colors = colorRamp(c(            # 色のグラデーション（青→赤）を指定
    "blue", "cyan", "green", "yellow", "orange", "red"
  )),
  showscale = TRUE,                # 右側に色のメーター（カラーバー）を表示
  hoverinfo = "skip",              # マウスを重ねたときの吹き出しを表示しない

  # カラーバーの設定
  colorbar = list(
    title = "人数",               # カラーバーの上に「人数」と表示
    titleside = "top",            # タイトルの位置は上
    tickvals = NULL,              # 数値の目盛りは表示しない
    ticks = "",                   # 軸のヒゲ（線）も表示しない
    x = 1.01,                     # カラーバーの位置（グラフの右端よりちょっと右）
    y = 1.0,                      # 縦位置の中心（0が一番下、1が一番上）
    len = 0.33                     # カラーバーの長さ（1.0で上下いっぱいに表示）
  )
)

# --- グラフの見た目を調整（余白・タイトルなど） -------------------

p_plotly <- layout(
  p_plotly,

  # グラフのタイトルを設定
  title = list(
    text = "<b>将棋ウォーズ時間帯別対局者数</b>", # タイトルの文字（太字にして表示）
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
    ticklen = 0             # 念のため、ヒゲの長さも0にする
  ),

  # y軸（縦軸：時間）の設定
  yaxis = list(
    title = "",             # 軸のタイトル（非表示）
    showticklabels = TRUE,  # 時間（0〜23時）のラベルは表示する
    ticks = "",             # 軸の目盛り（ヒゲ）は非表示
    ticklen = 0,            # ヒゲの長さ0
    autorange = "reversed"  # 縦軸を上下反転（上に0時、下に23時がくるように）
  )
)

# --- グラフの表示または保存 ----------------------------------------

# 「対話モード」（RStudioなどで直接操作している場合）
if (interactive()) {
  p_plotly  # グラフをそのまま表示
} else {
  # スクリプトとして実行されている場合（ファイルに保存して表示）

  # 保存するパス（Nuxtアプリの静的ファイルとして保存する想定）
  full_path <- "~/src/shogi-extend/nuxt_side/static/lab/swars/hourly-active-user-count.html"

  # グラフをHTMLファイルとして保存（selfcontained=TRUEで1ファイルに全部まとめる）
  saveWidget(p_plotly, full_path, selfcontained = TRUE)

  # MacのGoogle Chromeで保存したファイルを自動的に開く
  system(sprintf("open -a 'Google Chrome' %s", full_path))
}
