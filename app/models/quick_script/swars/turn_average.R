library(jsonlite)
library(plotly)

api_url <- "https://www.shogi-extend.com/api/lab/swars/grade_segment.json?json_type=general"
json_data <- fromJSON(api_url)

data <- data.frame(
  棋力 = json_data$棋力,
  終局 = as.numeric(json_data$手数),
  衝突 = as.numeric(json_data[["衝突"]]),
  開戦 = as.numeric(json_data[["開戦"]]),
  stringsAsFactors = FALSE
)

grade_order_jp <- rev(c(
  "九段", "八段", "七段", "六段", "五段", "四段", "三段", "二段", "初段",
  "1級", "2級", "3級", "4級", "5級", "6級", "7級", "8級", "9級", "10級"
))
data$棋力 <- factor(data$棋力, levels = grade_order_jp)

trace_names <- c("衝突", "開戦", "終局")

p <- plot_ly(data = data)
for (name in trace_names) {
  y_values <- data[[name]]

  # 10級 → 系列名、それ以外 → 空文字（textは点の上に表示する文字。今回は使わないので空でOK）
  text_labels <- ifelse(data$棋力 == "10級", name, "")

  # hovertextを小数1桁で作る
  hover_y <- sprintf("%.1f", y_values)
  hover_text <- hover_y

  p <- add_trace(
    p,
    x = ~棋力,
    y = y_values,
    type = "scatter",
    mode = "lines+markers+text",
    name = name,
    text = text_labels,
    textposition = "top center",  # 点上に固定テキスト表示（今回の用途は変えず）
    textfont = list(size = 18, color = "white"),
    hoverinfo = "text",
    hovertext = hover_text,
    line = list(width = 4, shape = "spline"),
    marker = list(size = 12, opacity = 0.8)
  )
}

p <- layout(
  p,
  title = list(
    text = "<b>将棋ウォーズ：棋力別の平均手数</b>",
    font = list(size = 24, color = "white")
  ),
  xaxis = list(
    categoryorder = "array",
    categoryarray = grade_order_jp,
    tickfont = list(color = "white"),
    showgrid = TRUE,
    gridcolor = "#444",
    zeroline = FALSE,
    title = ""
  ),
  yaxis = list(
    tickfont = list(color = "white"),
    showgrid = TRUE,
    gridcolor = "#444",
    zeroline = FALSE,
    title = ""
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
  hoverlabel = list(bgcolor = "#333", font = list(color = "white", size = 20), bordercolor = "#333"),
  margin = list(l = 70, r = 70, t = 100, b = 70),
  annotations = list(list(x = 1.0, y = 1.03, text = paste("最終更新:", format(Sys.time(), "%Y-%m-%d")), showarrow = FALSE, xref = "paper", yref = "paper", font = list(size = 12, color = "#aaa")))
)

p <- config(p, displayModeBar = TRUE)

if (interactive()) {
  p
} else {
  full_path <- "~/src/shogi/shogi-extend/nuxt_side/static/lab/swars/turn-average.html"
  htmlwidgets::saveWidget(p, full_path, selfcontained = TRUE)
  system(sprintf("open -a 'Google Chrome' %s", full_path))
}
