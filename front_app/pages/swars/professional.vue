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
            b-table(:data="records" :mobile-cards="false" hoverable)
              b-table-column(v-slot="{row}" field="user.name"  label="名前" sortable :width="1" numeric)
                nuxt-link(:to="{name: 'swars-search', query: {query: row.user.key}}" @click.native="sound_play('click')") {{row.user.name}}
              b-table-column(v-slot="{row}" field="judge"      label="勝敗" sortable cell-class="ox_sequense is_line_break_on")
                | {{row.judge}}
    DebugPre(v-if="development_p") {{records}}
</template>

<script>
export default {
  name: "swars-professional",
  async asyncData({ $axios, query }) {
    // http://0.0.0.0:3000/api/professional.json
    const records = await $axios.$get("/api/professional.json", {params: query})
    return { records }
  },
  mounted() {
    this.ga_click(`将棋ウォーズ十段の成績`)
  },
  computed: {
    meta() {
      return {
        title: "将棋ウォーズ十段の成績",
        og_description: "",
        og_image_key: "swars-professional",
      }
    },
  },
}
</script>

<style lang="sass">
.swars-professional
  .MainSection
    padding-top: 1.3rem
</style>
