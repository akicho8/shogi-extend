<template lang="pug">
.ThreeStageLeaguePlayerApp
  DebugBox
    p http://0.0.0.0:3000/api/three_stage_league_player
    p http://0.0.0.0:3000/api/three_stage_league_player?name=西山朋佳

  b-navbar(type="is-primary")
    template(slot="brand")
      b-navbar-item.has-text-weight-bold(tag="div") {{config.main_user.name_with_age}}
    template(slot="end")
      b-navbar-item(tag="a" :href="image_search_url(config.main_user.name)" target="_blank") ぐぐる
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
            nuxt-link(:to="{name: 'three-stage-leagues-generation', params: {generation: row.league.generation}}" @click.native="sound_play('click')")
              | {{row.league.generation}}
          //- b-table-column(v-slot="{row}" field="seat_count"        label="在" numeric sortable) {{row.seat_count}} / {{row.user.memberships_count}}
          b-table-column(v-slot="{row}" field="age"               label="歳" numeric sortable) {{row.age}}
          b-table-column(v-slot="{row}" field="win"               label="勝" numeric sortable) {{row.win}}
          b-table-column.ox_sequense.is_line_break_on(v-slot="{row}" field="win"               label="勝敗" sortable)
            | {{row.ox_human}}
            ThreeStageLeagueMark(:record="row")

      .column
        .buttons.are-small
          template(v-for="user in config.users")
            //- exact-active-class="is-primary"
            b-button(tag="nuxt-link" :to="{name: 'three-stage-league-players-name', params: {name: user.name}}" :class="{'is-active': config.main_user.name === user.name, 'has-text-weight-bold': (user.level_up_generation || user.runner_up_count >= 2)}" @click.native="sound_play('click')")
              | {{user.name}}
</template>

<script>
import { support } from "./support.js"

export default {
  name: "ThreeStageLeaguePlayerApp",
  mixins: [
    support,
  ],
  props: {
    config: { type: Object, required: true },
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
