<template lang="pug">
.FriendlyBar.is-unselectable(:class="`bar_type_${info.bar_type}`")
  canvas(ref="main_canvas")
</template>

<script>
import { PaletteGenerator } from "@/components/models/palette_generator.js"

const CHART_CONFIG_DEFAULT = {
  type: 'bar',
  data: {
    labels: null,
    datasets: [{
      borderWidth: 0,
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
      },
    },
  },
}

import chart_mixin from '@/components/models/chart_mixin.js'

// http://localhost:3000/w?query=kinakom0chi&user_info_show=true
export default {
  mixins: [
    chart_mixin,
  ],
  props: {
    info: { type: Object, required: true, },  // [{name: ..., value: ...}, ...]
    // chart_options: { type: Object, default: {}, },
  },
  created() {
    // ・this._chart_config = Object.assign({}, CHART_CONFIG_DEFAULT) はダメ
    // ・shallow copy は this._chart_config.data.datasets[0] のポインタがコピーされていない
    // ・生成した同じコンポーネントで上書きされてしまう
    // ・なので cloneDeep している
    // ・ただし function が消える
    // ・function が必要なときは直接 Vue の方に書いた方がいいのかもしれない
    this._chart_config = _.cloneDeep(CHART_CONFIG_DEFAULT)
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
  computed: {
    data_list()      { return this.info.body || []             },
    data_count()     { return this.data_list.length            },
    extract_labels() { return this.data_list.map(e => e.name)  },
    extract_values() { return this.data_list.map(e => e.value) },
  },
}
</script>

<style lang="sass">
.FriendlyBar
  width: 100%
</style>
