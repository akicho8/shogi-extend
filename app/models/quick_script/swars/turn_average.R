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

grade_order_jp <- rev(c(
  "十段", "九段", "八段", "七段", "六段", "五段", "四段", "三段", "二段", "初段",
  "1級", "2級", "3級", "4級", "5級", "6級", "7級", "8級", "9級", "10級"
))
data$棋力 <- factor(data$棋力, levels = grade_order_jp)

trace_names <- c("衝突", "開戦", "終局")

# 最初の1本目
name <- trace_names[1]
p <- plot_ly(
  data = data,
  x = ~棋力,
  y = as.formula(paste0("~", name)),
  type = "scatter",
  mode = "lines+markers",
  name = name,
  line = list(width = 2, shape = "spline"),
  marker = list(size = 12, opacity = 0.8),
  hoverinfo = "skip"
)

# 残り2本を add_trace
for (name in trace_names[-1]) {
  p <- add_trace(
    p,
    y = as.formula(paste0("~", name)),
    name = name,
    line = list(shape = "spline"),
    hoverinfo = "skip"
  )
}

p <- layout(
  p,
  title = list(
    text = "<b>将棋ウォーズ：棋力別の平均手数</b>",
    font = list(size = 24, color = "white")
  ),
  xaxis = list(
    title = "棋力",
    categoryorder = "array",
    categoryarray = grade_order_jp,
    tickfont = list(color = "white"),
    showgrid = TRUE,
    gridcolor = "#444",  # 薄めの罫線
    zeroline = FALSE
  ),
  yaxis = list(
    title = "手数",
    tickfont = list(color = "white"),
    showgrid = TRUE,
    gridcolor = "#444",  # 薄めの罫線
    zeroline = FALSE
  ),
  plot_bgcolor = "#333",
  paper_bgcolor = "#333",
  font = list(color = "white"),
  legend = list(
    x = 1.05, y = 1,
    xanchor = "left",
    yanchor = "top",
    orientation = "v"
  ),
  margin = list(l = 60, r = 100, t = 100, b = 100),
  hovermode = FALSE
)

p <- config(p, displayModeBar = TRUE)

if (interactive()) {
  p
} else {
  full_path <- "~/src/shogi-extend/nuxt_side/static/lab/swars/turn-average.html"
  htmlwidgets::saveWidget(p, full_path, selfcontained = TRUE)
  system(sprintf("open -a 'Google Chrome' %s", full_path))
}
