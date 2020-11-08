<template lang="pug">
.ActbResultApp
  a.delete.page_delete.is-large.is_top_left_fixed(@click="base.room_leave_handle")
  ActbRoomEmotion(:base="base")

  template(v-if="base.room.bot_user_id")
    .has-text-centered.is-size-4.has-text-weight-bold.mt-5
      | おしまい

  template(v-if="!base.room.bot_user_id")
    .win_lose_container.has-text-centered.is-size-3.has-text-weight-bold.mt-5
      template(v-if="base.room.bot_user_id")
        .has-text-primary
          | 練習おわり
      template(v-else)
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

  .vs_container.mt-2.is-flex
    template(v-for="(membership, i) in base.ordered_memberships")
      ActbResultMembership(:membership="membership")
      .is-1.has-text-weight-bold.is-size-4.has-text-grey-light(v-if="i === 0") vs

  .saisen_suru_container.mt-4
    .buttons.is-centered
      b-button.has-text-weight-bold(:disabled="!all_active_p" @click="base.battle_continue_handle(false)" :type="button_push_by_self_p ? 'is-primary' : ''" type="is-large") 再戦

  ActbRoomMessage.mt-5

  .box.is-shadowless(v-if="base.debug_read_p")
    .buttons.is-centered.are-small
      b-button(@click="base.battle_continue_handle(true)") 同じ相手と再戦する(相手)
      b-button(@click="base.battle_continue_force_handle") 強制的に続行
      b-button(@click="base.battle_leave_handle(false)") 退出通知(自分)
      b-button(@click="base.battle_leave_handle(true)") 退出通知(相手)
      b-button(@click="base.battle_unsubscribe") バトル切断(自分)
      b-button(@click="base.member_disconnect_handle(true)") バトル切断風にする(相手)

  DebugPrint(v-if="base.debug_read_p" :vars="['base.member_infos_hash']")
  DebugPrint(v-if="base.debug_read_p" :vars="['base.continue_tap_counts', 'base.battle_count', 'base.battle.battle_pos', 'base.score_debug_info']")

</template>

<script>
import { support_child } from "../support_child.js"

export default {
  mixins: [
    support_child,
  ],

  created() {
    // this.$ga.event("open", {event_category: "対戦結果"})
  },
  computed: {
    // 参加者が全員いる？
    all_active_p() {
      return Object.values(this.base.member_infos_hash).every(e => e.member_active_p) // v.values.all?(&:member_active_p)
    },
    // 自分が押した？
    button_push_by_self_p() {
      return this.base.continue_tap_counts[this.base.current_membership.id] >= 1
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.ActbResultApp
  .vs_container
    justify-content: center
    align-items: center

  // 続ける
  .saisen_suru_container
    .buttons
      flex-direction: column
      .button
        // min-width: 12rem
        &:not(:first-child)
          margin-top: 0.75rem
</style>
