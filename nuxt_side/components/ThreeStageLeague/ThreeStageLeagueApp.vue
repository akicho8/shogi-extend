<template lang="pug">
.ThreeStageLeagueApp
  DebugBox(v-if="development_p")
    p http://localhost:3000/api/three_stage_league
    p http://localhost:4000/three-stage-leagues/67
    p http://localhost:4000/three-stage-leagues/28

  MainNavbar
    template(slot="brand")
      NavbarItemHome
      b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'three-stage-leagues', params: {generation: config.league.generation}}") {{config.page_title}}
    template(slot="end")
      b-navbar-item.has-text-weight-bold(tag="a" :href="config.league.source_url" :target="target_default") 本家

  MainSection
    .container
      .columns.is-gapless
        .column
          .box.is-shadowless.is-inline-block.is-marginless
            .buttons.are-small
              template(v-for="league in config.leagues")
                b-button(tag="nuxt-link" :to="{name: 'three-stage-leagues-generation', params: {generation: league.generation}}" exact-active-class="is-primary" @click.native="$sound.play_click()")
                  | {{league.generation}}

          b-table(
            :data="config.memberships"
            :mobile-cards="false"
            hoverable
            )
            b-table-column(v-slot="{row}" field="age"        label="名前" sortable)
              nuxt-link(:to="{name: 'three-stage-league-players-name', params: {name: row.user.name}}" :class="{'has-text-weight-bold': row.user.level_up_generation || row.user.runner_up_count >= 2}" @click.native="$sound.play_click()")
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
              a.is_decoration_off.has-text-grey(:href="image_search_url(row.user.name)" target="_blank" @click="$sound.play_click()")
                b-icon(icon="account-question" size="is-small")
  DebugPre(v-if="development_p") {{config}}
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
    this.app_log("三段リーグ早見表")
    this.talk(this.config.league.generation)
  },
}
</script>

<style lang="sass">
.ThreeStageLeagueApp
  .MainSection.section
    padding: 0
    +tablet
      padding: 0.5rem 0
</style>
