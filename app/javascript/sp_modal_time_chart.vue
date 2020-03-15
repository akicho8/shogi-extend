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
    aspectRatio: 2, // 大きいほど横長方形になる

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
}

import sp_modal_time_chart_vline from './sp_modal_time_chart_vline.js'

export default {
  mixins: [
    sp_modal_time_chart_vline, // 縦線表示機能(コメントアウトでOFF)
  ],

  props: {
    record: { required: true, }, // バトル情報
    show_p: { required: true, }, // 時間チャートを表示する？
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
    this._chart_config.__record__ = this.record

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

            if (this.index_info_hash) {
              this._chart_config.index_info_hash = this.index_info_hash(time_chart_params)
            }

            this.xhr_counter = 0
            this.chart_create()
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
