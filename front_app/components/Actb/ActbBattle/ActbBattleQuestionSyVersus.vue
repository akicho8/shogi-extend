<template lang="pug">
.ActbBattleQuestionSyVersus
  ActbBattleQuestionSyVersusMembership.mt-3(:membership="base.opponent_membership")

  CustomShogiPlayer.mt-3(
    sp_mobile_vertical="is_mobile_vertical_off"
    sp_run_mode="play_mode"
    sp_summary="is_summary_off"
    :sp_body="base.vs_share_sfen"
    :sp_human_side="sp_human_side"
    :sp_vpoint="sp_vpoint"
    @update:play_mode_advanced_full_moves_sfen="base.vs_func_play_mode_advanced_full_moves_sfen_set"
  )

  ActbBattleQuestionSyVersusMembership.mt-3(:membership="base.current_membership")

  .buttons.is-centered.are-small.mt-3
    b-button.has-text-weight-bold(@click="base.vs_func_toryo_handle(false)") 投了
    b-button.has-text-weight-bold(@click="base.vs_func_toryo_handle(true)" v-if="development_p") 相手投了

  template(v-if="development_p")
    .buttons.are-small.is-centered
      b-button(@click="base.chess_clock.generation_next(-1)") -1
      b-button(@click="base.chess_clock.generation_next(-60)") -60
      b-button(@click="base.chess_clock.generation_next(1)") +1
      b-button(@click="base.chess_clock.generation_next(60)") +60
      b-button(@click="base.chess_clock.clock_switch()") 切り替え
      b-button(@click="base.chess_clock.timer_start()") START
      b-button(@click="base.chess_clock.timer_stop()") STOP
      b-button(@click="base.chess_clock.params.every_plus = 5") フィッシャールール
      b-button(@click="base.chess_clock.params.every_plus = 0") 通常ルール
      b-button(@click="base.chess_clock.reset()") RESET
      b-button(@click="base.chess_clock.value_set(3)") 両方残り3秒
    b-message
      | 1手毎に{{base.chess_clock.params.every_plus}}秒加算

</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "ActbBattleQuestionSyVersus",
  mixins: [
    support_child,
  ],

  computed: {
    sp_human_side() {
      if (this.base.room.bot_user_id) {
        return "both"
      } else {
        return this.base.current_membership.location_key
      }
    },
    sp_vpoint() {
      return this.base.current_membership.location_key
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.ActbBattleQuestionSyVersus
  .membership_container
    justify-content: center
    align-items: center
    .user_name
      max-width: 7rem
    .time_format
      font-size: $size-3
      padding: 0.25rem 1rem
      border-radius: 0.5rem
</style>
