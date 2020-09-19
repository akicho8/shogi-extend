<template lang="pug">
.ThreeStageLeaguePlayerApp
  DebugBox
    p http://0.0.0.0:3000/api/three_stage_league_player
    p http://0.0.0.0:3000/api/three_stage_league_player?name=西山朋佳

  b-navbar(type="is-primary")
    template(slot="brand")
      b-navbar-item.has-text-weight-bold(tag="div") {{config.main_user.name_with_age}}
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
            nuxt-link(:to="{name: 'three-stage-league', query: {generation: row.league.generation}}" @click.native="sound_play('click')")
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
            template(v-for="user in config.users")
              //- exact-active-class="is-primary"
              b-button(tag="nuxt-link" :to="{name: 'three-stage-league-player', query: {name: user.name}}" :class="{'is-active': config.main_user.name === user.name, 'has-text-weight-bold': user.break_through_generation}" @click.native="sound_play('click')")
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
      padding-left: 0.5rem
      padding-right: 0.5rem
</style>
