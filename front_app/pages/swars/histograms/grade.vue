<template lang="pug">
client-only
  .swars-histograms-grade(v-if="config")
    MainNavbar
      template(slot="brand")
        NavbarItemHome
        b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'swars-histograms-grade'}") 将棋ウォーズ段級分布

    MainSection
      .container
        SwarsHistogramNavigation(:config="config")
        .columns.is-unselectable
          .column.is-6.mt-3
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
              b-table-column(v-slot="{row}" field="count"           label="人数" numeric sortable) {{row.count}}
              //- b-table-column(v-slot="{row}" field="deviation_score" label="偏差値" numeric sortable) {{number_floor(row.deviation_score)}}

            DebugPre {{config}}
</template>

<script>
export default {
  name: "swars-histograms-grade",
  data() {
    return {
      config: null,
    }
  },

  head() {
    return {
      title: "将棋ウォーズ段級分布",
      meta: [
        { hid: "og:title",       property: "og:title",       content: "将棋ウォーズ段級分布"                                   },
        { hid: "og:image",       property: "og:image",       content: this.$config.MY_NUXT_URL + "/ogp/swars-histograms-grade.png" },
        { hid: "og:description", property: "og:description", content: ""                                                         },
      ],
    }
  },
  watch: {
    "$route.query": "$fetch",
  },
  fetch() {
    // http://0.0.0.0:3000/api/swars_grade_histogram.json
    return this.$axios.$get("/api/swars_grade_histogram.json", {params: this.$route.query}).then(e => {
      this.config = e
    })
  },
}
</script>

<style lang="sass">
.swars-histograms-grade
  .MainSection
    padding-top: 1.7rem
</style>
