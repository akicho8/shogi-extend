// Vue.js にする必要ない気がするけど今後膨らむかもしれないのでこれでいい

document.addEventListener("DOMContentLoaded", () => {
  window.SwarsBattleShowApp = Vue.extend({
    data() {
      return {
      }
    },

    mounted() {
      new Chart(this.$refs.think_canvas, this.think_chart_params)
    },

    computed: {
      think_chart_params() {
        return Object.assign({}, this.$options.think_chart_params, {
          options: {
            title: {
              display: true,
              text: "消費時間",
            },

            // https://qiita.com/Haruka-Ogawa/items/59facd24f2a8bdb6d369#3-5-%E6%95%A3%E5%B8%83%E5%9B%B3
            scales: {
              xAxes: [{
                scaleLabel: {
                  display: true,
                  labelString: "手数",
                },
                // ticks: {
                //   // suggestedMin: 0,
                //   // suggestedMax: 100,
                //   // stepSize: 10,
                //   // callback(value, index, values){
                //   //   return value + '手'
                //   // }
                // }
              }],
              yAxes: [{
                // scaleLabel: {
                //   display: true,
                //   labelString: "消費",
                // },
                ticks: {
                  // suggestedMax: 100,
                  // suggestedMin: 0,
                  // stepSize: 10,
                  callback(value, index, values) {
                    return Math.abs(value) +  "秒"
                  }
                }
              }]
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
        })
      }
    },
  })
})
