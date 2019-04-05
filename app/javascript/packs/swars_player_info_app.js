document.addEventListener("DOMContentLoaded", () => {
  window.SwarsPlayerInfoApp = Vue.extend({
    data() {
      return {
      }
    },

    mounted() {
      this.$options.time_chart_params_list.forEach(e => new Chart(this.$refs[e.canvas_id], this.days_chart_js_options(e)))
      this.$options.any_chart_params_list.forEach(e => new Chart(this.$refs[e.canvas_id], e.chart_params))
    },

    methods: {
      days_chart_js_options(params) {
        return Object.assign({}, params.chart_params, {
          options: {
            title: {
              display: true,
              text: params.name,
            },

            // https://misc.0o0o.org/chartjs-doc-ja/configuration/layout.html
            layout: {
              padding: {
                // left: 0,
                right: 12,
                // top: 0,
                // bottom: 0
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
                    labelString: "時",
                  },
                  ticks: {
                    // suggestedMax: 25,
                    // suggestedMin: 0,
                    // stepSize: 60,
                    callback(value, index, values) {
                      return Math.trunc(value / 60) + "時"
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
                  const y = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index].y
                  const hour = Math.trunc(y / 60)
                  const min = y % 60
                  return `${hour}時${min}分`
                },
              },
            },
          },
        })
      },
    },

    computed: {
      days_chart_params() {
        return Object.assign({}, this.$options.days_chart_params, this.days_chart_js_options("対局日時"))
      },

      week_chart_params() {
        return Object.assign({}, this.$options.week_chart_params, this.days_chart_js_options("直近1週間"))
      },
    },
  })
})
