import { PaletteInfo } from "@/components/models/palette_info.js"
window.PaletteInfo = PaletteInfo

import Chart from "chart.js"
window.Chart = Chart

// 画像をダウンロードしたときに背景色が透明になる問題への対処法
// http://wordpress.ideacompo.com/?p=12888
Chart.plugins.register({
  beforeDraw(c) {
    let color = "rgb(255, 255, 255)"
    if (c.config.my_custom_background_color) {
      color = c.config.my_custom_background_color
    }
    const ctx = c.chart.ctx
    ctx.fillStyle = color
    ctx.fillRect(0, 0, c.chart.width, c.chart.height)
  }
})

////////////////////////////////////////////////////////////////////////////////

Chart.defaults.line.spanGaps = true // 点とデータが欠けていても点を繋ぐか？ https://www.chartjs.org/docs/latest/charts/line.html#default-options

////////////////////////////////////////////////////////////////////////////////

Chart.defaults.global.defaultFontSize                 = 11   // https://www.chartjs.org/docs/latest/general/fonts.html?h=fontsize

Chart.defaults.global.elements.line.tension           = 0.2  // 0なら線がカクカクになる
Chart.defaults.global.elements.line.borderWidth       = 1    // 点枠の太さ
Chart.defaults.global.elements.line.fill              = true // 塗り潰す？

Chart.defaults.global.elements.point.radius           = 1.2 // 点半径
Chart.defaults.global.elements.point.hoverRadius      = 3   // 点半径(アクティブ時)
Chart.defaults.global.elements.point.hoverBorderWidth = 2   // 点枠の太さ(アクティブ時)
Chart.defaults.global.elements.point.hitRadius        = 1   // タップできる大きさ(1:干渉しない 2:干渉しにくい 3:干渉する)

//////////////////////////////////////////////////////////////////////////////// 色

function color_select(context, alpha) {
  // https://www.chartjs.org/docs/latest/general/options.html#option-context
  const index = context.datasetIndex
  const value = context.dataset.data[index]
  const n = index % PaletteInfo.values.length
  return PaletteInfo.fetch(n).alpha(alpha)
}

// https://www.chartjs.org/docs/latest/configuration/elements.html#line-configuration
Chart.defaults.global.elements.line.backgroundColor  = function(context) { return color_select(context, 0.3) }
Chart.defaults.global.elements.line.borderColor      = function(context) { return color_select(context, 1.0) }
// https://www.chartjs.org/docs/latest/configuration/elements.html#point-configuration
Chart.defaults.global.elements.point.backgroundColor = function(context) { return color_select(context, 0.3) }
Chart.defaults.global.elements.point.borderColor     = function(context) { return color_select(context, 1.0) }
// https://www.chartjs.org/docs/latest/configuration/elements.html#rectangle-configuration
Chart.defaults.global.elements.rectangle.backgroundColor = function(context) { return color_select(context, 0.3) }
Chart.defaults.global.elements.rectangle.borderColor     = function(context) { return color_select(context, 1.0) }
Chart.defaults.global.elements.rectangle.borderWidth     = 0
