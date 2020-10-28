<template lang="pug">
client-only
  .swars-histograms-key(v-if="config")
    MainNavbar
      template(slot="brand")
        NavbarItemHome
        b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'swars-histograms-key', params: {key: $route.params.key}}")
          | 将棋ウォーズ{{config.tactic.name}}分布

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

    //- DebugPre {{config}}
</template>

<script>
export default {
  name: "swars-histograms-key",
  data() {
    return {
      config: null,
    }
  },
  watch: {
    "$route.query": "$fetch",
  },
  fetch() {
    // http://0.0.0.0:3000/api/swars_histogram.json
    return this.$axios.$get("/api/swars_histogram.json", {params: {...this.$route.params, ...this.$route.query}}).then(e => {
      this.config = e
    })
  },
  head() {
    if (!this.config) {
      return
    }
    return {
      title: `将棋ウォーズ${this.config.tactic.name}分布`,
      meta: [
        { hid: "og:title",       property: "og:title",       content: `将棋ウォーズ${this.config.tactic.name}分布` },
        { hid: "og:image",       property: "og:image",       content: this.$config.MY_NUXT_URL + "/ogp/swars-histograms-attack.png" },
        { hid: "og:description", property: "og:description", content: ""},
      ],
    }
  },
}
</script>

<style lang="sass">
.swars-histograms-key
  .MainSection
    padding-top: 1.7rem
</style>
