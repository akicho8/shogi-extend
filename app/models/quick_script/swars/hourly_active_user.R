#!/usr/bin/env Rscript

library(jsonlite)
library(plotly)
library(htmlwidgets)
library(viridisLite)
library(scales)

# --- データ読み込み -----------------------------------------------
# api_url <- "http://localhost:3000/api/lab/swars/hourly_active_user.json?json_type=general"
api_url <- "https://www.shogi-extend.com/api/lab/swars/hourly_active_user.json?json_type=general"
df <- fromJSON(api_url)

# --- 曜日の並び順と時の順序 ---------------------------------------
weekday_order <- c("日", "月", "火", "水", "木", "金", "土")
df$曜日 <- factor(df$曜日, levels = weekday_order)
df$時 <- factor(df$時, levels = as.character(0:23))  # y軸を文字列にする

# --- z 軸データの正規化 -------------------------------------------
df$人数_norm <- rescale(df$人数, to = c(-1, 1))
df$強さ_norm <- rescale(df$強さ, to = c(-1, 1))

# --- 人数のヒートマップ -------------------------------------------
plot_count <- plot_ly(
  data = df,
  x = ~曜日,
  y = ~時,
  z = ~人数_norm,
  type = "heatmap",
  colors = colorRamp(viridisLite::turbo(100)),
  showscale = FALSE,
  hovertemplate = "%{x}曜日 %{y}時台 %{z:.2f}<extra></extra>"
)
plot_count <- layout(
  plot_count,
  yaxis = list(autorange = "reversed")
)

# --- 棋力のヒートマップ -------------------------------------------
plot_strength <- plot_ly(
  data = df,
  x = ~曜日,
  y = ~時,
  z = ~強さ_norm,
  type = "heatmap",
  colors = colorRamp(viridisLite::turbo(100)),
  showscale = TRUE,
  hovertemplate = "%{x}曜日 %{y}時台 %{z:.2f}<extra></extra>",

  colorbar = list(
    title = "",
    titleside = "top",
    tickvals = NULL,
    # ticks = "",
    x = 1.01,
    y = 0.666,
    len = 0.33
  )

)
plot_strength <- layout(
  plot_strength,
  yaxis = list(autorange = "reversed")
)

# --- 横並び配置、隙間を縮小 ---------------------------------------
combined <- subplot(
  plot_count,
  plot_strength,
  nrows = 1,
  shareY = TRUE,
  titleX = FALSE,
  margin = 0.01
)

# --- レイアウト全体設定 -------------------------------------------
combined <- layout(
  combined,
  font = list(color = "white"),
  plot_bgcolor = "#333",
  paper_bgcolor = "#333",

  title = list(
    text = "<b>将棋ウォーズ：時間帯による利用傾向と棋力傾向</b>",
    font = list(size = 28),
    x = 0.5
  ),

  margin = list(t = 110, l = 120, r = 120, b = 60),

  xaxis = list(tickfont = list(size = 16, color = "#aaa")),
  xaxis2 = list(tickfont = list(size = 16, color = "#aaa")),
  yaxis = list(autorange = "reversed", tickfont = list(size = 16, color = "#aaa"), title = ""),

  hoverlabel = list(bgcolor = "white", font = list(color = "#222"), bordercolor = "white"),

  annotations = list(
    list(
      x = 1.0, y = 1.03,
      text = paste("最終更新:", format(Sys.time(), "%Y-%m-%d")),
      showarrow = FALSE,
      xref = "paper", yref = "paper",
      font = list(size = 12, color = "#aaa")
    ),
    list(
      x = 0.24, y = 1.035,
      text = "<b>人数</b>",
      showarrow = FALSE,
      xref = "paper", yref = "paper",
      font = list(size = 18, color = "#fff")
    ),
    list(
      x = 0.76, y = 1.035,
      text = "<b>棋力</b>",
      showarrow = FALSE,
      xref = "paper", yref = "paper",
      font = list(size = 18, color = "#fff")
    )
  )
)

# --- 表示または保存 -----------------------------------------------
if (interactive()) {
  combined
} else {
  full_path <- "~/src/shogi/shogi-extend/nuxt_side/static/lab/swars/hourly-active-user.html"
  saveWidget(combined, full_path, selfcontained = TRUE)
  system(sprintf("open -a 'Google Chrome' %s", full_path))
}
