#!/usr/bin/env Rscript

library(jsonlite)
library(plotly)
library(htmlwidgets)

# JSONの取得
# api_url <- "http://localhost:3000/api/lab/swars/user_dist.json?json_type=general"
api_url <- "https://www.shogi-extend.com/api/lab/swars/user_dist.json?json_type=general"
json_data <- fromJSON(api_url)

# データフレーム作成
df <- as.data.frame(json_data)

# 棋力の並び順（級はベタ書き）
rank_order <- c(
  paste0(30:11, "級"),
  "10級", "9級", "8級", "7級", "6級", "5級", "4級", "3級", "2級", "1級",
  "初段", "二段", "三段", "四段", "五段", "六段", "七段", "八段", "九段", "十段"
)
df$棋力 <- factor(df$棋力, levels = rank_order)

# 初期表示させるラベル名
visible_labels <- c("野良10分", "野良3分", "野良10秒", "野良ｽﾌﾟﾘﾝﾄ (3分)")

# 条件とラベルをまとめて定義（構造体のように）
entries <- list(
  list(配置 = "通常",       モード = "野良",   ルール = "10分",  ラベル = "野良10分"),
  list(配置 = "通常",       モード = "野良",   ルール = "3分",   ラベル = "野良3分"),
  list(配置 = "通常",       モード = "野良",   ルール = "10秒",  ラベル = "野良10秒"),
  list(配置 = "スプリント", モード = "野良",   ルール = "3分",   ラベル = "野良ｽﾌﾟﾘﾝﾄ (3分)"),

  list(配置 = "通常",       モード = "友達",   ルール = "10分",  ラベル = "友対10分"),
  list(配置 = "通常",       モード = "友達",   ルール = "3分",   ラベル = "友対3分"),
  list(配置 = "通常",       モード = "友達",   ルール = "10秒",  ラベル = "友対10秒"),

  list(配置 = "スプリント", モード = "友達",   ルール = "10分",  ラベル = "友対10分 (ｽﾌﾟﾘﾝﾄ)"),
  list(配置 = "スプリント", モード = "友達",   ルール = "3分",   ラベル = "友対3分 (ｽﾌﾟﾘﾝﾄ)"),
  list(配置 = "スプリント", モード = "友達",   ルール = "10秒",  ラベル = "友対10秒 (ｽﾌﾟﾘﾝﾄ)"),

  list(配置 = "通常",       モード = "指導",   ルール = "10分",  ラベル = "指導対局"),

  list(配置 = "通常",       モード = "大会",   ルール = "10分",  ラベル = "大会10分"),
  list(配置 = "通常",       モード = "大会",   ルール = "3分",   ラベル = "大会3分")

  # list(配置 = "通常",       モード = "大会",   ルール = "10秒",  ラベル = "大会10秒"),
  # list(配置 = "スプリント", モード = "大会",   ルール = "3分",   ラベル = "大会3分 (ｽﾌﾟﾘﾝﾄ)")
)

# トレース追加部分の修正
p <- plot_ly()

for (entry in entries) {
  sub_df <- subset(df, 配置 == entry$配置 & モード == entry$モード & ルール == entry$ルール)
  sub_df$棋力 <- factor(sub_df$棋力, levels = rank_order)

  # 割合を計算
  total <- sum(sub_df$人数)
  sub_df$割合 <- sub_df$人数 / total

  # ホバーテキスト
  hover_text <- sprintf(
    "%s %s %d人 (%.0f%%)",
    entry$ラベル,
    sub_df$棋力,
    sub_df$人数,
    sub_df$割合 * 100
  )

  # 30級のときだけラベル表示、それ以外は空白
  sub_df$テキスト <- ifelse(sub_df$棋力 == "30級", entry$ラベル, "")

  p <- add_trace(
    p,
    data = sub_df,
    x = ~棋力,
    y = ~人数,
    type = "scatter",
    mode = "lines+markers+text",
    name = entry$ラベル,
    visible = if (entry$ラベル %in% visible_labels) TRUE else "legendonly",
    line = list(width = 4, shape = "spline"),
    marker = list(size = 12, opacity = 0.8),
    text = ~テキスト,  # 30級だけ表示する常時テキスト
    textposition = "top center",
    hovertext = hover_text,  # hover時に表示するテキスト
    hoverinfo = "text"
  )
}

# レイアウト設定（前の設定とほぼ同じでOK）
p <- layout(
  p,
  title = list(
    text = "<b>将棋ウォーズ：対局ルール別の利用者数分布</b>",
    font = list(size = 24, color = "white")
  ),
  xaxis = list(
    categoryorder = "array",
    categoryarray = rank_order,
    tickfont = list(color = "#aaa"),
    showgrid = TRUE,
    gridcolor = "#444",
    zeroline = FALSE,
    title = ""
  ),
  yaxis = list(
    tickfont = list(color = "#aaa"),
    showgrid = TRUE,
    gridcolor = "#444",
    zeroline = FALSE,
    title = ""
    # title = "割合（%）",
    # tickformat = ".0%"
  ),
  plot_bgcolor = "#333",
  paper_bgcolor = "#333",
  font = list(color = "white"),
  hoverlabel = list(bgcolor = "#333", font = list(color = "#aaa", size = 18), bordercolor = "#aaa"),
  margin = list(l = 70, r = 70, t = 100, b = 70),
  annotations = list(list(x = 1.0, y = 1.03, text = paste("最終更新:", format(Sys.time(), "%Y-%m-%d")), showarrow = FALSE, xref = "paper", yref = "paper", font = list(size = 12, color = "#aaa")))
)

p <- config(p, displayModeBar = TRUE)

# 表示 or 保存
if (interactive()) {
  p
} else {
  out_path <- "~/src/shogi/shogi-extend/nuxt_side/static/lab/swars/user-dist.html"
  saveWidget(p, out_path, selfcontained = TRUE)
  system(sprintf("open -a 'Google Chrome' %s", out_path))
}
