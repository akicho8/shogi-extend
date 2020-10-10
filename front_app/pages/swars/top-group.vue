<template lang="pug">
client-only
  .swars-top-group
    b-navbar(type="is-primary" wrapper-class="container" :mobile-burger="false" spaced)
      template(slot="brand")
        HomeNavbarItem
        b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'swars-top-group'}")
          | 将棋ウォーズイベント上位プレイヤー
    .section
      .container
        .columns
          .column
            b-table(:data="records" :mobile-cards="false" hoverable)
              b-table-column(v-slot="{row}" field="user.name"  label="名前" sortable :width="1" numeric)
                nuxt-link(:to="{name: 'swars-battles', query: {query: row.user.key}}") {{row.user.name}}
              b-table-column(v-slot="{row}" field="win_ratio"  label="直近の勝敗" sortable cell-class="ox_sequense is_line_break_on")
                | {{row.judge}}
            pre(title="DEBUG" v-if="development_p || !!$route.query.debug") {{records}}
</template>

<script>
export default {
  name: "swars-top-group",
  head() {
    return {
      title: "将棋ウォーズイベント上位プレイヤー",
      meta: [
        { hid: "og:title",       property: "og:title",       content: "将棋ウォーズイベント上位プレイヤー"                                },
        { hid: "og:image",       property: "og:image",       content: this.$config.MY_OGP_URL + "/ogp/swars-top-group.png" },
        { hid: "og:description", property: "og:description", content: ""                                                    },
      ],
    }
  },
  async asyncData({ $axios, query }) {
    // http://0.0.0.0:3000/api/top_group.json
    const records = await $axios.$get("/api/top_group.json", {params: query})
    return { records }
  },
}
</script>

<style lang="sass">
.swars-top-group
  .section
    padding-top: 1.3rem
</style>
