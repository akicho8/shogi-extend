<template lang="pug">
client-only
  .swars-histograms-key(v-if="xi")
    MainNavbar
      template(slot="brand")
        NavbarItemHome
        b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'swars-histograms-key', params: {key: $route.params.key}}")
          | 将棋ウォーズ{{xi.histogram_name}}分布

    MainSection
      .container
        SwarsHistogramNavigation(:xi="xi")
        //- .columns.is-vcentered.is-multiline.xform_block
        //-   SwarsHistogramSampleCount(:xi="xi")
        .columns.is-centered
          .column.is-7
            CustomChart.is-unselectable(:params="xi.custom_chart_params")
        .columns
          .column
            b-table.mt-3(
              :data="xi.records"
              :mobile-cards="false"
              hoverable
              )
              b-table-column(v-slot="{row}" field="name"            label="名前" sortable) {{row.name}}
              b-table-column(v-slot="{row}" field="count"           label="数" numeric sortable) {{row.count}}
              b-table-column(v-slot="{row}" field="ratio"           label="割合" numeric sortable)
                template(v-if="row.ratio")
                  | {{$gs.floatx100_percentage(row.ratio, 3)}} %
              //- b-table-column(v-slot="{row}" field="deviation_score" label="偏差値" numeric sortable :visible="!!development_p")
              //-   template(v-if="row.deviation_score")
              //-     | {{$gs.number_floor(row.deviation_score, 3)}}
        SwarsHistogramProcessedSecond(:xi="xi")

    //- DebugPre(v-if="development_p") {{xi}}
</template>

<script>
export default {
  name: "swars-histograms-key",
  watchQuery: ["max"],
  async asyncData({$axios, params, query}) {
    const xi = await $axios.$get("/api/swars_histogram.json", {params: {...params, ...query}})
    return { xi }
  },
  computed: {
    meta() {
      return {
        title: `将棋ウォーズ${this.xi.histogram_name}分布`,
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
