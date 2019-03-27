// Vue.js にする必要ない気がするけど今後膨らむかもしれないのでこれでいい

document.addEventListener("DOMContentLoaded", () => {
  window.SwarsBattleShowApp = Vue.extend({
    data() {
      return {
        chartjs_params: this.$options.chartjs_params,
      }
    },

    mounted() {
      new Chart(this.$refs.swars_battle_show_canvas, this.chartjs_all_params)
    },

    computed: {
      chartjs_all_params() {
        return Object.assign({}, this.chartjs_params, {
          options: {
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
        })
      }
    },
  })
})
