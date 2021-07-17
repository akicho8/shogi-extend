<template lang="pug">
client-only
  .swars-histograms-key(v-if="config")
    MainNavbar
      template(slot="brand")
        NavbarItemHome
        b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'swars-histograms-key', params: {key: $route.params.key}}")
          | 将棋ウォーズ{{config.histogram_name}}分布

    MainSection
      .container
        SwarsHistogramNavigation(:config="config")
        .columns.is-unselectable
          .column.is-6.mt-3
            CustomChart(:params="config.custom_chart_params")
        .columns
          .column
            b-table.mt-3(
              :data="config.records"
              :mobile-cards="false"
              hoverable
              )
              b-table-column(v-slot="{row}" field="name"            label="名前" sortable) {{row.name}}
              b-table-column(v-slot="{row}" field="ratio"           label="割合" numeric sortable)
                template(v-if="row.ratio")
                  | {{float_to_perc(row.ratio, 3)}} %
              //- b-table-column(v-slot="{row}" field="deviation_score" label="偏差値" numeric sortable :visible="!!development_p")
              //-   template(v-if="row.deviation_score")
              //-     | {{number_floor(row.deviation_score, 3)}}
              b-table-column(v-slot="{row}" field="count"           label="数" numeric sortable) {{row.count}}

    //- DebugPre(v-if="development_p") {{config}}
</template>

<script>
export default {
  name: "swars-histograms-key",
  watchQuery: ["max"],
  async asyncData({$axios, params, query}) {
    // http://localhost:3000/api/swars_histogram.json
    const config = await $axios.$get("/api/swars_histogram.json", {params: {...params, ...query}})
    return { config }
  },
  mounted() {
    // this.ga_click(`${this.config.histogram_name}分布`)
    this.ga_click(`データ分布`)
  },
  computed: {
    meta() {
      return {
        title: `将棋ウォーズ${this.config.histogram_name}分布`,
        og_image_key: "swars-histograms-attack",
      }
    },
  },
}
</script>

<style lang="sass">
.swars-histograms-key
  .MainSection
    padding-top: 1.7rem
</style>
