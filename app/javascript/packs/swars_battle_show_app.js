// Vue.js にする必要ない気がするけど今後膨らむかもしれないのでこれでいい

document.addEventListener("DOMContentLoaded", () => {
  window.SwarsBattleShowApp = Vue.extend({
    data() {
      return {
        chartjs_params: this.$options.chartjs_params,
      }
    },
    mounted() {
      new Chart(this.$refs.swars_battle_show_canvas, this.chartjs_params)
    },
  })
})
