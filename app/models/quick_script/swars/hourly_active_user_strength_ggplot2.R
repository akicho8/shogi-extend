#!/usr/bin/env Rscript

# 必要なライブラリを読み込み
library(jsonlite)
library(ggplot2)
library(plotly)
library(htmlwidgets)
library(viridisLite)

# データを読み込み
# url <- "http://localhost:3000/api/lab/swars/hourly_active_user.json?json_type=general"
url <- "https://www.shogi-extend.com/api/lab/swars/hourly_active_user.json?json_type=general"
data <- fromJSON(url)

# 曜日の順番（祝日を右端に）
weekday_order <- c("日", "月", "火", "水", "木", "金", "土", "祝日")
data$day_of_week <- factor(data$day_of_week, levels = weekday_order)

# 時間の順番（0時〜23時）
data$hour <- factor(data$hour, levels = 0:23)

# ツールチップ用のテキストを追加
data$hover_text <- paste0(data$day_of_week, " ", data$hour, "時")

# ヒートマップを作成
p <- ggplot(data, aes(x = day_of_week, y = hour, fill = relative_strength, text = hover_text)) +
  geom_tile(color = "grey90") +
  # geom_text(aes(label = round(relative_strength, 1)), size = 3) +
  scale_fill_gradientn(
    # colors = c("white", "deepskyblue"),
    colors = viridisLite::magma(100),
    name = "棋力"
  ) +
  scale_y_discrete(limits = rev(levels(factor(data$hour)))) +
  theme_minimal(base_family = "Hiragino Sans") +
  labs(x = NULL, y = NULL, title = "将棋ウォーズ時間帯別相対棋力") +
  theme(
    panel.grid = element_blank(),
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 10),
    plot.title = element_text(size = 20, face = "bold", hjust = 0.5),
    plot.margin = unit(c(1.5, 1.5, 1.5, 1.5), "cm")  # 上, 右, 下, 左
  )

# ggplotly で text= が有効になるように tooltip="text" を指定
p_plotly <- ggplotly(p, tooltip = "text")
p_plotly

# hover を無効化
for (i in seq_along(p_plotly$x$data)) {
  p_plotly$x$data[[i]]$hoverinfo <- "skip"
}

if (!interactive()) {
  full_path <- "~/src/shogi-extend/nuxt_side/static/lab/swars/hourly-active-user-strength-ggplot2.html"
  saveWidget(p_plotly, full_path, selfcontained = TRUE)
  system(sprintf("open -a 'Google Chrome' %s", full_path))
}

# cap staging nuxt_side:static_upload
# https://shogi-flow.xyz/lab/swars/hourly-active-user-strength-ggplot2.html

# cap production nuxt_side:static_upload
# https://www.shogi-extend.com/lab/swars/hourly-active-user-strength-ggplot2.html
