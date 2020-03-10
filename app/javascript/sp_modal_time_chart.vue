<template lang="pug">
  .sp_modal_time_chart.is-unselectable(v-show="show_p")
    canvas#chart_el(ref="chart_el")
    .bottom_buttons.has-text-centered
      b-switch(v-model="zoom_p" size="is-small")
        b-icon(icon="magnify-plus-outline" size="is-small")
</template>

<script>

const CHART_CONFIG_DEFAULT = {
  type: "line",
  options: {
    aspectRatio: 1.5, // 大きいほど横長方形になる

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
      }]
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
          return [
            // data.labels[tooltipItem.index]
            data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index].x, "手目",
            " ",
            Math.abs(data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index].y), "秒",
          ].join("")
        },
      },
    },
  },
}

export default {
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
    }
  },

  created() {
    this._chart_config = Object.assign({}, CHART_CONFIG_DEFAULT)
  },

  watch: {
    // 時間チャートスイッチ ON / OFF
    // 1回目 _chart_config.data がないので xhr で取得
    // 2回目 _chart_config.data があるのでそのまま表示
    show_p(v) {
      if (v) {
        if (this._chart_config.data) {
          this.chart_show()
        } else {
          if (this.xhr_counter == 0) {
            this.xhr_counter += 1
            this.http_get_command(this.record.show_path, { time_chart_fetch: true }, data => {
              this._chart_config.data = data.time_chart_params

              this.xhr_counter = 0
              this.chart_show()
            })
          }
        }
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

  methods: {
    // 時間チャート表示
    chart_show() {
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
      let item = window.chart_instance.getElementAtEvent(event)
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
      this.$emit("update:turn", turn)
      this.simple_notify(`${turn}手目`)
    },
  },
}
</script>

<style lang="sass">
@import "./stylesheets/bulma_init.scss"

.sp_modal_time_chart
  margin-top: 1rem
  .bottom_buttons
</style>
