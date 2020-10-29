<template lang="pug">
client-only
  .swars-top-group
    MainNavbar
      template(slot="brand")
        NavbarItemHome
        b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'swars-top-group'}")
          | 将棋ウォーズイベント上位プレイヤー
    MainSection
      .container
        .columns
          .column
            b-table(:data="records" :mobile-cards="false" hoverable)
              b-table-column(v-slot="{row}" field="user.name"  label="名前" sortable :width="1" numeric)
                nuxt-link(:to="{name: 'swars-search', query: {query: row.user.key}}" @click.native="sound_play('click')")
                  | {{row.user.name}}
              b-table-column(v-slot="{row}" field="win_ratio"  label="直近の勝敗" sortable cell-class="ox_sequense is_line_break_on")
                | {{row.judge}}
    DebugPre {{records}}
</template>

<script>
export default {
  name: "swars-top-group",
  head() {
    return {
      title: "将棋ウォーズイベント上位プレイヤー",
      meta: [
        { hid: "og:title",       property: "og:title",       content: "将棋ウォーズイベント上位プレイヤー" },
        { hid: "og:image",       property: "og:image",       content: this.$config.MY_NUXT_URL + "/ogp/swars-top-group.png" },
        { hid: "og:description", property: "og:description", content: ""                                                    },
      ],
    }
  },
  async asyncData({ $axios, query }) {
    // http://0.0.0.0:3000/api/top_group.json
    const records = await $axios.$get("/api/top_group.json", {params: query})
    return { records }
  },
  mounted() {
    this.ga_click(`将棋ウォーズイベント上位プレイヤー`)
  },
}
</script>

<style lang="sass">
.swars-top-group
  .MainSection
    padding-top: 1.3rem
</style>
