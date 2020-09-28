// CPU対戦の戦力グラフ

const CHART_TOP_PADDING_RATE = 1.0   // 評価値の上の隙間率(1.0〜1.5ぐらい1.0で無し)
const SUGGESTED_MAX_DEFAULT = 10000  // 評価値の初期値

import PaletteInfo from "@/components/models/PaletteInfo.js"

const MainPalette = PaletteInfo.fetch("info")

const CHART_CONFIG_DEFAULT = {
  type: "line",

  data: {
    labels: [],
    datasets: [
      {
        label: "戦力グラフ",    // legend: true のときに表示するラベル
        data: [],
      },
    ],
  },

  options: {
    // サイズ
    aspectRatio: 3, // 大きいほど横長方形になる

    title: {
      display: true,
      text: "戦力グラフ",
    },

    elements: {
      // 共通設定
      line: {
        borderColor:     MainPalette.alpha(1.0),
        backgroundColor: MainPalette.alpha(0.1),
        fill: true,
        tension: 0,
      },
    },

    // https://qiita.com/Haruka-Ogawa/items/59facd24f2a8bdb6d369#3-5-%E6%95%A3%E5%B8%83%E5%9B%B3
    scales: {
      xAxes: [{
        scaleLabel: {
          display: false,
        },
        ticks: {
          minRotation: 0,   // 表示角度水平
          maxRotation: 0,   // 表示角度水平
          maxTicksLimit: 5, // 最大横N個の目盛りにする
        },
        gridLines: {
          display: false,    // x軸の中間の縦線
        },
      }],
      yAxes: [{
        display: true,
        ticks: {
          maxTicksLimit: 5,
        },
      }],
    },

    // https://www.chartjs.org/docs/latest/general/interactions/
    hover: {
      mode: "index",          // マウスに対して点が強調される条件 X軸にマッチしたら点を強調する https://www.chartjs.org/docs/latest/general/interactions/modes.html#interaction-modes
      intersect: false,       // Y座標のチェックは無視する
      animationDuration: 400, // デフォルト400
    },

    // https://tr.you84815.space/chartjs/_chart_configuration/tooltip.html
    legend: {
      display: false,
    },
    tooltips: {
      mode: "index",    // マウスに対してツールチップが出る条件
      intersect: false, // Y座標のチェックは無視する
      displayColors: false,
      callbacks: {
        title(tooltipItems, data) {
          return ""
        },
        label(tooltipItem, data) {
          const e = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index]
          return e.y.toString()
        },
      },
    },

    // 点をクリックしたとき
    onClick(event, chart_elements) {
      const chart_instance = this
      const __vm__ = chart_instance.config.__vm__
      if (chart_elements.length >= 1) {
        const chart_element = chart_elements[0]
        const datasets = chart_element._chart.config.data.datasets
        const xy_info = datasets[chart_element._datasetIndex].data[chart_element._index]
        if (__vm__.mode === "standby") {
          __vm__.$refs.sp_vm.api_board_turn_set(xy_info.x)
        }
      }
    },
  },
}

import chart_mod from '../../../app/javascript/chart_mod.js'

export const cpu_battle_force_chart = {
  mixins: [
    chart_mod,
  ],

  data() {
    return {
      chart_value_max: null,
    }
  },

  created() {
    this.chart_setup(CHART_CONFIG_DEFAULT)
    this._chart_config_reset()
  },

  mounted() {
    this.chart_create()
  },

  methods: {
    // 開始時の初期化
    chart_reset() {
      this._chart_config_reset()
      this.chart_update()

      this.chart_value_max = 0
    },

    _chart_config_reset() {
      this._chart_config.__vm__ = this
      this._chart_config.data.labels = []
      this._chart_config.data.datasets[0].data = []
      this._chart_config.options.scales.yAxes[0].ticks.suggestedMax = SUGGESTED_MAX_DEFAULT
      this._chart_config.options.scales.yAxes[0].ticks.suggestedMin = -SUGGESTED_MAX_DEFAULT
    },

    // 戦力情報の反映
    score_list_reflection(e) {
      if (e["score_list"]) {
        e["score_list"].forEach(e => {
          this._chart_config.data.labels.push(e.x)
          this._chart_config.data.datasets[0].data.push(e)

          const v = Math.abs(e.y)
          if (v > this.chart_value_max) {
            this.chart_value_max = v
          }
        })
        const ticks = this._chart_config.options.scales.yAxes[0].ticks
        const v = this.chart_value_max * CHART_TOP_PADDING_RATE
        if (false) {
          ticks.max = v
          ticks.min = -v
        } else {
          ticks.suggestedMax = v
          ticks.suggestedMin = -v
        }
        this.chart_update()
      }
    },
  },
}
