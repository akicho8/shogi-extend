<template lang="pug">
.SwarsBattleShowTimeChart.is-unselectable
  .canvas_center
    .canvas_wrap
      canvas(ref="main_canvas")
  b-field(grouped position="is-centered")
    b-field.time_chart_variant
      template(v-for="e in TheShow.TimeChartVariantInfo.values")
        b-radio-button(:class="e.key" v-model="TheShow.time_chart_variant_key" :native-value="e.key" size="is-small" @input="time_chart_variant_key_change_handle") {{e.name}}
    b-field.time_chart_zoom
      template(v-for="e in TheShow.TimeChartZoomInfo.values")
        b-radio-button(:class="e.key" v-model="TheShow.time_chart_zoom_key" :native-value="e.key" size="is-small" @input="zoom_key_change_handle") {{e.name}}
</template>

<script>
const TOOLTIP_ENABLE = true
// const TICKS_FONT_COLOR = "hsla(0, 0%, 100%, 0.75)"
const TICKS_FONT_COLOR = "hsla(0, 0%, 0%, 0.75)"
const FONT_SIZE = 8

const CHART_CONFIG_DEFAULT = {
  type: "line",                 // barはデータ構造上うまくいかない
  options: {
    aspectRatio: 1.6, // 大きいほど横長方形になる

    // datasets 内に適応
    showLines: true,

    // nil のデータは飛ばしてつなげる
    // spanGaps: true,

    // https://www.chartjs.org/docs/latest/general/performance.html?h=animation
    //
    // これはどこで作用するのかよくわからないので保留
    // responsiveAnimationDuration: 0,
    //
    animation: {
      duration: 0, // チャートのY座標が反転する時間 (盤が回転する時間に合わせる)
    },

    title: {
      display: false,
      text: "消費時間",
    },

    layout: {
      padding: {
        // left:   25,
        // right:  30,
        // top:    50,
        // bottom: 25,
        left:   20,
        right:  25,
        top:    30,
        bottom: 16,
      },
    },

    // https://qiita.com/Haruka-Ogawa/items/59facd24f2a8bdb6d369#3-5-%E6%95%A3%E5%B8%83%E5%9B%B3
    // https://qiita.com/muuuuminn/items/2e977add604dcec920d3
    scales: {
      xAxes: [{
        // http://www.kogures.com/hitoshi/javascript/chartjs/bar-width.html
        // categoryPercentage: 1.0, // 目盛り線の幅に対する棒（複数棒）の占める幅の割合
        // barPercentage: 1.0,      // categoryPercentageに対する単独棒の幅。1にすると複数棒間間隔がなくなり、1より小さくすると棒が細くなり間隔が広がる
        // // minBarLength: 8,
        // // barThickness: "flex",
        // barThickness: 10,

        scaleLabel: {
          display: false,
          labelString: "手数",
        },
        ticks: {
          // 50ずつ表示したいけどできない。その理由↓
          // http://www.kogures.com/hitoshi/javascript/chartjs/scale.html
          // Ｙ軸と同様にＸ軸でも、Ｂのようにmin/maxの指定ができます。このときはsuggestedMin/suggestedMaxは使えませんし、stepSize も使えません（無視されます）。
          // その理由は、Ｘ軸のラベルは単なる文字列で数値のような大小関係を示していないからです。同様な機能は maxTicksLimit で設定します。

          minRotation: 0,   // 表示角度水平
          maxRotation: 0,   // 表示角度水平
          maxTicksLimit: 5, // 最大横N個の目盛りにする
          // callback(value, index, values) { return value + "" }, // 単位をつける
          fontColor: TICKS_FONT_COLOR,
          fontSize: FONT_SIZE,
        },
        gridLines: {
          display: true,    // x軸の中間の縦線
          offsetGridLines: false,
        },
      }],
      yAxes: [{
        ticks: {
          fontSize: FONT_SIZE,
          fontColor: TICKS_FONT_COLOR,
          reverse: false,       // 反転する？ (this.TheShow.viewpoint を 外から設定して判定する)

          stepSize: 30,         // N秒毎の表示
          maxTicksLimit: 7,     // 縦の最大目盛り数
          callback(value, index, values) {

            // this:
            //   ChartElement
            //   id: "y-axis-0"
            //   type: "linear"
            //   options: {display: true, position: "left", offset: false, gridLines: {…}, scaleLabel: {…}, …}
            //   ctx: CanvasRenderingContext2D {canvas: canvas.chartjs-render-monitor, globalAlpha: 1, globalCompositeOperation: "source-over", filter: "none", imageSmoothingEnabled: true, …}
            //   chart: Chart {id: 0, ctx: CanvasRenderingContext2D, canvas: canvas.chartjs-render-monitor, config: {…}, width: 695, …}
            //   hidden: false
            //   fullWidth: false
            //   position: "left"
            //   weight: 0
            //   _layers: ƒ ()
            //   maxWidth: 347.5
            //   maxHeight: 347
            //   margins: {left: 0, right: 0, top: 0, bottom: 0}
            //   _ticks: (7) [{…}, {…}, {…}, {…}, {…}, {…}, {…}]
            //   ticks: (7) [60, 30, 0, -30, -60, -90, -120]
            //   _labelSizes: null
            //   _maxLabelLines: 0
            //   longestLabelWidth: 0
            //   longestTextCache: {}
            //   _gridLineItems: null
            //   _labelItems: null
            //   height: 347
            //   top: 0
            //   bottom: 347
            //   paddingLeft: 0
            //   paddingTop: 0
            //   paddingRight: 0
            //   paddingBottom: 0
            //   min: -120
            //   max: 60
            //   start: -120
            //   end: 60
            //   ticksAsNumbers: (7) [60, 30, 0, -30, -60, -90, -120]
            //   zeroLineIndex: 2
            //   __proto__: ChartElement

            return this.chart.config.__vm__.second_to_human(value)
          },
        },
        gridLines: {
          display: true,
          offsetGridLines: false,
          // zeroLineWidth: 0,
        },
      }],
    },

    // elements: {
    //   line: {
    //     fill: true,
    //     // 折れ線グラフのすべてに線に適用する設定なのでこれがあると dataset 毎に設定しなくてよい
    //     // または app/javascript/packs/application.js で指定する
    //     // background-color
    //     tension: 0,
    //     backgroundColor: function(context) { return color_select(context, 0.3) },
    //     borderColor:     function(context) { return color_select(context, 1.0) },
    //     borderWidth: 1,
    //   },
    //   point: {
    //     backgroundColor: function(context) { return color_select(context, 0.3) },
    //     borderColor:     function(context) { return color_select(context, 1.0) },
    //   },
    // },

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
      enabled: TOOLTIP_ENABLE,
      mode: "index",        // マウスに対してツールチップが出る条件
      intersect: false, // Y座標のチェックは無視する

      displayColors: false, // 左に「■」を表示するか？

      // yAlign: 'bottom', // 下側にキャロットがでるようにする。マニュアルに載ってない。https://stackoverflow.com/questions/44050238/change-chart-js-tooltip-caret-position

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

          // this:
          //   ChartElement {_chart: Chart, _chartInstance: Chart, _data: {…}, _options: {…}, _model: {…}, …}
          //   _chart: Chart {id: 0, ctx: CanvasRenderingContext2D, canvas: canvas.chartjs-render-monitor, config: {…}, width: 457, …}
          //   _chartInstance: Chart {id: 0, ctx: CanvasRenderingContext2D, canvas: canvas.chartjs-render-monitor, config: {…}, width: 457, …}
          //   _data: {labels: Array(109), datasets: Array(2)}
          //   _options: {enabled: true, custom: null, mode: "nearest", position: "average", intersect: true, …}
          //   _model: {xPadding: 6, yPadding: 6, xAlign: "center", yAlign: "top", bodyFontColor: "#fff", …}
          //   _lastActive: [ChartElement]
          //   _view: {xPadding: 6, yPadding: 6, xAlign: undefined, yAlign: undefined, bodyFontColor: "#fff", …}
          //   _start: {}
          //   _active: [ChartElement]
          //   _eventPosition: {x: 404, y: 9}

          // tooltipItem:
          //   xLabel: "49"
          //   yLabel: 58
          //   label: "49"
          //   value: "58"
          //   index: 48
          //   datasetIndex: 0
          //   x: 729.1057807074653
          //   y: 10.19555555555553

          // tooltipItem: 1手目
          //   xLabel: "1"
          //   yLabel: 0
          //   label: "1"
          //   value: "0"
          //   index: 0
          //   datasetIndex: 0
          //   x: 42.0159912109375
          //   y: 131.86666666666667

          // data.datasets[0].data:
          //   [0] {x: 1, y: 0}
          //   [1] {x: 3, y: 2}
          //   [2] {x: 5, y: 1}
          //

          const xy_info = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index]

          let s = chart_element._chart.config.__vm__.second_to_human(xy_info.y)

          if (__vm__.development_p) {
            s = `(${xy_info.x}, ${xy_info.y}) ${s}`
          }

          if (__vm__.TheShow.record) {
            if (xy_info.x > __vm__.TheShow.record.turn_max) {
              return `${s} (時間切れ)`
            }
          }

          // data.labels[tooltipItem.index]
          // return `#${x} ${t}s`
          return s
        },
      },
    },

    // スマホで touchmove すると動きすぎてしまう場合は touchmove を外す
    // https://www.chartjs.org/docs/latest/general/interactions/events.html
    // events: [
    //   "mousemove",
    //   "mouseout",
    //   "click",
    //   "touchstart",
    //   "touchmove",
    // ],

    // // 点の上を通過したとき
    // onHover(event, chart_elements) {
    //   // console.log("chart_elements", chart_elements)
    //   // 0: ChartElement {_chart: Chart, _datasetIndex: 1, _index: 7, hidden: false, _xScale: ChartElement, …}
    //   //     _chart: Chart {id: 0, ctx: CanvasRenderingContext2D, canvas: canvas.chartjs-render-monitor, config: {…}, width: 375, …}
    //   //     _datasetIndex: 1
    //   //     _index: 8
    //   //     hidden: false
    //   //     _xScale: ChartElement {id: "x-axis-0", type: "category", options: {…}, ctx: CanvasRenderingContext2D, chart: Chart, …}
    //   //     _yScale: ChartElement {id: "y-axis-0", type: "linear", options: {…}, ctx: CanvasRenderingContext2D, chart: Chart, …}
    //   //     _options: {backgroundColor: "rgba(100.00%, 22.00%, 37.60%, 0.10)", borderColor: "rgba(100.00%, 22.00%, 37.60%, 0.60)", borderWidth: 1, hitRadius: 1, hoverBackgroundColor: undefined, …}
    //   //     _model: {x: 303.571048874628, y: 77.032, skip: false, radius: 1.2, pointStyle: "circle", …}
    //   //     _view: {x: 303.571048874628, y: 77.032, skip: false, radius: 1.2, pointStyle: "circle", …}
    //   //     _start: null
    //
    //   // 第二引数から取れるものと同じ
    //   if (false) {
    //     const chart_elements2 = this.getElementAtEvent(event)
    //     console.log(chart_elements2)
    //   }
    //
    //   const chart_instance = this
    //   const __vm__ = chart_instance.config.__vm__
    //   __vm__.clog("onHover", "chart_elements.length", chart_elements.length)
    //
    //   if (chart_elements.length >= 1) {
    //     const chart_element = chart_elements[0]
    //     const datasets = chart_element._chart.config.data.datasets
    //     const xy_info = datasets[chart_element._datasetIndex].data[chart_element._index]
    //     chart_instance.config.__last_xy_info__ = xy_info
    //   }
    // },

    // 点をクリックしたとき
    onClick(event, chart_elements) {
      const chart_instance = this
      const __vm__ = chart_instance.config.__vm__
      __vm__.clog("onClick", "chart_elements.length", chart_elements.length)
      let xy_info = null

      // 点にホバーできている状態でクリックしたらその点を使う
      if (chart_elements.length >= 1) {
        const chart_element = chart_elements[0]
        const datasets = chart_element._chart.config.data.datasets
        xy_info = datasets[chart_element._datasetIndex].data[chart_element._index]
      } else {
        // 点にホバーできていないときは onHover で前回マッチした点を使う
        xy_info = chart_instance.config.__last_xy_info__
      }
      // その手数に移動する
      if (xy_info) {
        __vm__.api_board_turn_set(xy_info.x)
      }

      // console.log(this)
      //   Chart
      //   data: (...)
      //   id: 0
      //   ctx: CanvasRenderingContext2D {canvas: canvas.chartjs-render-monitor, globalAlpha: 1, globalCompositeOperation: "source-over", filter: "none", imageSmoothingEnabled: true, …}
      //   canvas: canvas.chartjs-render-monitor
      //   config: {type: "line", options: {…}, __vm__: VueComponent, plugins: Array(1), chart_turn: 9, …}
      //   width: 375
      //   height: 187
      //   aspectRatio: 1.618
      //   options: {defaultColor: "hsla(0, 0%, 0%, 0.1)", defaultFontColor: "#666", defaultFontFamily: "'Helvetica Neue', 'Helvetica', 'Arial', sans-serif", defaultFontSize: 12, defaultFontStyle: "normal", …}
      //   _bufferedRender: false
      //   _layers: (4) [{…}, {…}, {…}, {…}]
      //   chart: Chart {id: 0, ctx: CanvasRenderingContext2D, canvas: canvas.chartjs-render-monitor, config: {…}, width: 375, …}
      //   controller: Chart {id: 0, ctx: CanvasRenderingContext2D, canvas: canvas.chartjs-render-monitor, config: {…}, width: 375, …}
      //   boxes: (4) [ChartElement, ChartElement, ChartElement, ChartElement]
      //   legend: ChartElement {ctx: CanvasRenderingContext2D, options: {…}, chart: Chart, legendHitBoxes: Array(0), _hoveredItem: null, …}
      //   titleBlock: ChartElement {ctx: CanvasRenderingContext2D, options: {…}, chart: Chart, legendHitBoxes: Array(0), fullWidth: true, …}
      //   currentDevicePixelRatio: 2
      //   _listeners: {mousemove: ƒ, mouseout: ƒ, click: ƒ, touchstart: ƒ, touchmove: ƒ, …}
      //   tooltip: ChartElement {_chart: Chart, _chartInstance: Chart, _data: {…}, _options: {…}, _model: {…}, …}
      //   scales: {x-axis-0: ChartElement, y-axis-0: ChartElement}
      //   chartArea: {left: 41.103994140625, top: 7.199999999999999, right: 365.3280029296875, bottom: 156.83999999999997}
      //   lastActive: []
      //   animating: false
      //   _bufferedRequest: null
      //   active: []
      //   $plugins: {descriptors: Array(5), id: 4}
      //   get data: ƒ ()
      //   set data: ƒ (value)
      //   __proto__: Object

      // console.log("chart_elements", chart_elements)
      //   0: ChartElement {_chart: Chart, _datasetIndex: 1, _index: 7, hidden: false, _xScale: ChartElement, …}
      //       _chart: Chart {id: 0, ctx: CanvasRenderingContext2D, canvas: canvas.chartjs-render-monitor, config: {…}, width: 375, …}
      //       _datasetIndex: 1
      //       _index: 8
      //       hidden: false
      //       _xScale: ChartElement {id: "x-axis-0", type: "category", options: {…}, ctx: CanvasRenderingContext2D, chart: Chart, …}
      //       _yScale: ChartElement {id: "y-axis-0", type: "linear", options: {…}, ctx: CanvasRenderingContext2D, chart: Chart, …}
      //       _options: {backgroundColor: "rgba(100.00%, 22.00%, 37.60%, 0.10)", borderColor: "rgba(100.00%, 22.00%, 37.60%, 0.60)", borderWidth: 1, hitRadius: 1, hoverBackgroundColor: undefined, …}
      //       _model: {x: 303.571048874628, y: 77.032, skip: false, radius: 1.2, pointStyle: "circle", …}
      //       _view: {x: 303.571048874628, y: 77.032, skip: false, radius: 1.2, pointStyle: "circle", …}
      //       _start: null
    },
  },
}

import SwarsBattleShowTimeChartVerticalLine from './SwarsBattleShowTimeChartVerticalLine.js'
import { PaletteInfo } from "@/components/models/palette_info.js"
import chart_mixin from '@/components/models/chart_mixin.js'

export default {
  name: "SwarsBattleShowTimeChart",
  mixins: [
    SwarsBattleShowTimeChartVerticalLine, // 縦線表示機能(コメントアウトでOFF)
    chart_mixin,
  ],
  inject: ["TheShow"],
  created() {
    this.chart_setup_all()
  },
  mounted() {
    this.chart_create()
    this.zoom_key_change()
  },
  watch: {
    "TheShow.viewpoint": {
      handler(v, ov) {
        this.debug_alert(`TheShow.viewpoint: ${ov} -> ${v}`)
        this.chart_flip_set()
        this.chart_update()
      },
    },
  },
  methods: {
    chart_setup_all() {
      this.chart_setup(CHART_CONFIG_DEFAULT)
      this._chart_config.data = this.TheShow.current_source
      // this._chart_config.my_custom_background_color = "hsla(0, 0%, 0%, 0.75)"
      // this._chart_config.my_custom_background_color = "rgba(#C6E1B8, 0.1)"

      this.chart_flip_set()

      // N手目はdatasets配列のどの要素を見るかすぐにわかるテーブルを作成する
      // if (this.index_info_hash) {
      //   this._chart_config.index_info_hash = this.index_info_hash(TheShow.time_chart_params)
      // }

      if (this.vline_setup) {
        this.vline_setup()
      }
    },

    // chart.js の方でイベントフックがあってそっちを使っているので、こっちは使うのをやめた
    //
    // 1. マウスに対応する、Y軸を無視した点の配列ががあればその中央の値の手数を使う
    // 2. その配列がなければ、前回表示したツールチップの手数を使う
    click_handle(event) {
      alert("click_handle")

      this.debug_alert("click_handle")

      if (this.development_p) {
        console.log(window.chart_instance.getElementsAtEvent(event))
        console.log(window.chart_instance.getElementAtEvent(event))
        console.log(window.chart_instance.getDatasetAtEvent(event))
        console.log(window.chart_instance.getDatasetMeta(0))
        console.log(window.chart_instance)
        // Chart {id: 0, ctx: CanvasRenderingContext2D, canvas: canvas.chartjs-render-monitor, config: {…}, width: 375, …}
        // data: (...)
        // id: 0
        // ctx: CanvasRenderingContext2D {canvas: canvas.chartjs-render-monitor, globalAlpha: 1, globalCompositeOperation: "source-over", filter: "none", imageSmoothingEnabled: true, …}
        // canvas: canvas.chartjs-render-monitor
        // config: {type: "line", options: {…}, __vm__: VueComponent, plugins: Array(1), chart_turn: 34, …}
        // width: 375
        // height: 187
        // aspectRatio: 1.618
        // options: {defaultColor: "hsla(0, 0%, 0%, 0.1)", defaultFontColor: "#666", defaultFontFamily: "'Helvetica Neue', 'Helvetica', 'Arial', sans-serif", defaultFontSize: 12, defaultFontStyle: "normal", …}
        // _bufferedRender: false
        // _layers: (4) [{…}, {…}, {…}, {…}]
        // : Chart {id: 0, ctx: CanvasRenderingContext2D, canvas: canvas.chartjs-render-monitor, config: {…}, width: 375, …}
        // controller: Chart {id: 0, ctx: CanvasRenderingContext2D, canvas: canvas.chartjs-render-monitor, config: {…}, width: 375, …}
        // boxes: (4) [ChartElement, ChartElement, ChartElement, ChartElement]
        // legend: ChartElement {ctx: CanvasRenderingContext2D, options: {…}, chart: Chart, legendHitBoxes: Array(0), _hoveredItem: null, …}
        // titleBlock: ChartElement {ctx: CanvasRenderingContext2D, options: {…}, chart: Chart, legendHitBoxes: Array(0), fullWidth: true, …}
        // currentDevicePixelRatio: 2
        // _listeners: {mousemove: ƒ, mouseout: ƒ, click: ƒ, touchstart: ƒ, touchmove: ƒ, …}
        // tooltip: ChartElement {_chart: Chart, _chartInstance: Chart, _data: {…}, _options: {…}, _model: {…}, …}
        // scales: {x-axis-0: ChartElement, y-axis-0: ChartElement}
        // $plugins: {descriptors: Array(5), id: 4}
        // chartArea: {left: 59.7759912109375, top: 7.199999999999999, right: 361.99200439453125, bottom: 156.83999999999997}
        // lastActive: (2) [ChartElement, ChartElement]
        // animating: false
        // _bufferedRequest: null
        // active: (2) [ChartElement, ChartElement]
        // get data: ƒ ()
        // set data: ƒ (value)

        // lastActive: Array(2)
        // 0: ChartElement
        //   _chart: Chart {id: 0, ctx: CanvasRenderingContext2D, canvas: canvas.chartjs-render-monitor, config: {…}, width: 375, …}
        //   _datasetIndex: 0
        //   _index: 17
        //   hidden: false
        //   _xScale: ChartElement {id: "x-axis-0", type: "category", options: {…}, ctx: CanvasRenderingContext2D, chart: Chart, …}
        //   _yScale: ChartElement {id: "y-axis-0", type: "linear", options: {…}, ctx: CanvasRenderingContext2D, chart: Chart, …}
        //   _options: {backgroundColor: "rgba(12.58%, 61.08%, 93.42%, 0.10)", borderColor: "rgba(12.58%, 61.08%, 93.42%, 0.60)", borderWidth: 1, hitRadius: 1, hoverBackgroundColor: undefined, …}
        //   _model: {x: 154.9180694354022, y: 55.41733333333332, skip: false, radius: 5, pointStyle: "circle", …}
        //   _view: {x: 154.9180694354022, y: 55.41733333333332, skip: false, radius: 5, pointStyle: "circle", …}
        //   _start: null
        //   $previousStyle: {backgroundColor: "rgba(12.58%, 61.08%, 93.42%, 0.10)", borderColor: "rgba(12.58%, 61.08%, 93.42%, 0.60)", borderWidth: 1, radius: 1.2}
        //   __proto__: Element
        //
        // 1: ChartElement {_chart: Chart, _datasetIndex: 1, _index: 17, hidden: false, _xScale: ChartElement, …}
        //   length: 2
      }

      // Y軸はどこでもいいとする場合はアクティブになっている点を取得する
      // ただし、これは public API なのか怪しい
      if (true) {
        const datasets = window.chart_instance.data.datasets        // 実データ
        const lastActive = window.chart_instance.lastActive         // 最後にアクセスした点の配列(公開APIなのか不明)
        const __last_xy_info__ = window.chart_instance.config.__last_xy_info__  // 前回表示したツールチップでの手数

        if (lastActive.length === 0) {
          // this.debug_alert(`lastActiveが空なので __last_xy_info__(${__last_xy_info__}) を使う`)
          if (__last_xy_info__ != null) {
            this.api_board_turn_set(__last_xy_info__)
          }
        }

        if (lastActive.length >= 1) {
          const x_list   = lastActive.map(e => datasets[e._datasetIndex].data[e._index].x)  // [2, 3, 4, 5, 6]
          const x_total  = x_list.reduce((a, e) => a + e, 0)                                // [2, 3, 4, 5, 6].sum
          const x_center = Math.floor(x_total / x_list.length)                              // 4

          if (this.development_p) {
            // datasets[0] -> datasets[1] の順でマッチしたポイントが並んでいることがわかる(←これはどうでもいい)
            // 5つぐらいにマッチしたとき 2 3 4 5 6 手の順で並んでいるように見れるが、法則はよくわからない
            // ということは 2,3,4,5,6 の平均のところを中心と考えるのがいいのではないか？
            console.log("マッチした手数のリスト", x_list)
            console.log("マッチした手数の合計", x_total)
            console.log("マッチした手数の中央", x_center)
          }

          this.api_board_turn_set(x_center)
        }
      }

      // getElementAtEvent を使うとイベントから点に変換できる
      // しかし点にマウスが完全に重なっているときにしかこの方法は使えない
      if (false) {
        const chart_elements = window.chart_instance.getElementAtEvent(event)
        if (chart_elements.length == 0) {
          return
        }
        const chart_element = chart_elements[0]
        const data = chart_element._chart.config.data.datasets[chart_element._datasetIndex].data[chart_element._index]
        if (this.development_p) {
          console.log(`click_handle: (${chart_element._index}, ${data.x}, ${data.y})`)
        }
        this.api_board_turn_set(data.x)
      }
    },

    // 盤面の手数を変更
    api_board_turn_set(turn) {
      this.sfx_play_click()

      if (turn > this.TheShow.record.turn_max) {
        this.$emit("update:turn", this.TheShow.record.turn_max)
        // this.simple_notify("時間切れ")
        return
      }

      this.$emit("update:turn", turn)
      // this.simple_notify(`${turn}手目`)
    },

    // flip 状態をチャートに反映
    chart_flip_set() {
      this._chart_config.options.scales.yAxes[0].ticks.reverse = (this.TheShow.viewpoint === "white")
    },

    // 61 -> 1分1秒
    second_to_human(v) {
      const t = Math.abs(v)
      const min = Math.floor(t / 60)
      const sec = t % 60
      let s = ""
      if (t === 0) {
        s += "0"
      } else {
        if (min >= 1) {
          s += `${min}m`
        }
        if (sec >= 1) {
          s += `${sec}s`
        }
      }
      return s
    },

    // 拡縮を変更したときに呼ぶ
    zoom_key_change_handle() {
      this.sfx_play_click()
      this.zoom_key_change()
    },
    zoom_key_change() {
      if (this.TheShow.time_chart_zoom_info.key === "zoom_plus") {
        // 拡大
        const ticks = this._chart_config.options.scales.yAxes[0].ticks
        const seconds = 5       // 範囲秒数
        ticks.min = -seconds
        ticks.max = +seconds
        ticks.maxTicksLimit = 12
        ticks.stepSize = 1
      } else {
        // 元に戻す
        this._chart_config.options.scales.yAxes[0] = Object.assign({}, CHART_CONFIG_DEFAULT.options.scales.yAxes[0])
        this.chart_flip_set()
      }
      this.chart_update()
    },

    // チャートの種類を変更したときに呼ぶ
    time_chart_variant_key_change_handle() {
      this.sfx_play_click()
      this.TheShow.time_chart_zoom_key = "zoom_minus"
      this.chart_setup_all()
      this.chart_create()
    },
  },
}
</script>

<style lang="sass">
.SwarsBattleShowTimeChart
  padding-bottom: 1.5rem
  .canvas_center
    display: flex
    justify-content: center
    align-items: center
    .canvas_wrap
      width: 100%
      max-width: 640px
  .time_chart_variant
    label.radio
      width: 5rem
  .time_chart_zoom
    label.radio
      width: 3rem

.STAGE-development
  .SwarsBattleShowTimeChart
    .zoom_button
      border: 1px dashed change_color($primary, $alpha: 0.2)
</style>
