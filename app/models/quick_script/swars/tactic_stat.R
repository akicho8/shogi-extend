#!/usr/bin/env Rscript
library(jsonlite)
library(ggplot2)
library(plotly)
library(htmlwidgets)

# df <- fromJSON("http://localhost:3000/api/lab/swars/tactic-list.json?json_type=general")
df <- fromJSON("https://www.shogi-extend.com/api/lab/swars/tactic-list.json?json_type=general")

df <- df[!is.na(df$勝率), ]
df <- df[df$種類 == "戦法" | df$種類 == "囲い", ]
# df <- df[df$相対頻度 >= 0.0000003, ]
df <- df[df$名前 != "力戦", ]
df <- df[df$名前 != "居玉", ]
df <- df[0.3 <= df$勝率 & df$勝率 <= 0.7, ]

# 縦軸と横軸を入れ替えて、対数スケール適用
p <- ggplot(df, aes(x = 相対頻度, y = 勝率 * 100, label = 名前)) +
  geom_text(size = 5, fontface = "bold", hjust = 0.5, vjust = 0.5) +
  scale_x_log10() +  # 横軸を対数スケールに
  labs(
    title = "人気と勝率で見る将棋の戦法・囲い分布",
    x = "人気",
    y = "勝率 (%)"
  ) +
  theme_minimal(base_family = "Hiragino Sans", base_size = 18) +
  theme(
    plot.title = element_text(size = 20, face = "bold", hjust = 0.5),
    axis.title = element_text(size = 20),
    axis.text = element_text(size = 16),
    panel.grid.major = element_line(color = "gray90"),
    panel.grid.minor = element_blank(),
    plot.margin = unit(c(1.5, 1.5, 1.5, 1.5), "cm")  # 上, 右, 下, 左
    #plot.margin = margin(30, 30, 30, 30)
  )

# plotly 化
p_plotly <- ggplotly(p)

# hover を無効化
for (i in seq_along(p_plotly$x$data)) {
  p_plotly$x$data[[i]]$hoverinfo <- "skip"
}

if (!interactive()) {
  full_path <- "~/src/shogi-extend/nuxt_side/static/lab/swars/tactic-stat.html"
  saveWidget(p_plotly, full_path, selfcontained = TRUE)
  system(sprintf("open -a 'Google Chrome' %s", full_path))
}

# cap staging nuxt_side:static_upload
# https://shogi-flow.xyz/lab/swars/tactic-stat.html

# cap production nuxt_side:static_upload
# https://www.shogi-extend.com/lab/swars/tactic-stat.html
