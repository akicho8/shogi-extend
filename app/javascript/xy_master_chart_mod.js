// 下のチャート関連

import dayjs from "dayjs"

export default {
  data() {
    return {
      xy_chart_rule_key: null,
      xy_chart_scope_key: null,
      xy_chart_counter: 0,
    }
  },

  mounted() {
  },

  watch: {
    xy_chart_rule_key() {
      this.xy_chart_fetch()
      this.data_save_to_local_storage()
    },

    xy_chart_scope_key() {
      this.xy_chart_fetch()
      this.data_save_to_local_storage()
    },
  },

  methods: {
    xy_chart_fetch() {
      if (this.xy_chart_counter == 0) {
        this.xy_chart_counter += 1
        this.http_get_command(this.$root.$options.xhr_post_path, { xy_chart_scope_key: this.xy_chart_scope_key, xy_chart_rule_key: this.xy_chart_rule_key }, data => {
          if (window.chart_instance) {
            if (this.development_p) { console.log("chart destroy") }
            window.chart_instance.destroy()
          }
          window.chart_instance = new Chart(this.$refs.chart_canvas, this.days_chart_js_options(data.chartjs_datasets))
          if (this.development_p) { console.log("chart new") }
          this.xy_chart_counter = 0
        })
      }
    },

    days_chart_js_options(datasets) {
      return Object.assign({}, {data: {datasets: datasets}}, {
        type: "line",
        options: {
          // サイズ
          // aspectRatio: 1.5, // 大きいほど横長方形になる
          maintainAspectRatio: false,
          responsive: false,
          // responsive: true,
          // maintainAspectRatio: false,

          elements: {
            line: {
              tension: 0.2, // disables bezier curves (https://www.chartjs.org/docs/latest/charts/line.html#disable-bezier-curves)
            },
          },

          title: {
            display: false,
            text: "学習グラフ",
          },

          // https://misc.0o0o.org/chartjs-doc-ja/configuration/layout.html
          layout: {
            padding: {
              left: 4,
              right: 4,
              top: 4,
              bottom: 4,
            },
          },

          // https://qiita.com/Haruka-Ogawa/items/59facd24f2a8bdb6d369#3-5-%E6%95%A3%E5%B8%83%E5%9B%B3
          scales: {
            xAxes: [
              {
                type: 'time',
                time: {
                  unit: "day",
                  displayFormats: {
                    day: "M/D",
                  },
                },
              },
            ],
            yAxes: [
              {
                scaleLabel: {
                  display: false,
                  labelString: "タイム",
                },
                ticks: {
                  // suggestedMax: 25,
                  // suggestedMin: 0,
                  // stepSize: 60,
                  callback(value, index, values) {
                    return dayjs.unix(value).format("mm:ss")
                    // return Math.trunc(value / 60) + "時"
                  }
                }
              },
            ]
          },

          // https://tr.you84815.space/chartjs/configuration/tooltip.html
          legend: {
            display: true,
          },

          tooltips: {
            callbacks: {
              title(tooltipItems, data) {
                return ""
              },
              label(tooltipItem, data) {
                const datasetLabel = data.datasets[tooltipItem.datasetIndex].label || ""
                const y = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index].y
                return datasetLabel + " " + dayjs.unix(y).format("mm:ss.SSS")
              },
            },
          },
        },
      })
    },
  },

  computed: {
    curent_xy_chart_scope() {
      return this.XyChartScopeInfo.fetch(this.xy_chart_scope_key)
    },
  },
}
