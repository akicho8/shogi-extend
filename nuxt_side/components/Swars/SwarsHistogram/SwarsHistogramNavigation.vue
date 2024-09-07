<template lang="pug">
.columns
  .column
    .buttons.are-small
      template(v-for="item in items")
        template(v-if="!development_p && item.development_only")
        template(v-else)
          //- :to="{...item.to, query: {max: current_max}}"
          b-button(
            tag="nuxt-link"
            :to="{...item.to, query: {}}"
            :class="{'is-active': item.to.params.key === $route.params.key}"
            @click.native="$sound.play_click()")
            | {{item.title}}
  .column
    .level.is-mobile.mb-0
      .level-left
        .level-item.has-text-centered
          div
            .head.is-size-7 最終計測
            .title.is-size-6 {{$time.format_diff(xi.updated_at)}}
        .level-item.has-text-centered
          div
            .head.is-size-7 サンプル数直近
            .title.is-size-6.has-text-weight-normal
              template(v-for="max in xi.max_list")
                nuxt-link.px-1(
                  :to="{name: $route.name, params: $route.params, query: {...$route.query, max: max}}"
                  :class="{'has-text-weight-bold': current_max === max}"
                  @click.native="$sound.play_click()")
                  | {{max}}
</template>

<script>
export default {
  name: "SwarsHistogramNavigation",
  props: {
    xi: { type: Object, required: true },
  },
  data() {
    return {
      items: [
        { title: "戦法", to: { name: "swars-histograms-key",   params: { key: "attack"    }, }, development_only: false, },
        { title: "囲い", to: { name: "swars-histograms-key",   params: { key: "defense"   }, }, development_only: false, },
        { title: "手筋", to: { name: "swars-histograms-key",   params: { key: "technique" }, }, development_only: true,  },
        { title: "備考", to: { name: "swars-histograms-key",   params: { key: "note"      }, }, development_only: false, },
      ],
    }
  },
  computed: {
    current_max() {
      return Number(this.$route.query.max || this.xi.default_limit)
    },
  },
}
</script>
