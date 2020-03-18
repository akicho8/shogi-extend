<template lang="pug">
  .columns.is-centered.is-unselectable.sp_modal_time_chart(v-show="show_p")
    .column.is-half
      canvas#chart_el(ref="chart_el")
      .bottom_buttons.has-text-centered
        b-switch(v-model="zoom_p" size="is-small")
          b-icon(icon="magnify-plus-outline" size="is-small")
</template>

<script>

const CHART_CONFIG_DEFAULT = {
  type: "line",
  options: {
    aspectRatio: 2.0, // 大きいほど横長方形になる

    // datasets 内に適応
    showLines: true,

    // https://www.chartjs.org/docs/latest/general/performance.html?h=animation
    //
    // これはどこで作用するのかよくわからないので保留
    // responsiveAnimationDuration: 0,
    //
    animation: {
      duration: 400, // チャートのY座標が反転する時間 (盤が回転する時間に合わせる)
    },

    title: {
      display: false,
      text: "消費時間",
    },

    // https://qiita.com/Haruka-Ogawa/items/59facd24f2a8bdb6d369#3-5-%E6%95%A3%E5%B8%83%E5%9B%B3
    // https://qiita.com/muuuuminn/items/2e977add604dcec920d3
    scales: {
      xAxes: [{
        scaleLabel: {
          display: false,
          labelString: "手数",
        },
        ticks: {
          // FIXME: 50ずつ表示したい
          minRotation: 0,   // 表示角度水平
          maxRotation: 0,   // 表示角度水平
          maxTicksLimit: 5, // 最大横N個の目盛りにする
          callback(value, index, values) { return value + "" }, // 単位をつける
        },
        gridLines: {
          display: false,    // x軸の中間の縦線
        },
      }],
      yAxes: [{
        ticks: {
          reverse: false,       // 反転する？ (this.flip を 外から設定して判定する)

          stepSize: 30,         // N秒毎の表示
          maxTicksLimit: 7,     // 縦の最大目盛り数
          callback(value, index, values) {

            // this:
            //   ChartElement
            //   id: "y-axis-0"
            //   type: "linear"
            //   options: {display: true, position: "left", offset: false, gridLines: {…}, scaleLabel: {…}, …}
            //   ctx: CanvasRenderingContext2D {canvas: canvas#chart_el.chartjs-render-monitor, globalAlpha: 1, globalCompositeOperation: "source-over", filter: "none", imageSmoothingEnabled: true, …}
            //   chart: Chart {id: 0, ctx: CanvasRenderingContext2D, canvas: canvas#chart_el.chartjs-render-monitor, config: {…}, width: 695, …}
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
      mode: "x",            // マウスに対して点が強調される条件 X軸にマッチしたら点を強調する https://www.chartjs.org/docs/latest/general/interactions/modes.html#interaction-modes
      intersect: false,     // Y座標のチェックは無視する
      animationDuration: 0, // デフォルト400
    },

    // https://www.chartjs.org/docs/latest/configuration/tooltip.html#external-custom-tooltips
    tooltips: {
      mode: "x",        // マウスに対してツールチップが出る条件
      intersect: false, // Y座標のチェックは無視する

      displayColors: false, // 左に「■」を表示するか？

      callbacks: {
        title(tooltipItems, data) {
          return ""
        },
        beforeLabel(tooltipItems, data) {
          return ""
        },
        label(tooltipItem, data) {
          // this:
          //   ChartElement {_chart: Chart, _chartInstance: Chart, _data: {…}, _options: {…}, _model: {…}, …}
          //   _chart: Chart {id: 0, ctx: CanvasRenderingContext2D, canvas: canvas#chart_el.chartjs-render-monitor, config: {…}, width: 457, …}
          //   _chartInstance: Chart {id: 0, ctx: CanvasRenderingContext2D, canvas: canvas#chart_el.chartjs-render-monitor, config: {…}, width: 457, …}
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

          const e = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index]
          const s = this._chart.config.__vm__.second_to_human(e.y)

          if (this._chart.config.__vm__.record) {
            if (e.x > this._chart.config.__vm__.record.turn_max) {
              return `${s} (時間切れ)`
            }
          }
          // data.labels[tooltipItem.index]
          // return `#${x} ${t}s`
          return s
        },
      },
    },
  },
}

import sp_modal_time_chart_vline from './sp_modal_time_chart_vline.js'
import PaletteInfo from './palette_info.js'

export default {
  mixins: [
    sp_modal_time_chart_vline, // 縦線表示機能(コメントアウトでOFF)
  ],

  props: {
    record: { required: true, }, // バトル情報
    show_p: { required: true, }, // 時間チャートを表示する？
    flip:   { required: true, }, // フリップしたか？
  },

  data() {
    return {
      zoom_p: false,       // 拡大する？

                           // private
      _chart_config: null, // 現在表示しているチャートの設定(updateするとチャートの方もupdateで更新できる)
      xhr_counter: 0,      // 時間チャート用データを取得中なら1以上
    }
  },

  created() {
    this._chart_config = Object.assign({}, CHART_CONFIG_DEFAULT)

    // chart.js のインスタンスに他のデータを渡す
    // 予約キーと衝突しなかったら自由に引数を追加できる
    this._chart_config.__vm__ = this

    if (this.vline_setup) {
      this.vline_setup()
    }
  },

  watch: {
    record(v) {
      alert("レコードが切り替わったときにチャートONなら表示する、としたいのになんで呼ばれんの？")
      if (this.show_p) {
        this.chart_show()
      }
    },

    // 時間チャートスイッチ ON / OFF
    // 1回目 _chart_config.data がないので xhr で取得
    // 2回目 _chart_config.data があるのでそのまま表示
    show_p(v, ov) {
      this.debug_alert(`show_p: ${ov} -> ${v}`)
      if (v) {
        this.chart_show()
      } else {
        this.chart_destroy()
      }
    },

    zoom_p(v) {
      if (v) {
        // 拡大
        const ticks = this._chart_config.options.scales.yAxes[0].ticks
        const seconds = 10
        ticks.min = -seconds
        ticks.max = +seconds
        ticks.maxTicksLimit = 5
        ticks.stepSize = 1
      } else {
        // 元に戻す
        this._chart_config.options.scales.yAxes[0] = Object.assign({}, CHART_CONFIG_DEFAULT.options.scales.yAxes[0])
        this.chart_flip_set()
      }
      this.chart_update()
    },

    flip(v, ov) {
      this.debug_alert(`flip: ${ov} -> ${v}`)
      this.chart_flip_set()
      this.chart_update()
    },
  },

  beforeDestroy() {
    this.chart_destroy()
  },

  computed: {
  },

  methods: {
    chart_show() {
      if (this._chart_config.data) {
        this.chart_create()
      } else {
        if (this.xhr_counter == 0) {
          this.xhr_counter += 1
          this.http_get_command(this.record.show_path, { time_chart_fetch: true }, data => {
            const time_chart_params = data.time_chart_params

            this._chart_config.data = time_chart_params
            this.chart_flip_set()

            // N手目はdatasets配列のどの要素を見るかすぐにわかるテーブルを作成する
            if (this.index_info_hash) {
              this._chart_config.index_info_hash = this.index_info_hash(time_chart_params)
            }

            this.chart_create()

            this.xhr_counter = 0
          })
        }
      }
    },

    // 時間チャート表示
    chart_create() {
      this.chart_destroy()
      window.chart_instance = new Chart(this.$refs.chart_el, this._chart_config)
      this.$refs.chart_el.addEventListener("click", this.click_handle)
    },

    // 時間チャート更新
    chart_update() {
      if (window.chart_instance) {
        window.chart_instance.update()
      }
    },

    // 時間チャート非表示
    chart_destroy() {
      if (window.chart_instance) {
        this.$refs.chart_el.removeEventListener('click', this.click_handle)

        window.chart_instance.destroy()
        window.chart_instance = null
      }
    },

    // 点をタップしたとき盤面の手数を変更
    click_handle(event) {
      let item = window.chart_instance.getElementAtEvent(event) // FIXME: chart_instance は event または this に入っているはず
      if (item.length == 0) {
        return
      }
      item = item[0]
      const data = item._chart.config.data.datasets[item._datasetIndex].data[item._index]
      if (this.development_p) {
        console.log(`click_handle: (${item._index}, ${data.x}, ${data.y})`)
      }
      this.api_board_turn_set(data.x)
    },

    // 盤面の手数を変更
    api_board_turn_set(turn) {
      if (turn > this.record.turn_max) {
        this.$emit("update:turn", this.record.turn_max)
        this.simple_notify("時間切れ")
        return
      }

      this.$emit("update:turn", turn)
      this.simple_notify(`${turn}手目`)
    },

    // flip 状態をチャートに反映
    chart_flip_set() {
      this._chart_config.options.scales.yAxes[0].ticks.reverse = this.flip
    },

    second_to_human(v) {
      const t = Math.abs(v)
      const min = Math.floor(t / 60)
      const sec = t % 60
      let s = ""
      if (t === 0) {
        s += "0"
      } else {
        if (min >= 1) {
          s += `${min}分`
        }
        if (sec >= 1) {
          s += `${sec}秒`
        }
      }
      return s
    },
  },
}
</script>

<style lang="sass">
@import "./stylesheets/bulma_init.scss"

.sp_modal_time_chart
  margin-top: 0.15rem
  .bottom_buttons
</style>
