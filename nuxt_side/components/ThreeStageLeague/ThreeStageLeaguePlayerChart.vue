<template lang="pug">
.ThreeStageLeaguePlayerChart
  .columns.is-unselectable
    .column.is-half
      canvas#main_canvas.is-clickable(ref="main_canvas")
  template(v-if="development_p && false")
    | {{config}}
</template>

<script>

const CHART_CONFIG_DEFAULT = {
  type: "bar",
  options: {
    aspectRatio: 1.618, // 大きいほど横長方形になる

    // datasets 内に適応
    showLines: true,

    // nil のデータは飛ばしてつなげる
    // spanGaps: true,

    // https://www.chartjs.org/docs/latest/general/performance.html?h=animation
    //
    // これはどこで作用するのかよくわからないので保留
    // responsiveAnimationDuration: 0,

    animation: {
      duration: 0, // チャートのY座標が反転する時間 (盤が回転する時間に合わせる)
    },

    title: {
      display: false,
      text: "成績",
    },

    // https://misc.0o0o.org/chartjs-doc-ja/configuration/layout.html
    layout: {
      padding: {
        // left: 0,
        // right: 12,
        top: 0,                // ツールチップが欠けるのを防ぐ
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
          labelString: "第N期",
        },
        ticks: {
          // 50ずつ表示したいけどできない。その理由↓
          // http://www.kogures.com/hitoshi/javascript/chartjs/scale.html
          // Ｙ軸と同様にＸ軸でも、Ｂのようにmin/maxの指定ができます。このときはsuggestedMin/suggestedMaxは使えませんし、stepSize も使えません（無視されます）。
          // その理由は、Ｘ軸のラベルは単なる文字列で数値のような大小関係を示していないからです。同様な機能は maxTicksLimit で設定します。
          minRotation: 0,   // 表示角度水平
          maxRotation: 0,   // 表示角度水平
          // maxTicksLimit: 5, // 最大横N個の目盛りにする
          // callback(value, index, values) { return value + "" }, // 単位をつける
        },
        gridLines: {
          display: false,    // x軸の中間の縦線
        },
      }],
      yAxes: [{
        ticks: {
          suggestedMax: 15,
          beginAtZero: true,
          stepSize: 2,         // N秒毎の表示
          // maxTicksLimit: 7,     // 縦の最大目盛り数
          // callback(value, index, values) {
          //   return this.chart.config.__vm__.second_to_human(value)
          // },
        },
        gridLines: {
          display: true,
          // zeroLineWidth: 0,
        },
      }],
    },

    elements: {
      line: {
        // 折れ線グラフのすべてに線に適用する設定なのでこれがあると dataset 毎に設定しなくてよい
        // または app/javascript/packs/application.js で指定する
        // background-color
      },
    },

    // https://tr.you84815.space/chartjs/configuration/tooltip.html
    legend: {
      display: false,
    },

    // https://www.chartjs.org/docs/latest/general/interactions/
    hover: {
      mode: "index",          // マウスに対して点が強調される条件 X軸にマッチしたら点を強調する https://www.chartjs.org/docs/latest/general/interactions/modes.html#interaction-modes
      intersect: false,       // Y座標のチェックは無視する
      animationDuration: 400, // デフォルト400
    },

    // https://www.chartjs.org/docs/latest/configuration/tooltip.html#external-custom-tooltips
    tooltips: {
      enabled: false,

      mode: "index",    // マウスに対してツールチップが出る条件
      intersect: false, // Y座標のチェックは無視する

      displayColors: false, // 左に「■」を表示するか？

      yAlign: 'top', // 下側にキャロットがでるようにする。マニュアルに載ってない。https://stackoverflow.com/questions/44050238/change-chart-js-tooltip-caret-position

      callbacks: {
        title(tooltipItems, data) {
          return ""
        },
        beforeLabel(tooltipItems, data) {
          return ""
        },
        label(tooltipItem, data) {
          const chart_element = this
          const __vm__ = chart_element._chart.config.__vm__
          const membership = __vm__.config.memberships[tooltipItem.index]
          const v = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index]
          let s = `${v}`
          if (false) {
            if (membership.result_key !== "none") {
              s += ` (${membership.result_key})`
            }
          }
          return s
        },
      },
    },

    // バーをクリックしたとき
    onClick(event, chart_elements) {
      const chart_instance = this
      const __vm__ = chart_instance.config.__vm__

      // 点にホバーできている状態でクリックしたらその点を使う
      if (chart_elements.length >= 1) {
        const chart_element = chart_elements[0]
        const data = chart_element._chart.config.data
        const labels = data.labels
        const datasets = data.datasets
        const label = labels[chart_element._index]
        __vm__.bar_click_handle(label)
      }
    },
  },
}

import chart_mixin from '@/components/models/chart_mixin.js'

export default {
  name: "ThreeStageLeaguePlayerChart",
  mixins: [
    chart_mixin,
  ],
  props: {
    config: { type: Object, required: true },
  },
  created() {
    this.chart_setup(CHART_CONFIG_DEFAULT)
    this._chart_config.data = this.config.chart_data
  },
  mounted() {
    this.chart_create()
  },
  watch: {
    // これがないと config が変化したときにチャートが更新されない
    config() {
      this._chart_config.data = this.config.chart_data
      this.chart_update()
    },
  },
  methods: {
    bar_click_handle(generation) {
      this.sound_play_click()
      this.$router.push({name: "three-stage-leagues-generation", params: {generation: generation}})
    },
  },
}
</script>

<style lang="sass">
.ThreeStageLeaguePlayerChart
</style>
