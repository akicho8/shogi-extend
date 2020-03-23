<template lang="pug">
.win_lose_circle.is-unselectable(:class="[size, {'is-narrow': narrowed}]")
  .level.is-mobile.win_lose_container
    .level-item.has-text-centered.win.win_lose_counts
      div
        .heading WIN
        .title {{info.judge_counts["win"]}}
    .level-item.has-text-centered.doughnut.is-narrow
      div.chart_container
        canvas(ref="main_canvas" :width="size === 'is-small' ? 64 : 80")
        .win_rate_container
          .win_rate_label.has-text-grey-light
            | 勝率
          .win_rate_value_with_p
            span.win_rate_value.has-text-weight-bold
              | {{win_rate_value}}
            span.parcent.has-text-grey-light
              | %
    .level-item.has-text-centered.lose.win_lose_counts
      div
        .heading LOSE
        .title {{info.judge_counts["lose"]}}
</template>

<script>
import PaletteInfo from './palette_info.js'

const CHART_CONFIG_DEFAULT = {
  type: 'doughnut',
  data: {
    datasets: [{
      data: [
      ],
      backgroundColor: [
        PaletteInfo.fetch("danger").alpha(1),
        PaletteInfo.fetch("success").alpha(0.4),
      ],
    }],
    labels: [
      "WIN",
      "LOSE",
    ],
  },
  // https://misc.0o0o.org/chartjs-doc-ja/charts/doughnut.html
  options: {
    cutoutPercentage: 86,
    rotation: Math.PI * 0.5,

    aspectRatio: 1.0, // 大きいほど横長方形になる

    legend: {
      display: false,
    },

    title: {
      display: false,
    },

    animation: {
      animateScale: false, // trueの場合、中央から外側に向かってグラフが大きくなるアニメーションをします。
      animateRotate: true, // trueの場合、グラフは回転するアニメーションをします。 このプロパティはoptions.animationオブジェクトにあります。
    },

    tooltips: {
      enabled: false,
    },

  }
}

// http://localhost:3000/w?query=kinakom0chi&user_info_show=1
export default {
  props: {
    info:     { required: true,        },
    size:     { default: "is-default", },
    narrowed: { default: false,        },
  },

  data() {
    return {
      _chart_instance: null,
      _chart_config: null,
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
    this._chart_config.data.datasets[0].data = this.win_lose_count_list
  },

  mounted() {
    this.chart_create()
  },

  beforeDestroy() {
    this.chart_destroy()
  },

  methods: {
    // TODO: 共通化する。というかクラス化する
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

    delete_click_handle() {
      this.$emit("close") // 昔は this.$parent.close() だった
    },
  },

  computed: {
    win_rate_value() {
      const w = this.info.judge_counts["win"]
      const l = this.info.judge_counts["lose"]
      const count = w + l
      if (count === 0) {
        return "0"
      }
      const value = w / count
      return Math.floor(value * 100)
    },

    win_lose_count_list() {
      return [
        this.info.judge_counts["win"],
        this.info.judge_counts["lose"],
      ]
    },
  },
}
</script>

<style lang="sass">
@import "./stylesheets/bulma_init.scss"

$parcent_size: 0.7em

.win_lose_circle
  &.is-default
    font-size: 12px

  &.is-small
    font-size: 10px

  &.is-narrow
    .chart_container
      margin: auto -0.0rem

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
    .heading
      font-weight: bold
    .win_lose_counts
      position: relative
      top: -0.25em
      .heading
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
      bottom: 24%     // 大きくすると勝率が上に移動する
      margin: auto

      .win_rate_label
        position: relative
        top: 0.2rem
        font-size: 1em        // 「勝率」
      .win_rate_value_with_p
        // 「%」があるぶん左にずれるため、そのぶんだけ右にずらす
        position: relative
        left: $parcent_size / 2

        .win_rate_value
          font-size: 2.6em
          line-height: 100%   // 上の空白をなくすため

        .parcent
          position: relative
          left: -0.1rem
          font-size: $parcent_size     // % の大きさ
</style>
