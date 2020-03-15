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

    title: {
      display: false,
      text: "消費時間",
    },

    // https://qiita.com/Haruka-Ogawa/items/59facd24f2a8bdb6d369#3-5-%E6%95%A3%E5%B8%83%E5%9B%B3
    scales: {
      xAxes: [{
        scaleLabel: {
          display: false,
          labelString: "手数",
        },
        ticks: {
          minRotation: 0,   // 表示角度水平
          maxRotation: 0,   // 表示角度水平
          maxTicksLimit: 5, // 最大横N個の目盛りにする
          callback(value, index, values) { return value + "" }, // 単位をつける
        }
      }],
      yAxes: [{
        ticks: {
          stepSize: 30,         // N秒毎の表示
          maxTicksLimit: 7,     // 縦の最大目盛り数
          callback(value, index, values) { return Math.abs(value) +  "s" }, // 単位
        },
      }],
    },

    // https://tr.you84815.space/chartjs/configuration/tooltip.html
    legend: {
      display: false,
    },
    tooltips: {
      callbacks: {
        title(tooltipItems, data) {
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

          const x = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index].x           // 手数
          const t = Math.abs(data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index].y) // 秒数

          if (this._chart.config.__record__) {
            if (x > this._chart.config.__record__.turn_max) {
              return `時間切れ ${t}秒`
            }
          }

          // data.labels[tooltipItem.index]
          return `${x}手目 ${t}秒`
        },
      },
    },
  },

  // chart.js に縦線を入れる方法
  // https://stackoverflow.com/questions/30256695/chart-js-drawing-an-arbitrary-vertical-line
  plugins: [
    {
      // Plugin API
      // https://misc.0o0o.org/chartjs-doc-ja/developers/plugins.html
      afterDatasetsDraw(instance, easing) {
        if (instance.config.chart_turn != null) {
          this.vertical_line_render(instance, instance.config.chart_turn)
        }
      },

      // private methods

      line_position_get(instance, chart_turn) {
        const index_info = instance.config.index_info_hash[chart_turn]
        if (index_info) {
          const meta = instance.getDatasetMeta(index_info.datasetIndex)
          // meta:
          //   type: "line"
          //   data: Array(54)
          //     0: ChartElement
          //       _chart: Chart {id: 0, ctx: null, canvas: null, config: {…}, width: 828, …}
          //       _datasetIndex: 1
          //       _index: 0
          //       hidden: false
          //       _xScale: ChartElement {id: "x-axis-0", type: "category", options: {…}, ctx: CanvasRenderingContext2D, chart: Chart, …}
          //       _yScale: ChartElement {id: "y-axis-0", type: "linear", options: {…}, ctx: CanvasRenderingContext2D, chart: Chart, …}
          //       _options: {backgroundColor: "rgba(100.00%, 22.00%, 37.60%, 0.10)", borderColor: "rgba(100.00%, 22.00%, 37.60%, 0.60)", borderWidth: 1, hitRadius: 5, hoverBackgroundColor: undefined, …}
          //       _model: {x: 49.173176518192996, y: 133.96444444444444, skip: false, radius: 1.2, pointStyle: "circle", …}
          //       _view: {x: 49.173176518192996, y: 133.96444444444444, skip: false, radius: 1.2, pointStyle: "circle", …}
          //       _start: null
          //       __proto__: Element
          //     1: ChartElement {_chart: Chart, _datasetIndex: 1, _index: 1, hidden: false, _xScale: ChartElement, …}
          //     2: ChartElement {_chart: Chart, _datasetIndex: 1, _index: 2, hidden: false, _xScale: ChartElement, …}
          //     ...snip...
          //   dataset: ChartElement {_chart: Chart, _datasetIndex: 1, hidden: false, _scale: ChartElement, _children: Array(54), …}
          //   controller: ChartElement {chart: Chart, index: 1, _data: Array(54)}
          //   hidden: null
          //   xAxisID: "x-axis-0"
          //   yAxisID: "y-axis-0"
          //   $filler: {visible: true, fill: "origin", chart: Chart, el: ChartElement, boundary: {…}, …}
          const data = meta.data
          return data[index_info.index]._model.x
        }
      },

      vertical_line_render(instance, chart_turn) {
        const lineLeftOffset = this.line_position_get(instance, chart_turn)
        if (lineLeftOffset) {
          const scale = instance.scales['y-axis-0']
          const context = instance.chart.ctx

          // render vertical line
          context.beginPath()
          // context.strokeStyle = "hsla(204, 86%,  53%, 0.3)" // $cyan
          context.strokeStyle = "hsla(204, 86%,  53%, 0.3)" // $cyan
          context.moveTo(lineLeftOffset, scale.top)
          context.lineTo(lineLeftOffset, scale.bottom)
          context.stroke()

          // write label
          // context.fillStyle = "#ff0000"
          // context.textAlign = 'center'
          // context.fillText('MY TEXT', lineLeftOffset, (scale.bottom - scale.top) / 2 + scale.top)
        }
      },
    },
  ],
}

export default {
  props: {
    record: { required: true, }, // バトル情報
    show_p: { required: true, }, // 時間チャートを表示する？
    chart_turn: { required: false, },
  },

  data() {
    return {
      zoom_p: false,       // 拡大する？

                           // private
      _chart_config: null, // 現在表示しているチャートの設定(updateするとチャートの方もupdateで更新できる)
      xhr_counter: 0,      // 時間チャート用データを取得中なら1以上
      // time_chart_params: null,
    }
  },

  created() {
    this._chart_config = Object.assign({}, CHART_CONFIG_DEFAULT)

    // chart.js のインスタンスに他のデータを渡す
    // 予約キーと衝突しなかったら自由に引数を追加できる
    this._chart_config.chart_turn = this.chart_turn
    this._chart_config.__record__ = this.record
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
    show_p(v) {
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
      }
      window.chart_instance.update()
    },

    chart_turn(v, ov) {
      this.debug_alert(`watch chart_turn ${ov} => ${v}`)
      this._chart_config.chart_turn = v
      window.chart_instance.update()
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
            this._chart_config.data = data.time_chart_params
            this._chart_config.index_info_hash = this.index_info_hash(data.time_chart_params)

            this.xhr_counter = 0
            this.chart_create()
          })
        }
      }
    },

    // time_chart_params:
    //   labels: (5) [0, 1, 2, 3, 4]
    //   datasets[0]
    //     label: "devuser1"
    //     data[]
    //       0: {x: 1, y: +3}
    //       1: {x: 3, y: +2}
    //       ...
    //   datasets[1]
    //     label: "devuser2"
    //     data[]
    //       0: {x: 2, y: -3}
    //       1: {x: 4, y: -2}
    //
    // ↓変換
    //
    // {
    //   1 => {datasetIndex: 0, index: 0}
    //   2 => {datasetIndex: 1, index: 0} ← 2手目は datasetIndex が 1 つまり後手で、並びの 0 番目のデータを参照すればいいことがわかる
    //   3 => {datasetIndex: 0, index: 1}
    //   4 => {datasetIndex: 1, index: 1}
    // }
    //
    index_info_hash(time_chart_params) {
      const hash = {}
      time_chart_params.datasets.forEach((dataset, i) => {
        dataset.data.forEach((e, j) => {
          hash[e.x] = { datasetIndex: i, index: j }
        })
      })
      return hash
    },

    // 時間チャート表示
    chart_create() {
      this.chart_destroy()
      window.chart_instance = new Chart(this.$refs.chart_el, this._chart_config)
      this.$refs.chart_el.addEventListener("click", this.click_handle)
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
  },
}
</script>

<style lang="sass">
@import "./stylesheets/bulma_init.scss"

.sp_modal_time_chart
  margin-top: 0.15rem
  .bottom_buttons
</style>
