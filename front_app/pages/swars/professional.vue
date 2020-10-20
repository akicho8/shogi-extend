<template lang="pug">
client-only
  .swars-professional
    MainNavbar
      template(slot="brand")
        NavbarItemHome
        b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'swars-professional'}") 将棋ウォーズ十段の成績
    MainSection
      .container
        .columns
          .column
            b-table(
              :data="records"
              :mobile-cards="false"
              hoverable
              )
              b-table-column(v-slot="{row}" field="user.name"  label="名前" sortable :width="1" numeric)
                nuxt-link(:to="{name: 'swars-search', query: {query: row.user.key}}") {{row.user.name}}
              b-table-column(v-slot="{row}" field="judge"      label="勝敗" sortable cell-class="ox_sequense is_line_break_on")
                | {{row.judge}}
            DebugPre {{records}}
</template>

<script>
export default {
  name: "swars-professional",
  head() {
    return {
      title: "将棋ウォーズ十段の成績",
      meta: [
        { hid: "og:title",       property: "og:title",       content: "将棋ウォーズ十段の成績"                                },
        { hid: "og:image",       property: "og:image",       content: this.$config.MY_NUXT_URL + "/ogp/swars-professional.png" },
        { hid: "og:description", property: "og:description", content: ""                                                      },
      ],
    }
  },
  async asyncData({ $axios, query }) {
    // http://0.0.0.0:3000/api/professional.json
    const records = await $axios.$get("/api/professional.json", {params: query})
    return { records }
  },
}
</script>

<style lang="sass">
.swars-professional
  .MainSection
    padding-top: 1.3rem
</style>
