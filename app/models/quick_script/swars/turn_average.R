library(jsonlite)
library(plotly)

url <- "https://www.shogi-extend.com/api/lab/swars/grade_segment.json?json_type=general"
json_data <- fromJSON(url)

data <- data.frame(
  棋力 = json_data$棋力,
  終局 = as.numeric(json_data$手数),
  衝突 = as.numeric(json_data[["衝突"]]),
  開戦 = as.numeric(json_data[["開戦"]]),
  stringsAsFactors = FALSE
)

grade_order_jp <- c(
  "十段", "九段", "八段", "七段", "六段", "五段", "四段", "三段", "二段", "初段",
  "1級", "2級", "3級", "4級", "5級", "6級", "7級", "8級", "9級", "10級"
)
data$棋力 <- factor(data$棋力, levels = grade_order_jp)

min_val <- floor(min(data$衝突, na.rm = TRUE))
min_val <- 0
max_val <- ceiling(max(data$終局, na.rm = TRUE) / 10) * 10

color_map <- c(
  "衝突" = "#D9E1F2",  # 一番薄い青
  "開戦" = "#A8B9E0",  # 中間の青
  "終局" = "#7791CD"   # 一番濃い青（でも控えめ）
)

p <- plot_ly()

# 終局を一番最初に描画（最も奥に）
p <- add_trace(p,
  x = data$終局,
  y = data$棋力,
  type = "bar",
  orientation = "h",
  name = "終局",
  marker = list(color = color_map["終局"]),
  hoverinfo = "text",
  text = paste0("終局: ", round(data$終局, 1)),
  textposition = "none"
)

# 開戦を上に重ねる
p <- add_trace(p,
  x = data$開戦,
  y = data$棋力,
  type = "bar",
  orientation = "h",
  name = "開戦",
  marker = list(color = color_map["開戦"]),
  hoverinfo = "text",
  text = paste0("開戦: ", round(data$開戦, 1)),
  textposition = "none"
)

# 最前面に衝突を重ねる
p <- add_trace(p,
  x = data$衝突,
  y = data$棋力,
  type = "bar",
  orientation = "h",
  name = "衝突",
  marker = list(color = color_map["衝突"]),
  hoverinfo = "text",
  text = paste0("衝突: ", round(data$衝突, 1)),
  textposition = "none"
)

p <- layout(
  p,
  title = list(
    text = "<b>将棋ウォーズ：棋力別の平均手数</b>",
    font = list(size = 24, color = "black")
  ),
  yaxis = list(
    title = "",
    categoryorder = "array",
    categoryarray = grade_order_jp,
    tickfont = list(color = "black")
  ),
  xaxis = list(
    title = "",
    tickfont = list(color = "black"),
    showgrid = FALSE,
    gridcolor = "#e0e0e0",
    range = c(min_val, max_val),
    zeroline = FALSE,  # これで左端の線を消す
    dtick = 10
  ),
  margin = list(l = 60, r = 60, t = 100, b = 100),
  barmode = "overlay", # 重ね表示
  hoverlabel = list(
    bgcolor = "white",
    font = list(color = "#222"),
    bordercolor = "white"
  ),
  legend = list(
    x = 0.494,         # 横方向の中央
    y = -0.04,        # グラフの下（0が下端、0未満でさらに下）
    xanchor = "center",  # 中央寄せ
    yanchor = "top",     # 上端を基準に配置
    orientation = "h",    # 凡例を横並びにする
    traceorder = "reversed"
  )
)

p <- config(p, displayModeBar = TRUE)

if (interactive()) {
  p
} else {
  full_path <- "~/src/shogi-extend/nuxt_side/static/lab/swars/turn-average-overlay.html"
  htmlwidgets::saveWidget(p, full_path, selfcontained = TRUE)
  system(sprintf("open -a 'Google Chrome' %s", full_path))
}
