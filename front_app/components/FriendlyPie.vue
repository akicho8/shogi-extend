<template lang="pug">
.FriendlyPie.is-unselectable
  .canvas_holder
    canvas(ref="main_canvas")
</template>

<script>
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
    rotation: Math.PI * 0.5,   // 真下を0とする
    aspectRatio: 3.0, // 大きいほど横長方形になる。円=正方形としたいので1.0
    // circumference: 200,

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
    },
  }
}

import chart_mixin from '@/components/models/chart_mixin.js'

// http://localhost:3000/w?query=kinakom0chi&user_info_show=true
export default {
  mixins: [
    chart_mixin,
  ],
  props: {
    info: { type: Array, required: true, },  // [{name: ..., value: ...}, ...]
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

    this._chart_config.data.datasets[0].backgroundColor = PaletteGenerator.palette_type0({diff: 45, count: this.data_count})
    // this._chart_config.data.datasets[0].backgroundColor = PaletteGenerator.palette_type2({count: this.data_count})
    // this._chart_config.data.datasets[0].backgroundColor = PaletteGenerator.palette_type2()

    if (this.development_p) {
      this._chart_config.options.animation.animateScale = true
      this._chart_config.options.animation.animateRotate = true
    }
  },
  mounted() {
    this.chart_create()
  },
  computed: {
    data_count()     { return this.info.length            },
    extract_labels() { return this.info.map(e => e.name)  },
    extract_values() { return this.info.map(e => e.value) },
  },
}
</script>

<style lang="sass">
.FriendlyPie
  display: flex
  align-items: center
  justify-content: center
  .canvas_holder
    width: calc(256px + 128px + 32px)

.STAGE-development
  .FriendlyPie
    .canvas_holder
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
