// chart.js に縦線を入れる方法
// https://stackoverflow.com/questions/30256695/chart-js-drawing-an-arbitrary-vertical-line

import PaletteInfo from "@/components/models/PaletteInfo.js"

const ChartVlinePlugin = {
  // Plugin API
  // https://misc.0o0o.org/chartjs-doc-ja/developers/plugins.html
  afterDatasetsDraw(instance, easing) {
    if (instance.config.chart_turn != null) {
      this.vertical_line_render(instance, instance.config.chart_turn)
    }
  },

  // private methods

  // chart_turn 手目に対応する ChartElement インスタンスを取得する
  line_position_get(instance, chart_turn) {
    // 次のデータ構造のときは chart_turn がそのまま index になる
    // assert { record.time_chart_xy_list2(:black) == [{x: 0, y: nil}, {x: 1, y: 1},   {x: 2, y: nil}, {x: 3, y:   5}, {x: 4, y: nil}, {x: 5, y:   2}, {x: 6, y: nil}] }
    // assert { record.time_chart_xy_list2(:white) == [{x: 0, y: nil}, {x: 1, y: nil}, {x: 2, y:  -3}, {x: 3, y: nil}, {x: 4, y:  -7}, {x: 5, y: nil}, {x: 6, y: -590}] }
    if (true) {
      const datasetIndex = (1 + instance.config.__vm__.record.preset_info.handicap_shift + chart_turn) % 2
      const meta = instance.getDatasetMeta(datasetIndex) // 0 も 1 も同じ長さなので 0 で良いが色が関係するので合わせる
      const data = meta.data
      return data[chart_turn]
    }

    // このデータ構造の場合
    // assert { record.memberships[0].time_chart_xy_list == [{x: 1, y: 1 }, {x: 3, y:  5}, {x: 5, y: 2}] }
    // assert { record.memberships[1].time_chart_xy_list == [{x: 2, y: -3}, {x: 4, y: -7},             ] }
    if (false) {
      const index_info = instance.config.index_info_hash[chart_turn]
      if (index_info) {
        const meta = instance.getDatasetMeta(index_info.datasetIndex)
        // meta:
        //   type: "line"
        //   data: Array(54)
        //     0: ChartElement
        //       _chart: Chart {id: 0, ctx: null, canvas: null, config: {…}, width: 828, …}
        //       _datasetIndex: 1
        //       _index: 0
        //       hidden: false
        //       _xScale: ChartElement {id: "x-axis-0", type: "category", options: {…}, ctx: CanvasRenderingContext2D, chart: Chart, …}
        //       _yScale: ChartElement {id: "y-axis-0", type: "linear", options: {…}, ctx: CanvasRenderingContext2D, chart: Chart, …}
        //       _options: {backgroundColor: "rgba(100.00%, 22.00%, 37.60%, 0.10)", borderColor: "rgba(100.00%, 22.00%, 37.60%, 0.60)", borderWidth: 1, hitRadius: 5, hoverBackgroundColor: undefined, …}
        //       _model: {x: 49.173176518192996, y: 133.96444444444444, skip: false, radius: 1.2, pointStyle: "circle", …}
        //       _view: {x: 49.173176518192996, y: 133.96444444444444, skip: false, radius: 1.2, pointStyle: "circle", …}
        //       _start: null
        //       __proto__: Element
        //     1: ChartElement {_chart: Chart, _datasetIndex: 1, _index: 1, hidden: false, _xScale: ChartElement, …}
        //     2: ChartElement {_chart: Chart, _datasetIndex: 1, _index: 2, hidden: false, _xScale: ChartElement, …}
        //     ...snip...
        //   dataset: ChartElement {_chart: Chart, _datasetIndex: 1, hidden: false, _scale: ChartElement, _children: Array(54), …}
        //   controller: ChartElement {chart: Chart, index: 1, _data: Array(54)}
        //   hidden: null
        //   xAxisID: "x-axis-0"
        //   yAxisID: "y-axis-0"
        //   $filler: {visible: true, fill: "origin", chart: Chart, el: ChartElement, boundary: {…}, …}
        const data = meta.data
        return data[index_info.index]
      } else {
        // 0手目の場合
      }
    }
  },

  vertical_line_render(instance, chart_turn) {
    const chart_element = this.line_position_get(instance, chart_turn)
    if (chart_element) {
      const lineLeftOffset = chart_element._model.x       // chart_turn に対応するX座標
      const _datasetIndex = chart_element._datasetIndex   // chart_turn は先後どちらか

      const scale = instance.scales['y-axis-0']
      const context = instance.chart.ctx

      // render vertical line
      context.beginPath()
      context.strokeStyle = PaletteInfo.fetch(_datasetIndex).alpha(0.6)
      context.moveTo(lineLeftOffset, scale.top)
      context.lineTo(lineLeftOffset, scale.bottom)
      context.stroke()

      // write label
      // context.fillStyle = "#ff0000"
      // context.textAlign = 'center'
      // context.fillText('MY TEXT', lineLeftOffset, (scale.bottom - scale.top) / 2 + scale.top)
    }
  },
}

export default {
  props: {
    chart_turn: { required: true, },
  },

  watch: {
    chart_turn(v, ov) {
      this.debug_alert(`watch chart_turn ${ov} => ${v}`)
      this._chart_config.chart_turn = v
      this.chart_update()
    },
  },

  methods: {
    vline_setup() {
      // plugin 適応
      this._chart_config.plugins = [ChartVlinePlugin]

      // chart.js のインスタンスに他のデータを渡す
      // 予約キーと衝突しなかったら自由に引数を追加できる
      // 初期位置設定
      this._chart_config.chart_turn = this.chart_turn
    },

    // 手数から先後どちらのデータを参照したらいいのか難しいため
    // 手数からO(n)で参照するデータを特定できるようにする
    //
    // time_chart_params:
    //   labels: (5) [0, 1, 2, 3, 4]
    //   datasets[0]
    //     label: "devuser1"
    //     data[]
    //       0: {x: 1, y: +3}
    //       1: {x: 3, y: +2}
    //       ...
    //   datasets[1]
    //     label: "devuser2"
    //     data[]
    //       0: {x: 2, y: -3}
    //       1: {x: 4, y: -2}
    //
    // ↓変換
    //
    // {
    //   1 => {datasetIndex: 0, index: 0}
    //   2 => {datasetIndex: 1, index: 0} ← 2手目は datasetIndex が 1 つまり後手で、並びの 0 番目のデータを参照すればいいことがわかる
    //   3 => {datasetIndex: 0, index: 1}
    //   4 => {datasetIndex: 1, index: 1}
    // }
    //
    // index_info_hash(time_chart_params) {
    //   const hash = {}
    //   time_chart_params.datasets.forEach((dataset, i) => {
    //     dataset.data.forEach((e, j) => {
    //       if (e.y != null) {
    //         hash[e.x] = { datasetIndex: i, index: j }
    //       }
    //     })
    //   })
    //   return hash
    // },
  },
}
