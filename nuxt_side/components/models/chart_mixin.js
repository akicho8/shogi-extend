// 使い方
//
//   this.$axios.$get("/api/xy_master/time_records.json", {params: params}).then(data => {
//     this.chart_setup(CHART_CONFIG_DEFAULT)
//     this._chart_config.data = {datasets: data.chartjs_datasets}
//     this.chart_create()
//   })
//
import _ from "lodash"

export default {
  data() {
    return {
      // private
      _chart_instance: null,
      _chart_config: null, // 現在表示しているチャートの設定(updateするとチャートの方もupdateで更新できる)
    }
  },

  beforeDestroy() {
    this.chart_destroy()
  },

  methods: {
    chart_setup(CHART_CONFIG_DEFAULT) {
      this._chart_config = _.cloneDeep(CHART_CONFIG_DEFAULT)

      // chart.js のインスタンスに他のデータを渡す
      // 予約キーと衝突しなかったら自由に引数を追加できる
      this._chart_config.__vm__ = this
    },

    // aspectRatio の場合は update では反映されないので次のように作り直す
    //
    //   this._chart_config.options.aspectRatio = 5.0
    //   this.chart_create()
    //
    chart_create() {
      this.chart_destroy()
      this._chart_instance = new Chart(this.$refs.main_canvas, this._chart_config)
    },

    chart_update() {
      if (this._chart_instance) {
        this._chart_instance.update()
      }
    },

    chart_destroy() {
      if (this._chart_instance) {
        this._chart_instance.destroy()
        this._chart_instance = null
      }
    },
  },
}
