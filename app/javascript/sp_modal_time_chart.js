export default {
  data() {
    return {
      time_chart_p: false,         // 時間チャートを表示する？
      time_chart_fetch_counter: 0, // 時間チャート用データを取得中なら1以上
      _time_chart_params: null,    // 時間チャート用データ
    }
  },

  watch: {
    // 時間チャートスイッチ ON / OFF
    // 1回目 _time_chart_params を xhr で取得
    // 2回目 _time_chart_params があるのでそのまま表示
    time_chart_p(v) {
      if (v) {
        if (this._time_chart_params) {
          this.time_chart_show()
        } else {
          if (this.time_chart_fetch_counter == 0) {
            this.time_chart_fetch_counter += 1
            this.http_get_command(this.record.show_path, { time_chart_fetch: true }, data => {
              this._time_chart_params = data.time_chart_params
              this.time_chart_fetch_counter = 0
              this.time_chart_show()
            })
          }
        }
      } else {
        this.time_chart_destroy()
      }
    },
  },

  methods: {
    // 時間チャート表示
    time_chart_show() {
      this.time_chart_destroy()
      window.chart_instance = new Chart(this.$refs.think_canvas, this.time_chart_params(this._time_chart_params))
      this.$refs.think_canvas.addEventListener("click", this.time_chart_point_click_handle)
    },

    // 時間チャート非表示
    time_chart_destroy() {
      if (window.chart_instance) {
        this.$refs.think_canvas.removeEventListener('click', this.time_chart_point_click_handle)

        window.chart_instance.destroy()
        window.chart_instance = null
      }
    },

    // 点をタップしたとき盤面の手数を変更
    time_chart_point_click_handle(event) {
      let item = window.chart_instance.getElementAtEvent(event)
      if (item.length == 0) {
        return
      }
      item = item[0]
      const data = item._chart.config.data.datasets[item._datasetIndex].data[item._index]
      if (this.development_p) {
        console.log(`Clicked at (${item._index}, ${data.x}, ${data.y})`)
      }
      this.api_board_turn_set(data.x)
    },

    // 盤面の手数を変更
    api_board_turn_set(turn) {
      this.$refs.sp_modal.api_board_turn_set(turn) // 直接 shogi-player に設定
      this.turn_offset = turn                      // KENTO用に設定 (shogi-playerからイベントが来ないため)

      this.simple_notify(`${turn}手目`)
    },

    // 時間チャートのパラメータ作成
    time_chart_params(data) {
      return Object.assign({}, {
        type: "line",
        data: data,
        options: {
          aspectRatio: 1.5, // 大きいほど横長方形になる

          title: {
            display: false,
            text: "消費時間",
          },

          // events: ['click'],
          // // onHover: function(e, el) {
          // //   if (! el || el.length === 0) return;
          // //   console.log('onHover : label ' + el[0]._model.label);
          // // },

          // onClick(e, item) {
          //   if (! item || item.length === 0) return
          //
          //   let data = item._chart.config.data.datasets[item._datasetIndex].data[item._index]
          //   alert(`Clicked at (${data.x}, ${data.y})`)
          //
          //   // console.log('onClick : label ' + item[0]._model.label)
          // },

          // https://qiita.com/Haruka-Ogawa/items/59facd24f2a8bdb6d369#3-5-%E6%95%A3%E5%B8%83%E5%9B%B3
          scales: {
            xAxes: [{
              scaleLabel: {
                display: false,
                labelString: "手数",
              },
              ticks: {
                // 表示角度水平
                minRotation: 0,
                maxRotation: 0,

                // autoSkip: true,
                maxTicksLimit: 5, // 最大横N個の目盛りにする
                // min: 0,
                // max: this.record.turn_max,
                // suggestedMin: 0,
                // suggestedMax: 100,
                // stepSize: 50,
                callback(value, index, values) { return value + "" },
              }
            }],
            yAxes: [{
              // scaleLabel: {
              //   display: true,
              //   labelString: "消費",
              // },
              ticks: {
                // suggestedMax: 60,
                // suggestedMin: -60,
                // stepSize: 30,
                stepSize: 30,
                // max: 60,
                // min: -60,
                maxTicksLimit: 7,
                callback(value, index, values) { return Math.abs(value) +  "s" },
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
    },
  },
}
