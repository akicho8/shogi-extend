// 下のチャート関連

import Chart from "chart.js"

const CHART_CONFIG_DEFAULT = {
  type: "line",
  options: {
    // サイズ
    aspectRatio: 1.5, // 大きいほど横長方形になる
    // maintainAspectRatio: false,
    // responsive: false,
    // responsive: true,
    // maintainAspectRatio: false,

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
        scaleLabel: {
          display: false,
          labelString: "タイム",
        },
        ticks: {
          maxTicksLimit: 7, // 最大横N個の目盛りにする
          // suggestedMax: 30,
          // suggestedMin: 0,
          // stepSize: 15,
          // max: 60*3,
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
      // animationDuration: 400, // デフォルト400
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

export default {
  data() {
    return {
      xy_chart_rule_key: null,
      xy_chart_scope_key: null,
      xy_chart_counter: 0,
    }
  },

  watch: {
    xy_chart_rule_key() {
      this.chart_show()
      this.data_save_to_local_storage()
    },
    
    xy_chart_scope_key() {
      this.chart_show()
      this.data_save_to_local_storage()
    },
  },

  methods: {
    chart_show() {
      if (this.xy_chart_counter == 0) {
        this.xy_chart_counter += 1
        this.remote_get("/api/xy", { xy_chart_scope_key: this.xy_chart_scope_key, xy_chart_rule_key: this.xy_chart_rule_key }, data => {
          this.chart_destroy()
          window.chart_instance = new Chart(this.$refs.chart_canvas, this.days_chart_js_options(data.chartjs_datasets))
          this.xy_chart_counter = 0
        })
      }
    },

    chart_destroy() {
      if (window.chart_instance) {
        window.chart_instance.destroy()
        window.chart_instance = null
      }
    },

    days_chart_js_options(datasets) {
      return Object.assign({}, {data: {datasets: datasets}}, CHART_CONFIG_DEFAULT)
    },
  },

  computed: {
    curent_xy_chart_scope() {
      return this.XyChartScopeInfo.fetch(this.xy_chart_scope_key)
    },
  },
}
