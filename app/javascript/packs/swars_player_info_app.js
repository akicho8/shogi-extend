// Vue.js にする必要ない気がするけど今後膨らむかもしれないのでこれでいい

document.addEventListener("DOMContentLoaded", () => {
  window.SwarsPlayerInfoApp = Vue.extend({
    data() {
      return {
        chartjs_params: this.$options.chartjs_params,
      }
    },

    mounted() {
      new Chart(this.$refs.swars_player_info_canvas, this.chartjs_all_params)
    },

    computed: {
      chartjs_all_params() {
        return Object.assign({}, this.chartjs_params, {

          options: {
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
      }
    },
  })
})
