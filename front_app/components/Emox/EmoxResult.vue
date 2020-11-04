<template lang="pug">
.EmoxResult
  a.delete.page_delete.is-large.is_top_left_fixed(@click="base.room_leave_handle")

  .win_lose_container.has-text-centered.is-size-3.has-text-weight-bold.mt-5
    template(v-if="base.current_membership.judge.key === 'win'")
      .has-text-danger
        | YOU WIN !
    template(v-if="base.current_membership.judge.key === 'lose'")
      .has-text-success
        | YOU LOSE !
    template(v-if="base.current_membership.judge.key === 'draw'")
      .has-text-info
        | DRAW !

  .final_container.has-text-centered.is-size-7(v-if="base.battle.final.key === 'f_disconnect' || base.battle.final.key === 'f_timeout'")
    | {{base.battle.final.name}}

  .box.is-shadowless(v-if="base.debug_read_p")
    .buttons.is-centered.are-small
      b-button(@click="base.battle_leave_handle(false)") 退出通知(自分)
      b-button(@click="base.battle_leave_handle(true)") 退出通知(相手)
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
</style>
