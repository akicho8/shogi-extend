window.SwarsPlayerInfoApp = Vue.extend({
  data() {
    return {
      submited: false,
    }
  },

  mounted() {
    if (this.config.time_chart_params_list) {
      this.config.time_chart_params_list.forEach(e => new Chart(this.$refs[e.canvas_id], this.days_chart_js_options(e)))
    }
    if (this.config.any_chart_params_list) {
      this.config.any_chart_params_list.forEach(e => new Chart(this.$refs[e.canvas_id], e.chart_params))
    }
  },

  methods: {
    form_submited(e) {
      this.process_now()
      this.submited = true
    },

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
})
