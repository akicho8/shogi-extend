<template lang="pug">
client-only
  .swars-top-group
    MainNavbar
      template(slot="brand")
        NavbarItemHome
        b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'swars-top-group'}")
          | 将棋ウォーズイベント上位の成績
    MainSection
      .container
        .columns
          .column
            b-table(:data="records" :mobile-cards="false" hoverable)
              b-table-column(v-slot="{row}" field="user.name"  label="名前" sortable :width="1" numeric)
                nuxt-link(:to="{name: 'swars-search', query: {query: row.user.key}}" @click.native="sound_play_click()")
                  | {{row.user.name}}
              b-table-column(v-slot="{row}" field="win_ratio"  label="直近の勝敗" sortable cell-class="ox_sequense is_line_break_on")
                | {{row.judge}}
    DebugPre(v-if="development_p") {{records}}
</template>

<script>
export default {
  name: "swars-top-group",
  async asyncData({ $axios, query }) {
    // http://localhost:3000/api/top_group.json
    const records = await $axios.$get("/api/top_group.json", {params: query})
    return { records }
  },
  mounted() {
    this.ga_click(`将棋ウォーズイベント上位の成績`)
  },
  computed: {
    meta() {
      return {
        title: "将棋ウォーズイベント上位の成績",
        og_image_key: "swars-top-group",
      }
    },
  },
}
</script>

<style lang="sass">
.swars-top-group
  .MainSection
    padding-top: 1.3rem
</style>
