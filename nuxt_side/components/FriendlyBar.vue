<template lang="pug">
.FriendlyBar.is-unselectable.is-clickable(:class="`bar_type_${info.bar_type}`" @click="zoom_handle")
  canvas(ref="main_canvas")
  //- .zoom_button_container
  //-   b-button.zoom_button(@click="zoom_handle" icon-left="home")
</template>

<script>
import { PaletteGenerator } from "@/components/models/palette_generator.js"

// https://zenn.dev/kokota/articles/fea620d9bf1a24
import chartjsPluginDatalabels from 'chartjs-plugin-datalabels'

// https://beiznotes.org/data-label-on-chart-js/
// Define a plugin to provide data labels
// const my_plugin1 = {
//   afterDatasetsDraw(chart, easing) {
//     // To only draw at the end of animation, check for easing === 1
//     const ctx = chart.ctx
//     chart.data.datasets.forEach((dataset, i) => {
//       const meta = chart.getDatasetMeta(i)
//       if (!meta.hidden) {
//         meta.data.forEach(function (element, index) {
//           // Draw the text in black, with the specified font
//           ctx.fillStyle = 'hsla(0,0%,20%,1.0)'
//
//           const fontSize = 16
//           const fontStyle = 'normal'
//           const fontFamily = 'Helvetica Neue'
//           ctx.font = Chart.helpers.fontString(fontSize, fontStyle, fontFamily)
//
//           // ラベルの場合
//           // const dataString = chart.data.labels[index]
//
//           // 値の場合
//           const dataString = dataset.data[index].toString()
//
//           // Make sure alignment settings are correct
//           ctx.textAlign = 'center'
//           ctx.textBaseline = 'middle'
//
//           const padding = 5
//           const position = element.tooltipPosition()
//           ctx.fillText(dataString, position.x, position.y - (fontSize / 2) - padding)
//         })
//       }
//     })
//   }
// }

const CHART_CONFIG_DEFAULT = {
  type: 'bar',
  data: {
    labels: null,
    datasets: [{
      borderWidth: 0,
      datalabels: {
        // https://v1_0_0--chartjs-plugin-datalabels.netlify.app/guide/positioning.html
        display: false,         // デフォルトでは表示しない
        anchor: "end",          // バーの先っぽ
        align: "top",           // 先っぽの上
        offset: 0,              // 先っぽと上の隙間(初期値:4)
        labels: {
          value: {
            // https://tt-computing.com/chartjs2-datalabels-stacked-bar
            color: "hsla(0,0%,0%,0.5)",
          },
        },
        formatter(value, context) {
          // 下のラベルが必要な場合
          // const label = context.chart.data.labels[context.dataIndex]
          const __vm__ = context.chart.config.__vm__
          return __vm__.bar_value_decorator(value)
        }
      },
    }],
  },
  // https://misc.0o0o.org/chartjs-doc-ja/charts/bar.html
  options: {
    aspectRatio: 3.0, // 大きいほど横長方形になる

    animation: {
      duration: 0, // アニメーションOFF
    },

    title: {
      display: false,
    },

    // https://misc.0o0o.org/chartjs-doc-ja/configuration/layout.html
    layout: {
      padding: {
        // left: 0,
        // right: 12,
        // top: 14,                // ツールチップが欠けるのを防ぐ
        // bottom: 0
      },
    },

    // https://qiita.com/Haruka-Ogawa/items/59facd24f2a8bdb6d369#3-5-%E6%95%A3%E5%B8%83%E5%9B%B3
    // https://qiita.com/muuuuminn/items/2e977add604dcec920d3
    scales: {
      xAxes: [{
        // http://www.kogures.com/hitoshi/javascript/chartjs/bar-width.html
        // categoryPercentage: 0.8, // 目盛り線の幅に対する棒（複数棒）の占める幅の割合
        // barPercentage: 0.9,      // categoryPercentageに対する単独棒の幅。1にすると複数棒間間隔がなくなり、1より小さくすると棒が細くなり間隔が広がる
        scaleLabel: {
          display: false,
          labelString: "?",
        },
        ticks: {
          minRotation: 0,   // 表示角度水平
          maxRotation: 0,   // 表示角度水平
        },
        gridLines: {
          display: false,    // x軸の中間の縦線
          tickMarkLength: 4, // 時間とバーの隙間
        },
      }],
      yAxes: [{
        display: false,
        ticks: {
          beginAtZero: true,
          // stepSize: 5,        // N秒毎の表示
          maxTicksLimit: 3,   // 縦の最大目盛り数
          // callback(value, index, values) {
          //   return this.chart.config.__vm__.second_to_human(value)
          // },
        },
        gridLines: {
          display: false,
          drawBorder: false,
          // zeroLineWidth: 0,
          // tickMarkLength: 20,
        },
      }],
    },

    elements: {
      rectangle: {
        // 折れ線グラフのすべてに線に適用する設定なのでこれがあると dataset 毎に設定しなくてよい
        // または app/javascript/packs/application.js で指定する
        // background-color
      },
    },

    // https://tr.you84815.space/chartjs/configuration/tooltip.html
    legend: {
      display: false,
    },

    // https://www.chartjs.org/docs/latest/configuration/tooltip.html#external-custom-tooltips
    tooltips: {
      enabled: true,
      displayColors: false, // 左に「■」を表示するか？
      callbacks: {
        title(tooltipItems, data) {
          return ""
        },
        beforeLabel(tooltipItems, data) {
          return ""
        },
        label(tooltipItem, data) {
          const y = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index]
          const chart_element = this
          const __vm__ = chart_element._chart.config.__vm__
          return __vm__.tooltip_value_decorator(y)
        },
      },
    },
  },
  // plugins: [my_plugin1],
  plugins: [chartjsPluginDatalabels],
}

import chart_mixin from '@/components/models/chart_mixin.js'
import { BarPresetInfo } from "./models/bar_preset_info.js"

// http://localhost:3000/w?query=kinakom0chi&user_stat_show=true
export default {
  mixins: [
    chart_mixin,
  ],
  props: {
    info: { type: Object, required: true, },  // [{name: ..., value: ...}, ...]
    // chart_options: { type: Object, default: () => ({}), },
  },
  data() {
    return {
      bar_preset_key: "bp_is_default",
    }
  },
  created() {
    // ・this._chart_config = Object.assign({}, CHART_CONFIG_DEFAULT) はダメ
    // ・shallow copy は this._chart_config.data.datasets[0] のポインタがコピーされていない
    // ・生成した同じコンポーネントで上書きされてしまう
    // ・なので cloneDeep している
    // ・ただし function が消える
    // ・function が必要なときは直接 Vue の方に書いた方がいいのかもしれない
    this.chart_setup(CHART_CONFIG_DEFAULT)
    // this._chart_config = _.cloneDeep(CHART_CONFIG_DEFAULT)
    this._chart_config.data.labels = this.extract_labels
    this._chart_config.data.datasets[0].data = this.extract_values

    if (true) {
      // borderWidth が効かない
      this._chart_config.options.elements.rectangle.backgroundColor = PaletteGenerator.palette_type4()
      // this._chart_config.options.elements.rectangle.borderColor = PaletteGenerator.palette_transparent()
      // this._chart_config.options.elements.rectangle.borderWidth = 0 // 効かないので borderColor を透明にしている
    } else {
      this._chart_config.data.datasets[0].backgroundColor = PaletteGenerator.palette_type4()
      this._chart_config.data.datasets[0].borderWidth = 0 // 重要
    }

    if (this.development_p && false) {
      this._chart_config.options.animation.animateScale = true
      this._chart_config.options.animation.animateRotate = true
    }
  },
  mounted() {
    this.chart_create()
  },
  methods: {
    zoom_handle() {
      this.sfx_play_click()
      this.bar_preset_key = this.BarPresetInfo.fetch(this.$gs.imodulo(this.bar_preset_info.code + 1, this.BarPresetInfo.values.length)).key
      // this._chart_config.options.aspectRatio = this.bar_preset_info.value
      // this.chart_create()
      // this.debug_alert(this._chart_config.options.aspectRatio)
      this._chart_config.options.aspectRatio                 = this.bar_preset_info.aspect_ratio
      this._chart_config.data.datasets[0].datalabels.display = this.bar_preset_info.datalabels_display
      this.chart_create()
    },
    // tategaki_p が有効なら縦書きにする
    // "成銀" --> ["成", "銀"]
    name_decorate(str) {
      if (this.info.chart_options.tategaki_p) {
        str = [...str]
      }
      return str
    },
    tooltip_value_decorator(value) {
      if (this.info.chart_options.value_format === "percentage") {
        return (value * 100).toFixed(2) + " %"
      } else {
        return `${value}`
      }
    },
    bar_value_decorator(value) {
      if (value === 0) {
        return ""
      } else {
        if (this.info.chart_options.value_format === "percentage") {
          return (value * 100).toFixed(2)
        } else {
          return `${value}`
        }
      }
    },
  },
  computed: {
    BarPresetInfo()    { return BarPresetInfo },
    bar_preset_info()  { return this.BarPresetInfo.fetch(this.bar_preset_key) },
    data_list()      { return this.info.body || []             },
    data_count()     { return this.data_list.length            },
    extract_labels() { return this.data_list.map(e => this.name_decorate(e.name)) },
    extract_values() { return this.data_list.map(e => e.value) },
  },
}
</script>

<style lang="sass">
.FriendlyBar
  width: 100%
  // .zoom_button_container
  //   position: absolute
  //   top: 0
  //   right: 0
  //   .zoom_button
  //     line-height: 1.0
  //     padding: 0.25rem 0.25rem
  //     font-size: $size-7
  //     border-radius: 3px
  //     color: change_color($warning, $lightness: 30%)
  //     background-color: change_color($warning, $lightness: 100%)
</style>
