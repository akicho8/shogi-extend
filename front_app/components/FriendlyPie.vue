<template lang="pug">
.FriendlyPie.is-unselectable
  //- .level.is-mobile.win_lose_container
  //-   //- .level-item.has-text-centered.win.win_lose_counts
  //-   //-   .heading_with_title(:class="{'is-clickable': win_lose_clickable_p}" @click="click_handle('win')")
  //-   //-     .heading WIN
  //-   //-     .title {{info.judge_counts["win"]}}
  //-   .level-item.has-text-centered.doughnut.is-narrow
  //-     .chart_container
  //-       //- view-source:https://www.chartjs.org/samples/latest/charts/doughnut.html
  .canvas_holder
    canvas(ref="main_canvas")
  //- .win_rate_container
  //-   .win_rate_label.has-text-grey-light.has-text-weight-bold(v-if="total >= 1")
  //-     | 勝率
  //-   .rate_human_with_p
  //-     span.rate_human.has-text-weight-bold
  //-       | {{rate_human}}
  //- .total.has-text-weight-bold(v-if="total_show_p && total >= 1")
  //-   | {{total}}
  //- .level-item.has-text-centered.lose.win_lose_counts
  //-   .heading_with_title(:class="{'is-clickable': win_lose_clickable_p}" @click="click_handle('lose')")
  //-     .heading LOSE
  //-     .title {{info.judge_counts["lose"]}}
</template>

<script>
import { PaletteInfo } from "@/components/models/palette_info.js"
import chroma from 'chroma-js'
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
    cutoutPercentage: 75,       // ドーナッツの円の切り抜き度合(0〜100)
    rotation: Math.PI * 1.5,    // 真上を0とする
    aspectRatio: 1.0, // 大きいほど横長方形になる。円=正方形としたいので1.0
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

    // this._chart_config.data.datasets[0].backgroundColor = PaletteGenerator.palette_type0({diff: 30, count: this.data_count})
    this._chart_config.data.datasets[0].backgroundColor = PaletteGenerator.palette_type2({count: this.data_count})
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
    width: 300px

  // font-size: 14px

  // 勝敗
  .win_lose_container
    // .win
    //   justify-content: flex-end   // 寄せ→
    //   .heading, .title
    //     color: $danger
    // .lose
    //   justify-content: flex-start // ←寄せ
    //   .heading, .title
    //     color: $success

    // .win_lose_counts
    //   position: relative
    //   top: -0.4em
    //   .heading
    //     font-weight: bold
    //     min-width: 4em          // WIN LOSE と並べると3,4文字で左にずれるため WIN を4文字相当にする
    //     font-size: 0.8em
    //     margin-bottom: 0
    //   .title
    //     font-size: 2.3em
    //
    //   .heading_with_title
    //     padding: 0.5rem
    //     &.is-clickable
    //       &:hover
    //         background-color: $white-ter
    //         border-radius: 3px

  // 中央の勝率
  // .chart_container
  //   margin: 0 0.75em             // 小さくすると WIN LOSE が寄る
  //   position: relative
  //
  //   // 浮かせて中央へ
  //   .win_rate_container
  //     height: inherit
  //     position: absolute
  //     left: 0%
  //     right: 0%
  //     bottom: 1.8em     // 大きくすると勝率が上に移動する
  //     margin: auto
  //
  //     .win_rate_label
  //       position: relative
  //       top: 0.1em
  //       font-size: 0.75em        // 「勝率」
  //     .rate_human_with_p
  //       .rate_human
  //         font-size: 2.8em
  //         line-height: 100%   // 上の空白をなくすため

    // // 円の下に合計
    // .total
    //   height: inherit
    //   position: absolute
    //   left: 0%
    //   right: 0%
    //   bottom: 1em
    //   font-size: 0.8em

  //////////////////////////////////////////////////////////////////////////////// 個別設定は上書きするので後に書くこと

  // &.is-small
  //   font-size: 10px
  //   .win_rate_container
  //     bottom: 1.9em       // 大きくすると勝率が上に移動する
  //
  // &.is-narrow
  //   .chart_container
  //     margin: auto -0.1em // win lose を中央に寄せる

.STAGE-development
  .FriendlyPie
    .canvas_holder
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
