<template lang="pug">
.columns
  .column
    .buttons.are-small
      template(v-for="item in items")
        template(v-if="!development_p && item.development_only")
        template(v-else)
          b-button(tag="nuxt-link" :to="item.to" exact-active-class="is-active" @click.native="sound_play('click')") {{item.title}}
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
            .title.is-size-6.has-text-weight-normal
              template(v-for="max in [0, 1, 2, 3, 4, 5, 10, 100, 250, 500, 1000, 2500, 5000, 1000]")
                nuxt-link.mx-1(:to="{name: $route.name, params: $route.params, query: {...$route.query, max: max}}" exact-active-class="has-text-weight-bold") {{max}}
</template>

<script>
export default {
  name: "SwarsHistogramNavigation",
  props: {
    config: { type: Object, required: true },
  },
  data() {
    return {
      items: [
        { title: "段級", to: { name: "swars-histograms-grade", params: {                  }, }, development_only: false, },
        { title: "戦型", to: { name: "swars-histograms-key",   params: { key: "attack"    }, }, development_only: false, },
        { title: "囲い", to: { name: "swars-histograms-key",   params: { key: "defense"   }, }, development_only: false, },
        { title: "手筋", to: { name: "swars-histograms-key",   params: { key: "technique" }, }, development_only: true,  },
        { title: "備考", to: { name: "swars-histograms-key",   params: { key: "note"      }, }, development_only: false, },
      ],
    }
  },
  mounted() {
  },
}
</script>
