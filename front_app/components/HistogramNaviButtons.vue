<template lang="pug">
.columns
  .column
    .buttons.are-small
      template(v-for="item in items")
        b-button(tag="nuxt-link" :to="item.to" exact-active-class="is-active") {{item.title}}
  .column
    .level.is-mobile.mb-0
      .level-left
        .level-item.has-text-centered
          div
            .head.is-size-7 最終計測
            .title.is-size-6 {{diff_time_format(config.updated_at)}}
        .level-item.has-text-centered
          div
            .head.is-size-7 サンプル数直近
            .title.is-size-6 {{config.sample_count}}件
</template>

<script>
export default {
  name: "HistogramNaviButtons",
  props: {
    config: { type: Object, required: true },
  },
  data() {
    return {
      items: [
        { title: "戦型", to: { name: "swars-histograms-key",   params: {key: "attack"    }, }, },
        { title: "囲い", to: { name: "swars-histograms-key",   params: {key: "defense"   }, }, },
        { title: "手筋", to: { name: "swars-histograms-key",   params: {key: "technique" }, }, },
        { title: "備考", to: { name: "swars-histograms-key",   params: {key: "note"      }, }, },
        { title: "段級", to: { name: "swars-histograms-grade", params: {                 }, }, },
      ],
    }
  },
}
</script>
