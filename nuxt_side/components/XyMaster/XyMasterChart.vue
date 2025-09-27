<template lang="pug">
.XyMasterChart.columns.is-centered(v-show="TheApp.is_mode_idol")
  .column.chart_box_container
    .columns
      template(v-if="development_p")
        .column
          .has-text-centered
            b-field.is-inline-flex
              b-button(@click="TheApp.chart_data_get_and_show" size="is-small")
                | 更新
      .column
        .has-text-centered
          b-field.is-inline-flex
            template(v-for="e in TheApp.RuleInfo.values")
              b-radio-button(v-model="TheApp.chart_rule_key" :native-value="e.key" size="is-small" @input="sfx_play_click()")
                | {{e.name}}
      .column
        .has-text-centered
          b-field.is-inline-flex
            template(v-for="e in TheApp.ChartScopeInfo.values")
              b-radio-button(v-model="TheApp.chart_scope_key" :native-value="e.key" size="is-small" @input="sfx_play_click()")
                | {{e.name}}
    .columns.is-centered
      .column.is-half
        canvas(ref="main_canvas")
        template(v-if="TheApp.config.count_all_gteq > 1")
          .has-text-centered
            | {{TheApp.config.count_all_gteq}}回以上やるとチャートに登場します
</template>

<script>
import { support_child } from "./support_child.js"

import Chart from "chart.js"

const CHART_CONFIG_DEFAULT = {
  type: "line",
  options: {
    // サイズ
    aspectRatio: 1.618, // 大きいほど横長方形になる
    // maintainAspectRatio: false,
    // responsive: false,
    // responsive: true,
    // maintainAspectRatio: false,

    animation: {
      duration: 0, //  アニメーションOFF
    },

    elements: {
      line: {
      },
    },

    title: {
      display: false,
      text: "学習グラフ",
    },

    // https://misc.0o0o.org/chartjs-doc-ja/configuration/layout.html
    // layout: {
    //   padding: {
    //     left: 0,
    //     right: 0,
    //     top: 0,
    //     bottom: 0,
    //   },
    // },

    // https://qiita.com/Haruka-Ogawa/items/59facd24f2a8bdb6d369#3-5-%E6%95%A3%E5%B8%83%E5%9B%B3
    scales: {
      xAxes: [{
        type: 'time',
        time: {
          unit: "day",
          displayFormats: {
            day: "M/D",
          },
        },
        ticks: {
          minRotation: 0,   // 表示角度水平
          maxRotation: 0,   // 表示角度水平
          maxTicksLimit: 4, // 最大横N個の目盛りにする
        },
      }],
      yAxes: [{
        gridLines: {
          display: false,
          // offsetGridLines: false,
          // zeroLineWidth: 0,
        },
        scaleLabel: {
          display: false,
          labelString: "タイム",
        },
        ticks: {
          maxTicksLimit: 5, // 最大横N個の目盛りにする
          // suggestedMax: 1,
          // suggestedMin: 60,
          stepSize: 30,
          // max: 60*3,
          // min: 60,
          callback(value, index, values) {
            return dayjs.unix(value).format("mm:ss")
            // return Math.trunc(value / 60) + "時"
          }
        }
      }],
    },

    elements: {
      line: {
        // 折れ線グラフのすべてに線に適用する設定なのでこれがあると dataset 毎に設定しなくてよい
        // または app/javascript/packs/application.js で指定する
        fill: false,
      },
    },

    // https://tr.you84815.space/chartjs/configuration/tooltip.html
    legend: {
      display: true,
    },

    hover: {
      mode: "nearest",          // 近くの点だけにマッチさせる(必須) https:www.chartjs.org/docs/latest/general/interactions/modes.html#interaction-modes
      // intersect: true,       // Y座標のチェックは無視する
      // animationDuration: 0, // デフォルト400
    },

    tooltips: {
      // mode: "x",            // マウスに対してツールチップが出る条件
      // intersect: false,     // Y座標のチェックは無視する
      // displayColors: false, // 左に「■」を表示するか？
      yAlign: 'bottom',     // 下側にキャロットがでるようにする。マニュアルに載ってない。https://stackoverflow.com/questions/44050238/change-chart-js-tooltip-caret-position

      callbacks: {
        title(tooltipItems, data) {
          return ""
        },
        label(tooltipItem, data) {
          const dataset = data.datasets[tooltipItem.datasetIndex]
          const datasetLabel = dataset.label || ""
          const y = dataset.data[tooltipItem.index].y
          return datasetLabel + " " + dayjs.unix(y).format("mm:ss.SSS")
        },
      },
    },
  },
}

import dayjs from "dayjs"

import chart_mixin from '@/components/models/chart_mixin.js'

export default {
  name: "XyMasterChart",
  mixins: [
    support_child,
    chart_mixin,
  ],
  methods: {
    chart_update_from_axios(data) {
      this.chart_setup(CHART_CONFIG_DEFAULT)
      this._chart_config.data = {datasets: data.chartjs_datasets}
      this.chart_create()
    },
  },
}
</script>

<style lang="sass">
@import "./support.sass"

.STAGE-development
  .XyMasterChart
    border: 1px dashed change_color($primary, $alpha: 0.5)

.XyMasterChart
  .chart_box_container
    margin-top: $xy_master_common_gap

  .main_canvas
    margin: 0 auto
</style>
