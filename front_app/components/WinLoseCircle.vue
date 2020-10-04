<template lang="pug">
.WinLoseCircle.is-unselectable(:class="[size, {'is-narrow': narrowed}]")
  .level.is-mobile.win_lose_container
    .level-item.has-text-centered.win.win_lose_counts
      div
        .heading WIN
        .title {{info.judge_counts["win"]}}
    .level-item.has-text-centered.doughnut.is-narrow
      div.chart_container
        //- view-source:https://www.chartjs.org/samples/latest/charts/doughnut.html
        .canvas_holder(:style="{width: (size === 'is-small' ? 68 : 92) + 'px'}")
          canvas(ref="main_canvas")
        .win_rate_container
          .win_rate_label.has-text-grey-light.has-text-weight-bold(v-if="total >= 1")
            | 勝率
          .rate_human_with_p
            span.rate_human.has-text-weight-bold
              | {{rate_human}}
        .total.has-text-weight-bold(v-if="total_show_p && total >= 1")
          | {{total}}
    .level-item.has-text-centered.lose.win_lose_counts
      div
        .heading LOSE
        .title {{info.judge_counts["lose"]}}
</template>

<script>
import PaletteInfo from "@/components/models/PaletteInfo.js"

const CHART_CONFIG_DEFAULT = {
  type: 'doughnut',
  data: {
    labels: [ "WIN", "LOSE" ],
    datasets: [{
      backgroundColor: [
        PaletteInfo.fetch("danger").alpha(1),
        PaletteInfo.fetch("success").alpha(0.4),
      ],
    }],
  },
  // https://misc.0o0o.org/chartjs-doc-ja/charts/doughnut.html
  options: {
    cutoutPercentage: 86,       // ドーナッツの円の切り抜き度合(0〜100)
    rotation: Math.PI * 0.5,    // 真下が0とする

    aspectRatio: 1.0, // 大きいほど横長方形になる。円=正方形としたいので1.0

    legend: {
      display: false,
    },

    title: {
      display: false,
    },

    animation: {
      animateScale: false,   // true: 中央から外側に向かってグラフが大きくなるアニメーション
      animateRotate: false,  // true: グラフは回転するアニメーション
    },

    tooltips: {
      enabled: false,
    },
  }
}

import chart_mod from '@/components/models/chart_mod.js'

// http://localhost:3000/w?query=kinakom0chi&user_info_show=true
export default {
  mixins: [chart_mod],

  props: {
    info:         { required: true,        },  // {win: 1, lose: 2}
    size:         { default: "is-default", },  // is-default or is-small
    narrowed:     { default: false,        },  // true: 狭くする
    total_show_p: { default: true,         },  // true: win + lose の合計を表示する
  },

  data() {
    return {
    }
  },

  created() {
    // ・this._chart_config = Object.assign({}, CHART_CONFIG_DEFAULT) はダメ
    // ・shallow copy は this._chart_config.data.datasets[0] のポインタがコピーされていない
    // ・生成した同じコンポーネントで上書きされてしまう
    // ・なので cloneDeep している
    // ・ただし function が消える
    // ・function が必要なときは直接 Vue の方に書いた方がいいのかもしれない
    this._chart_config = _.cloneDeep(CHART_CONFIG_DEFAULT)
    this._chart_config.data.datasets[0].data = this.win_lose_pair

    if (this.development_p) {
      this._chart_config.options.animation.animateScale = true
      this._chart_config.options.animation.animateRotate = true
    }
  },

  mounted() {
    this.chart_create()
  },

  methods: {
  },

  computed: {
    rate_human() {
      if (this.total === 0) {
        return ""
      }
      return Math.floor(this.rate * 100)
    },

    rate() {
      return this.win / this.total
    },

    win_lose_pair() {
      return [this.win, this.lose]
    },

    total() {
      return this.win + this.lose
    },

    win() {
      return this.info.judge_counts["win"]
    },

    lose() {
      return this.info.judge_counts["lose"]
    },
  },
}
</script>

<style lang="sass">
.WinLoseCircle
  font-size: 14px

  // 勝敗
  .win_lose_container
    .win
      justify-content: flex-end   // 寄せ→
      .heading, .title
        color: $danger
    .lose
      justify-content: flex-start // ←寄せ
      .heading, .title
        color: $success

    .win_lose_counts
      position: relative
      top: -0.4em
      .heading
        font-weight: bold
        min-width: 4em          // WIN LOSE と並べると3,4文字で左にずれるため WIN を4文字相当にする
        font-size: 0.8em
        margin-bottom: 0
      .title
        font-size: 2.3em

  // 中央の勝率
  .chart_container
    margin: 0 1em             // 小さくすると WIN LOSE が寄る
    position: relative

    // 浮かせて中央へ
    .win_rate_container
      height: inherit
      position: absolute
      left: 0%
      right: 0%
      bottom: 1.8em     // 大きくすると勝率が上に移動する
      margin: auto

      .win_rate_label
        position: relative
        top: 0.1em
        font-size: 0.75em        // 「勝率」
      .rate_human_with_p
        .rate_human
          font-size: 2.8em
          line-height: 100%   // 上の空白をなくすため

    // 円の下に合計
    .total
      height: inherit
      position: absolute
      left: 0%
      right: 0%
      bottom: 1em
      font-size: 0.8em

  //////////////////////////////////////////////////////////////////////////////// 個別設定は上書きするので後に書くこと

  &.is-small
    font-size: 10px
    .win_rate_container
      bottom: 1.9em       // 大きくすると勝率が上に移動する

  &.is-narrow
    .chart_container
      margin: auto -0.1em // win lose を中央に寄せる
</style>
