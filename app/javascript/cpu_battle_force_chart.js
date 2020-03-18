// CPU対戦の戦力グラフ

const CHART_TOP_PADDING_RATE = 1.0   // 評価値の上の隙間率(1.0〜1.5ぐらい1.0で無し)
const SUGGESTED_MAX_DEFAULT = 10000  // 評価値の初期値

const CHART_CONFIG_DEFAULT = {
  type: "line",

  data: {
    labels: [],
    datasets: [
      {
        label: "戦力グラフ",    // legend: true のときに表示するラベル
        data: [],
      },
    ],
  },

  options: {
    // サイズ
    aspectRatio: 3, // 大きいほど横長方形になる

    title: {
      display: true,
      text: "戦力グラフ",
    },

    elements: {
      // 共通設定
      line: {
        borderColor:     "hsla(204, 86%,  53%, 1.0)",
        backgroundColor: "hsla(204, 86%,  53%, 0.1)",
        fill: true,
        tension: 0,
      },
    },

    // https://qiita.com/Haruka-Ogawa/items/59facd24f2a8bdb6d369#3-5-%E6%95%A3%E5%B8%83%E5%9B%B3
    scales: {
      yAxes: [{
        display: true,
        ticks: {
          maxTicksLimit: 7,
        },
      }],
    },

    // https://tr.you84815.space/chartjs/chart_configuration/tooltip.html
    legend: {
      display: false,
    },
    tooltips: {
      displayColors: false,
      callbacks: {
        title(tooltipItems, data) {
          return ""
        },
        label(tooltipItem, data) {
          const e = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index]
          return e.y
        },
      },
    },
  },
}

export default {
  data() {
    return {
      chart_config: null,
      chart_instance: null,
      chart_value_max: null,
    }
  },

  created() {
    this.chart_config = CHART_CONFIG_DEFAULT
    this.chart_config_reset()
  },

  mounted() {
    this.chart_instance = new Chart(this.$refs.chart_canvas, this.chart_config)
    this.chart_click_handler_set()
  },

  methods: {
    // チャートクリック時にその手数に局面を変更する処理の登録
    chart_click_handler_set() {
      this.$refs.chart_canvas.addEventListener('click', event => {
        let item = this.chart_instance.getElementAtEvent(event)
        if (item.length >= 1) {
          item = item[0]
          let data = item._chart.config.data.datasets[item._datasetIndex].data[item._index]
          console.log(`Clicked at (${data.x}, ${data.y})`)
          if (this.mode === "standby") {
            this.$refs.sp_vm.api_board_turn_set(data.x)
          }
        }
      })
    },

    // 開始時の初期化
    chart_reset() {
      this.chart_config_reset()
      this.chart_instance.update()

      this.chart_value_max = 0
    },

    // 戦力情報の反映
    score_list_reflection(e) {
      if (e["score_list"]) {
        e["score_list"].forEach(e => {
          this.chart_config.data.labels.push(e.x)
          this.chart_config.data.datasets[0].data.push(e)
          const v = Math.abs(e.y)
          if (v > this.chart_value_max) {
            this.chart_value_max = v
          }
        })
        const ticks = this.chart_config.options.scales.yAxes[0].ticks
        const v = this.chart_value_max * CHART_TOP_PADDING_RATE
        if (false) {
          ticks.max = v
          ticks.min = -v
        } else {
          ticks.suggestedMax = v
          ticks.suggestedMin = -v
        }
        this.chart_instance.update()
      }
    },

    // private

    chart_config_reset() {
      this.chart_config.data.labels = []
      this.chart_config.data.datasets[0].data = []
      this.chart_config.options.scales.yAxes[0].ticks.suggestedMax = SUGGESTED_MAX_DEFAULT
      this.chart_config.options.scales.yAxes[0].ticks.suggestedMin = -SUGGESTED_MAX_DEFAULT
    },
  },
}
