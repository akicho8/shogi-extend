<template lang="pug">
.ThreeStageLeaguePlayerApp
  b-navbar(type="is-primary")
    template(slot="brand")
      b-navbar-item.has-text-weight-bold {{config.current_user_name}}
    template(slot="end")
      b-navbar-item(tag="a" href="/") TOP

  .section
    .columns
      .column
        ThreeStageLeaguePlayerChart(:config="config")
        b-table(
          :data="config.memberships"
          :mobile-cards="false"
          :narrowed="false"
          hoverable
          )
          b-table-column(v-slot="{row}" field="league.generation" label="期" numeric sortable) {{row.league.generation}}
          b-table-column(v-slot="{row}" field="seat_count"        label="在" numeric sortable) {{row.seat_count}} / {{row.user.memberships_count}}
          b-table-column(v-slot="{row}" field="age"               label="歳" numeric sortable) {{row.age}}
          b-table-column(v-slot="{row}" field="win"               label="勝" numeric sortable) {{row.win}}
          b-table-column(v-slot="{row}" field="win"               label="勝敗" sortable) {{row.ox_human}}
</template>

<script>
import { store }   from "./store.js"
import { support } from "./support.js"

export default {
  store,
  name: "ThreeStageLeaguePlayerApp",
  mixins: [
    support,
  ],
  components: {
  },
  props: {
    config: { type: Object, required: true },
  },
  data() {
    return {
    }
  },
  methods: {
    user_image_search_url(row) {
      const url = new URL("https://www.google.co.jp/search")
      url.searchParams.set("query", [row.user.name, "将棋"].join(" "))
      return url.toString()
    },
  },

  computed: {
  },
}
</script>

<style lang="sass">
.ThreeStageLeaguePlayerApp
  +mobile
    .section
      padding: 2.8rem 0.5rem 0
    .column
      padding: 0
      margin: 1.25rem
</style>
