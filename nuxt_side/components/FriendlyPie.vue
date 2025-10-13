<template lang="pug">
.FriendlyPie.is-unselectable(:class="`pie_type_${info.chart_options.pie_type}`")
  canvas(ref="main_canvas" @click="click_handle")
</template>

<script>
import { GX } from "@/components/models/gs.js"
import { PaletteGenerator } from "@/components/models/palette_generator.js"

const CHART_CONFIG_DEFAULT = {
  type: 'doughnut',
  data: {
    labels: null,
    datasets: [{
      // backgroundColor: [
      //   // PaletteInfo.fetch("danger").alpha(1),
      //   // PaletteInfo.fetch("success").alpha(0.4),
      //   // PaletteInfo.fetch("info").base_color.set('hsl.h', 0.1).css(),
      //   PaletteInfo.fetch("primary").base_color.alpha(0.4).set('hsl.h', 180).css(),
      // ],
      borderWidth: 1,
      // hoverOffset: 3,
      weight: 1,
    }],
  },
  // https://misc.0o0o.org/chartjs-doc-ja/charts/doughnut.html
  options: {
    cutoutPercentage: 0,       // ドーナッツの円の切り抜き度合(0〜100)
    rotation: Math.PI * 0.5,  // 開始点 -0.5:真上 0.5:真下
    // aspectRatio: 3.0, // 大きいほど横長方形になる
    aspectRatio: 3.0, // 大きいほど横長方形になる。円=正方形としたいので1.0
    circumference: 2 * Math.PI * 1.0, // 全体の円

    legend: {
      position: "top",
      display: true,
    },

    title: {
      display: false,
    },

    animation: {
      animateScale: false,   // true: 中央から外側に向かってグラフが大きくなるアニメーション
      animateRotate: false,  // true: グラフは回転するアニメーション
    },

    tooltips: {
      enabled: true,
      displayColors: false, // 左に「■」を表示するか？
    },
  },
}

import chart_mixin from '@/components/models/chart_mixin.js'

// http://localhost:3000/w?query=kinakom0chi&user_stat_show=true
export default {
  mixins: [
    chart_mixin,
  ],
  props: {
    info: { type: Object, required: true, },  // [{name: ..., value: ...}, ...]
    callback_fn: { type: Function, required: false, }
    // chart_options: { type: Object, default: () => ({}), },
  },
  created() {
    // ・this._chart_config = Object.assign({}, CHART_CONFIG_DEFAULT) はダメ
    // ・shallow copy は this._chart_config.data.datasets[0] のポインタがコピーされていない
    // ・生成した同じコンポーネントで上書きされてしまう
    // ・なので cloneDeep している
    // ・ただし function が消える
    // ・function が必要なときは直接 Vue の方に書いた方がいいのかもしれない
    this._chart_config = _.cloneDeep(CHART_CONFIG_DEFAULT)
    this._chart_config.data.labels = this.extract_labels
    this._chart_config.data.datasets[0].data = this.extract_values

    // this._chart_config.data.datasets[0].backgroundColor = PaletteGenerator.palette_type2({count: this.data_count})
    // this._chart_config.data.datasets[0].backgroundColor = PaletteGenerator.palette_type2()

    if (this.info.chart_options.pie_type === "is_many_values") {
      this._chart_config.data.datasets[0].backgroundColor = PaletteGenerator.palette_type0({diff: 45, count: this.data_count})
    }
    if (this.info.chart_options.pie_type === "is_pair_values") {
      this._chart_config.data.datasets[0].backgroundColor = PaletteGenerator.palette_type3()
      // this._chart_config.options.legend.display = false
    }

    if (this.development_p) {
      this._chart_config.options.animation.animateScale = true
      this._chart_config.options.animation.animateRotate = true
    }
  },
  mounted() {
    this.chart_create()
  },
  methods: {
    click_handle(e) {
      const active_points = this._chart_instance.getElementsAtEvent(e)
      if (active_points.length >= 1) {
        const index = active_points[0]["_index"]
        const name = this.extract_labels[index]
        this.debug_alert(name)
        if (this.callback_fn) {
          this.callback_fn(name)
        }
      }
    },
  },
  computed: {
    data_list()      { return this.info.body || []             },
    data_count()     { return this.data_list.length            },
    extract_labels() { return this.data_list.map(e => e.name)  },
    extract_values() { return this.data_list.map(e => e.value ?? 0) },
  },
}
</script>

<style lang="sass">
.FriendlyPie
  width: 100%
</style>
