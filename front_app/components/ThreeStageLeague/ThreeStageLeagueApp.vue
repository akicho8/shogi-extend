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

  .section.pt-5
    .columns
      .column
        .box.is-shadowless.is-inline-block.is-marginless
          .buttons.are-small
            template(v-for="league in config.leagues.slice().reverse()")
              //- exact-active-class="is-primary"
              b-button(tag="nuxt-link" :to="{name: 'three-stage-league', query: {generation: league.generation}}" :class="{'is-primary': config.league.generation === league.generation}")
                | {{league.generation}}

        b-table(
          :data="config.memberships"
          :mobile-cards="false"
          hoverable
          )
          b-table-column(v-slot="{row}" field="age"        label="名前" sortable)
            nuxt-link(:to="{name: 'three-stage-league-player', query: {name: row.user.name}}" :class="{'has-text-weight-bold': row.break_through_p}")
              | {{row.name_with_age}}
          b-table-column(v-slot="{row}" field="win"        label="勝"   numeric sortable) {{row.win}}
          b-table-column(v-slot="{row}" field="win"        label="勝敗" sortable)
            | {{row.ox_human}}
            template(v-if="row.result_mark")
              template(v-if="row.result_mark === '昇'")
                span.ml-1.has-text-danger {{row.result_mark}}
              template(v-else)
                span.ml-1.has-text-grey {{row.result_mark}}

          b-table-column(v-slot="{row}" field="seat_count" label="在" numeric sortable) {{row.seat_count}} / {{row.user.memberships_count}}

          b-table-column(v-slot="{row}")
            a(:href="user_image_search_url(row)" target="_blank")
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
      padding: 0 0.25rem 0
    .column
      padding: 0
      margin: 1rem
</style>
