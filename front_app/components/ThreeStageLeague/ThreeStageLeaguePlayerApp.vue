<template lang="pug">
.ThreeStageLeaguePlayerApp
  b-navbar(type="is-primary")
    template(slot="brand")
      b-navbar-item.has-text-weight-bold {{config.main_user.name_with_age}}
    template(slot="end")
      b-navbar-item(tag="a" href="/") TOP

  .section
    .columns
      .column
        ThreeStageLeaguePlayerChart(:config="config")
        b-table.mt-3(
          :data="config.memberships"
          :mobile-cards="false"
          hoverable
          )
          b-table-column(v-slot="{row}" field="league.generation" label="期" numeric sortable)
            nuxt-link(:to="{name: 'three-stage-league', query: {generation: row.league.generation}}")
              | {{row.league.generation}}
          b-table-column(v-slot="{row}" field="seat_count"        label="在" numeric sortable) {{row.seat_count}} / {{row.user.memberships_count}}
          b-table-column(v-slot="{row}" field="age"               label="歳" numeric sortable) {{row.age}}
          b-table-column(v-slot="{row}" field="win"               label="勝" numeric sortable) {{row.win}}
          b-table-column(v-slot="{row}" field="win"               label="勝敗" sortable)
            | {{row.ox_human}}
            template(v-if="row.result_mark")
              template(v-if="row.result_mark === '昇'")
                span.ml-1.has-text-danger {{row.result_mark}}
              template(v-else)
                span.ml-1.has-text-grey {{row.result_mark}}

        .box.is-shadowless.is-inline-block.is-marginless.mt-6
          .buttons.are-small
            template(v-for="user in config.users.slice().reverse()")
              //- exact-active-class="is-primary"
              b-button(tag="nuxt-link" :to="{name: 'three-stage-league-player', query: {user_name: user.name}}" :class="{'is-primary': config.main_user.name === user.name, 'is-primary is-light': user.break_through_generation}")
                | {{user.name}}
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
