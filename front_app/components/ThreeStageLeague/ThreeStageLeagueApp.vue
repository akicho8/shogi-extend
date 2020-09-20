<template lang="pug">
.ThreeStageLeagueApp
  DebugBox
    p http://0.0.0.0:3000/api/three_stage_league
    p http://0.0.0.0:4000/three-stage-leagues/67
    p http://0.0.0.0:4000/three-stage-leagues/28

  b-navbar(type="is-primary")
    template(slot="brand")
      b-navbar-item.has-text-weight-bold(tag="div") {{config.page_title}}
    template(slot="end")
      b-navbar-item(tag="a" :href="config.league.source_url" target="_blank") 本家
      b-navbar-item(tag="a" href="/") TOP

  .section.pt-5
    .columns
      .column.pt-0
        .box.is-shadowless.is-inline-block.is-marginless
          .buttons.are-small
            template(v-for="league in config.leagues.slice().reverse()")
              //- exact-active-class="is-primary"
              b-button(tag="nuxt-link" :to="{name: 'three-stage-leagues-generation', params: {generation: league.generation}}" :class="{'is-active': config.league.generation === league.generation}" @click.native="sound_play('click')")
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
          b-table-column.ox_sequense.is_line_break_on(v-slot="{row}" field="win"        label="勝敗" sortable)
            | {{row.ox_human}}

          b-table-column(v-slot="{row}" field="seat_count" label="在" numeric sortable) {{row.seat_count}} / {{row.user.memberships_count}}

          b-table-column(v-slot="{row}")
            a(:href="image_search_url(row.user.name)" target="_blank")
              b-icon(icon="account-question")
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
    this.talk(this.config.league.generation)
  },
}
</script>

<style lang="sass">
.ThreeStageLeagueApp
  +mobile
    .section
      padding-right: 0.25rem
      padding-left: 0.25rem
</style>
