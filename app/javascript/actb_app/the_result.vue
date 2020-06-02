<template lang="pug">
.the_result
  .win_lose_container.has-text-centered.is-size-3.has-text-weight-bold
    template(v-if="app.current_membership.judge.key === 'win'")
      .has-text-danger
        | YOU WIN !
    template(v-if="app.current_membership.judge.key === 'lose'")
      .has-text-success
        | YOU LOSE !
    template(v-if="app.current_membership.judge.key === 'draw'")
      .has-text-info
        | DRAW !
  .final_container.has-text-centered.is-size-7(v-if="app.battle.final.key === 'f_disconnect'")
    | {{app.battle.final.name}}

  .vs_container.is-flex
    template(v-for="(membership, i) in app.battle.memberships")
      the_result_membership(:membership="membership")
      .is-1.has-text-weight-bold.is-size-4.has-text-grey-light(v-if="i === 0") vs

  .footer_container
    .buttons.is-centered
      b-button.has-text-weight-bold(@click="app.battle_continue_handle" :type="app.battle_continue_tap_counts[app.current_membership.id] ? 'is-primary' : ''") つづける
      b-button.has-text-weight-bold(@click="app.yameru_handle") やめる

  .columns.is-mobile(v-if="development_p")
    .column
      .buttons.is-centered.are-small
        b-button(@click="app.battle_continue_force_handle") 強制的に続行

  debug_print(:vars="['app.member_infos_hash']" v-if="development_p")
  debug_print(:vars="['app.battle_continue_tap_counts', 'app.battle_count', 'app.battle.rensen_index', 'app.score_debug_info']" v-if="development_p")
</template>

<script>
import { support } from "./support.js"
import the_result_membership from "./the_result_membership.vue"

export default {
  mixins: [
    support,
  ],
  components: {
    the_result_membership,
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_result
  margin-top: 4.5rem

  .win_lose_container

  .vs_container
    justify-content: center
    align-items: center

  // 続ける
  .footer_container
    margin-top: 1rem
    .buttons
      flex-direction: column
      .button
        min-width: 12rem
        &:not(:first-child)
          margin-top: 0.75rem
</style>
