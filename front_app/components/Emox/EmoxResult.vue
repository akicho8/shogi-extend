<template lang="pug">
.EmoxResult
  a.delete.page_delete.is-large.is_top_left_fixed(@click="base.room_leave_handle")

  .block.has-text-centered.is-size-3.has-text-weight-bold.mt-6
    template(v-if="base.current_membership.judge.key === 'win'")
      .has-text-danger
        | YOU WIN !
    template(v-if="base.current_membership.judge.key === 'lose'")
      .has-text-success
        | YOU LOSE !
    template(v-if="base.current_membership.judge.key === 'draw'")
      .has-text-info
        | DRAW !

  .block.has-text-centered.is-size-7(v-if="base.battle.final.key === 'f_disconnect' || base.battle.final.key === 'f_timeout'")
    | {{base.battle.final.name}}

  .block.is-flex.is-justify-content-center(v-if="development_p")
    b-button(tag="nuxt-link" :to="{name: 'share-board', query: {body: base.vs_share_sfen, image_view_point: 'black'}}" size="is-small" type="is-text") 棋譜

  .box.is-shadowless(v-if="development_p")
    .buttons.is-centered.are-small
      b-button(@click="base.battle_unsubscribe") バトル切断(自分)
      b-button(@click="base.member_disconnect_handle(true)") バトル切断風にする(相手)
</template>

<script>
import { support } from "./support.js"

export default {
  mixins: [
    support,
  ],
  props: {
    base: { type: Object, required: true, },
  },
}
</script>

<style lang="sass">
@import "./support.sass"
.EmoxResult
  .is_top_left_fixed
    position: fixed
    top: 0.5rem
    left: 0.5rem
</style>
