<template lang="pug">
client-only
  .swars-grade-histogram
    b-navbar(type="is-primary")
      template(slot="brand")
        b-navbar-item.has-text-weight-bold(tag="div") 将棋ウォーズ段級位分布
      template(slot="end")
        b-navbar-item(tag="a" href="/") TOP

    .section
      .columns.is-unselectable
        .column.is-4
          CustomChart(:params="config.custom_chart_params")
      .columns
        .column
          b-table(
            :data="config.records"
            :mobile-cards="false"
            hoverable
            )
            b-table-column(v-slot="{row}" field="grade.priority"  label="段級" sortable) {{row.grade.key}}
            b-table-column(v-slot="{row}" field="ratio"           label="割合" numeric sortable) {{float_to_perc(row.ratio, 2)}} %
            b-table-column(v-slot="{row}" field="deviation_score" label="偏差値" numeric sortable) {{number_floor(row.deviation_score)}}
            b-table-column(v-slot="{row}" field="count"           label="人数" numeric sortable :visible="development_p || !!$route.query.debug") {{row.count}}

          pre(title="DEBUG" v-if="development_p || !!$route.query.debug") {{config}}
</template>

<script>
export default {
  name: "swars-grade-histogram",
  head() {
    return {
      title: "将棋ウォーズ段級位分布",
      meta: [
        { hid: "og:title",       property: "og:title",       content: "将棋ウォーズ段級位分布"                                   },
        { hid: "twitter:card",   property: "twitter:card",   content: "summary_large_image"                                      },
        { hid: "og:image",       property: "og:image",       content: this.$config.MY_OGP_URL + "/ogp/swars-grade-histogram.png" },
        { hid: "og:description", property: "og:description", content: ""                                                         },
      ],
    }
  },
  async asyncData({ $axios, query }) {
    // http://0.0.0.0:3000/api/swars_grade_histogram.json
    const config = await $axios.$get("/api/swars_grade_histogram.json", {params: query})
    return { config }
  },
}
</script>

<style lang="sass">
.swars-grade-histogram
  .section
    padding-top: 2.6rem
</style>
