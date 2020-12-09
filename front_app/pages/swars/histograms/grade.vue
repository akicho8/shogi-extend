<template lang="pug">
client-only
  .swars-histograms-grade(v-if="config")
    MainNavbar
      template(slot="brand")
        NavbarItemHome
        b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'swars-histograms-grade', params: {key: $route.params.key}}")
          | 将棋ウォーズ{{config.histogram_name}}分布

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

    //- DebugPre {{config}}
</template>

<script>
export default {
  name: "swars-histograms-grade",
  watchQuery: ["max"],
  async asyncData({$axios, params, query}) {
    // http://0.0.0.0:3000/api/swars_grade_histogram.json
    const config = await $axios.$get("/api/swars_histogram.json", {params: {...params, ...query, key: "grade"}})
    return { config }
  },
  mounted() {
    // this.ga_click(`段級分布`)
    this.ga_click(`データ分布`)
  },
  computed: {
    meta() {
      return {
        title: `将棋ウォーズ${this.config.histogram_name}分布`,
        og_description: "",
        og_image_key: "swars-histograms-attack",
      }
    },
  },
}
</script>

<style lang="sass">
.swars-histograms-grade
  .MainSection
    padding-top: 1.7rem
</style>
