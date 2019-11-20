// CPU対戦の戦力グラフ

const CHART_TOP_PADDING_RATE = 1.0   // 評価値の上の隙間率(1.0〜1.5ぐらい1.0で無し)
const SUGGESTED_MAX_DEFAULT = 10000  // 評価値の初期値

const CHART_CONFIG_DEFAULT = {
  type: "line",

  data: {
    labels: [],
    datasets: [
      {
        label: "戦力グラフ",
        data: [],
        borderColor:     "hsla(204, 86%,  53%, 1.0)",
        backgroundColor: "hsla(204, 86%,  53%, 0.1)",
        fill: true,
      },
    ],
  },

  options: {
    title: {
      display: true,
      text: "戦力グラフ",
    },

    elements: {
      line: {
        tension: 0.0, // disables bezier curves (https://www.chartjs.org/docs/latest/charts/line.html#disable-bezier-curves)
      },
    },

    // // https://qiita.com/Haruka-Ogawa/items/59facd24f2a8bdb6d369#3-5-%E6%95%A3%E5%B8%83%E5%9B%B3
    scales: {
      // xAxes: [{
      //   scaleLabel: {
      //     display: true,
      //     labelString: "手数",
      //   },
      //   // ticks: {
      //   //   // suggestedMin: 0,
      //   //   // suggestedMax: 100,
      //   //   // stepSize: 10,
      //   //   // callback(value, index, values){
      //   //   //   return value + '手'
      //   //   // }
      //   // }
      // }],
      yAxes: [{
        display: true,
        ticks: {
          maxTicksLimit: 7,
          // min: -9999,
          // max: +9999,
          // stepSize: 100,
          // suggestedMax: 100,
          // suggestedMin: 0,
        },
        // scaleLabel: {
        //   display: true,
        //   labelString: "消費",
        // },
        // ticks: {
        //   // suggestedMax: 100,
        //   // suggestedMin: 0,
        //   // stepSize: 10,
        //   callback(value, index, values) {
        //     return Math.abs(value) +  "秒"
        //   }
        // }
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
          return [
            // data.labels[tooltipItem.index]
            // data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index].x,
            // " ",
            data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index].y,
            // Math.abs(data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index].y), "秒",
            // Math.abs(data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index].y), "秒",
          ].join("")
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
  },

  methods: {
    chart_reset() {
      this.chart_config_reset()
      this.chart_value_max = 0
      this.chart_instance.update()
    },

    score_list_reflection(e) {
      if (e["score_list"]) {
        e["score_list"].forEach(e => {
          this.chart_config.data.labels.push(e.x)
          this.chart_config.data.datasets[0].data.push(e)
          const abs = Math.abs(e.y)
          if (abs > this.chart_value_max) {
            this.chart_value_max = abs
          }
        })
        const ticks = this.chart_config.options.scales.yAxes[0].ticks
        const v = this.chart_value_max * CHART_TOP_PADDING_RATE
        // ticks.max = v
        // ticks.min = -v

        ticks.suggestedMax = v
        ticks.suggestedMin = -v

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

  computed: {
  },
}
