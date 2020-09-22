<template lang="pug">
client-only
  .swars-histograms-key
    b-navbar(type="is-primary")
      template(slot="brand")
        b-navbar-item.has-text-weight-bold(tag="div")
          | 将棋ウォーズ{{config.tactic.name}}ヒストグラム
      template(slot="end")
        b-navbar-item(tag="a" href="/") TOP

    .section
      .columns
        .column
          .buttons
            template(v-for="tactic in config.tactics")
              b-button(tag="nuxt-link" :to="{name: 'swars-histograms-key', params: {key: tactic.key}}" exact-active-class="is-active") {{tactic.name}}

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

          b-table.mt-3(
            :data="config.records"
            :mobile-cards="false"
            hoverable
            )
            b-table-column(v-slot="{row}" field="name"            label="名前" sortable) {{row.name}}
            b-table-column(v-slot="{row}" field="ratio"           label="割合" numeric sortable)
              template(v-if="row.ratio")
                | {{float_to_perc(row.ratio, 3)}} %
            b-table-column(v-slot="{row}" field="deviation_score" label="偏差値" numeric sortable)
              template(v-if="deviation_score")
                | {{number_floor(row.deviation_score, 3)}}
            b-table-column(v-slot="{row}" field="count"           label="個数" numeric sortable) {{row.count}}

          pre(title="DEBUG" v-if="development_p || !!$route.query.debug") {{config}}
</template>

<script>
import dayjs from "dayjs"

export default {
  name: "swars-histograms-key",
  head() {
    return {
      title: `将棋ウォーズ${this.config.tactic.name}ヒストグラム`,
      meta: [
        { hid: "og:title",       property: "og:title",       content: `将棋ウォーズ${this.config.tactic.name}ヒストグラム` },
        { hid: "twitter:card",   property: "twitter:card",   content: "summary_large_image"                                 },
        { hid: "og:image",       property: "og:image",       content: this.$config.MY_OGP_URL + "/ogp/swars-histograms.png" },
        { hid: "og:description", property: "og:description", content: `サンプル数直近:${this.config.sample_count} 最終計測:${this.diff_time_format(this.config.updated_at)}`},
      ],
    }
  },
  mounted() {
    this.sound_play("click")
  },
  async asyncData({ $axios, params }) {
    // http://0.0.0.0:3000/script/swars-histograms.json
    const config = await $axios.$get("/script/swars-histograms.json", {params: params})
    return { config }
  },
}
</script>

<style lang="sass">
.swars-histograms-key
  .section
    padding-top: 1.7rem
</style>
