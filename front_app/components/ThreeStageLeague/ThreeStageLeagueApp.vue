<template lang="pug">
.ThreeStageLeagueApp
  DebugBox
    p OK

  b-navbar(type="is-primary")
    template(slot="brand")
      b-navbar-item.has-text-weight-bold {{config.page_title}}
    template(slot="end")
      b-navbar-item(tag="a" :href="config.league.source_url" target="_blank") 本家
      b-navbar-item(tag="a" href="/") TOP

  //- b-navbar(type="is-dark" fixed-bottom v-if="development_p")
  //-   template(slot="start")
  //-     | OK

  .section
    .columns
      .column
        b-table(
          :data="config.memberships"
          :mobile-cards="false"
          :narrowed="false"
          hoverable
          )
          b-table-column(v-slot="props" field="age"        label="名前" sortable)
            nuxt-link(:to="{name: 'three-stage-league-player', query: {user_name: props.row.user.name}}") {{props.row.name_with_age}}
          b-table-column(v-slot="props" field="win"        label="勝"   numeric sortable) {{props.row.win}}
          b-table-column(v-slot="props" field="win"        label="勝敗" sortable) {{props.row.ox_human}}
          b-table-column(v-slot="props" field="seat_count" label="在" numeric sortable) {{props.row.seat_count}} / {{props.row.user.memberships_count}}
          b-table-column(v-slot="props")
            a(:href="user_image_search_url(props.row)" target="_blank")
              b-icon(icon="account-question")
</template>

<script>
import { store }   from "./store.js"
import { support } from "./support.js"

export default {
  store,
  name: "ThreeStageLeagueApp",
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
.ThreeStageLeagueApp
  +mobile
    .section
      padding: 2.8rem 0.5rem 0
    .column
      padding: 0
      margin: 1.25rem
</style>
