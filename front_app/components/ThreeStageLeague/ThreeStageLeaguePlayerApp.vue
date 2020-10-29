<template lang="pug">
.ThreeStageLeaguePlayerApp
  DebugBox
    p http://0.0.0.0:3000/api/three_stage_league_player
    p http://0.0.0.0:3000/api/three_stage_league_player?name=西山朋佳

  MainNavbar
    template(slot="brand")
      NavbarItemHome(icon="chevron-left" :to="{name: 'three-stage-leagues-generation', params: {generation: latest_generation}}")
      b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'three-stage-league-players-name', params: {name: config.main_user.name}}") {{config.main_user.name_with_age}}
    template(slot="end")
      b-navbar-item.has-text-weight-bold(tag="a" :href="image_search_url(config.main_user.name)" target="_blank") ぐぐる

  MainSection
    .container
      .columns
        .column
          ThreeStageLeaguePlayerChart(:config="config")
          b-table.mt-3(:data="config.memberships" :mobile-cards="false" hoverable)
            b-table-column(v-slot="{row}" field="league.generation" label="期" numeric sortable)
              nuxt-link(:to="{name: 'three-stage-leagues-generation', params: {generation: row.league.generation}}" @click.native="sound_play('click')")
                | {{row.league.generation}}
            //- b-table-column(v-slot="{row}" field="seat_count"        label="在" numeric sortable) {{row.seat_count}} / {{row.user.memberships_count}}
            b-table-column(v-slot="{row}" field="age"               label="歳" numeric sortable) {{row.age}}
            b-table-column(v-slot="{row}" field="win"               label="勝" numeric sortable) {{row.win}}
            b-table-column(v-slot="{row}" field="win"               label="勝敗" sortable cell-class="ox_sequense is_line_break_on")
              | {{row.ox_human}}
              ThreeStageLeagueMark(:record="row")

        .column
          .buttons.are-small
            template(v-for="user in config.users")
              b-button(tag="nuxt-link" :to="{name: 'three-stage-league-players-name', params: {name: user.name}}" :class="{'has-text-weight-bold': (user.level_up_generation || user.runner_up_count >= 2)}" exact-active-class="is-active")
                | {{user.name}}

  DebugPre {{config}}
</template>

<script>
import { support } from "./support.js"
import _ from "lodash"

export default {
  name: "ThreeStageLeaguePlayerApp",
  mixins: [
    support,
  ],
  props: {
    config: { type: Object, required: true },
  },
  mounted() {
    this.ga_click("三段リーグ早見表(個人成績)")
    this.talk(this.config.main_user.name)
  },
  computed: {
    // 参加した最後のリーグ
    latest_generation() {
      if (this.config) {
        return _.last(this.config.memberships).league.generation
      }
    },
  },
}
</script>

<style lang="sass">
.ThreeStageLeaguePlayerApp
  .MainSection
    +mobile
      padding-left: 0.5rem
      padding-right: 0.5rem
</style>
