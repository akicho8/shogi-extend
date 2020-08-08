<template lang="pug">
.the_result
  a.delete.page_delete.is-large.is_top_left_fixed(@click="app.yameru_handle")
  the_room_emotion

  template(v-if="app.room.bot_user_id")
    .has-text-centered.is-size-4.has-text-weight-bold.mt-5
      | おしまい

  template(v-if="!app.room.bot_user_id")
    .win_lose_container.has-text-centered.is-size-3.has-text-weight-bold.mt-5
      template(v-if="app.room.bot_user_id")
        .has-text-primary
          | 練習おわり
      template(v-else)
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

  .vs_container.mt-2.is-flex
    template(v-for="(membership, i) in app.ordered_memberships")
      the_result_membership(:membership="membership")
      .is-1.has-text-weight-bold.is-size-4.has-text-grey-light(v-if="i === 0") vs

  .saisen_suru_container
    .buttons.is-centered
      b-button.has-text-weight-bold(:disabled="!all_active_p" @click="app.battle_continue_handle(false)" :type="button_push_by_self_p ? 'is-primary' : ''") 同じ相手と再戦する

  the_room_message.mt-5

  .box.is-shadowless(v-if="app.debug_read_p")
    .buttons.is-centered.are-small
      b-button(@click="app.battle_continue_handle(true)") 同じ相手と再戦する(相手)
      b-button(@click="app.battle_continue_force_handle") 強制的に続行
      b-button(@click="app.battle_leave_handle(false)") 退出通知(自分)
      b-button(@click="app.battle_leave_handle(true)") 退出通知(相手)
      b-button(@click="app.battle_unsubscribe") バトル切断(自分)
      b-button(@click="app.member_disconnect_handle(true)") バトル切断風にする(相手)

  debug_print(v-if="app.debug_read_p" :vars="['app.member_infos_hash']")
  debug_print(v-if="app.debug_read_p" :vars="['app.continue_tap_counts', 'app.battle_count', 'app.battle.battle_pos', 'app.score_debug_info']")

</template>

<script>
import { support } from "./support.js"

import the_result_membership from "./the_result_membership.vue"
import the_room_message      from "./the_room_message.vue"
import the_room_emotion      from "./the_room_emotion.vue"

export default {
  mixins: [
    support,
  ],
  components: {
    the_room_emotion,
    the_room_message,
    the_result_membership,
  },
  created() {
    this.$gtag.event("open", {event_category: "対戦結果"})
  },
  computed: {
    // 参加者が全員いる？
    all_active_p() {
      return Object.values(this.app.member_infos_hash).every(e => e.member_active_p) // v.values.all?(&:member_active_p)
    },
    // 自分が押した？
    button_push_by_self_p() {
      return this.app.continue_tap_counts[this.app.current_membership.id] >= 1
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_result
  .vs_container
    justify-content: center
    align-items: center

  // 続ける
  .saisen_suru_container
    margin-top: 1rem
    .buttons
      flex-direction: column
      .button
        min-width: 12rem
        &:not(:first-child)
          margin-top: 0.75rem
</style>
