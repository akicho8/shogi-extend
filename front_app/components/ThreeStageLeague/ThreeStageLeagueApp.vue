<template lang="pug">
.ThreeStageLeagueApp
  DebugBox(v-if="development_p")
    p http://0.0.0.0:3000/api/three_stage_league
    p http://0.0.0.0:4000/three-stage-leagues/67
    p http://0.0.0.0:4000/three-stage-leagues/28

  MainNavbar
    template(slot="brand")
      NavbarItemHome
      b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'three-stage-leagues', params: {generation: config.league.generation}}") {{config.page_title}}
    template(slot="end")
      b-navbar-item.has-text-weight-bold(tag="a" :href="config.league.source_url" :target="target_default") 本家

  MainSection
    .container
      .columns
        .column
          .box.is-shadowless.is-inline-block.is-marginless
            .buttons.are-small
              template(v-for="league in config.leagues")
                //- exact-active-class="is-primary"
                b-button(tag="nuxt-link" :to="{name: 'three-stage-leagues-generation', params: {generation: league.generation}}" exact-active-class="is-primary" @click.native="sound_play('click')")
                  | {{league.generation}}

          b-table(
            :data="config.memberships"
            :mobile-cards="false"
            hoverable
            )
            b-table-column(v-slot="{row}" field="age"        label="名前" sortable)
              nuxt-link(:to="{name: 'three-stage-league-players-name', params: {name: row.user.name}}" :class="{'has-text-weight-bold': row.user.level_up_generation || row.user.runner_up_count >= 2}" @click.native="sound_play('click')")
                | {{row.name_with_age}}
                ThreeStageLeagueMark(:record="row")

            b-table-column(v-slot="{row}" field="win"        label="勝"   numeric sortable) {{row.win}}
            b-table-column(v-slot="{row}" field="win"        label="勝敗" sortable cell-class="ox_sequense is_line_break_on")
              | {{row.ox_human}}

            b-table-column(v-slot="{row}" field="seat_count" label="在籍" numeric sortable)
              | {{row.seat_count}} / {{row.user.memberships_count}}
              //- span.is-hidden-tablet
              //-   | {{row.seat_count}} / {{row.user.memberships_count}}
              //- span.is-hidden-mobile
              //-   template(v-for="win in row.zaiseki_win_list")
              //-     span.mx-1 {{win}}

            b-table-column(v-slot="{row}")
              a.no-decoration.has-text-grey(:href="image_search_url(row.user.name)" target="_blank" @click="sound_play('click')")
                b-icon(icon="account-question" size="is-small")
  DebugPre {{config}}
</template>

<script>
import { support } from "./support.js"

export default {
  name: "ThreeStageLeagueApp",
  mixins: [
    support,
  ],
  props: {
    config: { type: Object, required: true },
  },
  mounted() {
    this.ga_click("三段リーグ早見表")
    this.talk(this.config.league.generation)
  },
}
</script>

<style lang="sass">
.ThreeStageLeagueApp
  .MainSection.section
    +mobile
      padding-right: 0.25rem
      padding-left: 0.25rem
</style>
