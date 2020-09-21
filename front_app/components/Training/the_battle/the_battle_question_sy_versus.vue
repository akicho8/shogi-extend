<template lang="pug">
.the_battle_question_sy_versus
  the_battle_question_sy_versus_membership.mt-3(:membership="app.opponent_membership")

  MyShogiPlayer.mt-3(
    :run_mode="'play_mode'"
    :kifu_body="app.vs_share_sfen"
    :summary_show="false"
    :setting_button_show="false"
    :theme="app.config.sp_theme"
    :size="app.config.sp_size"
    :human_side_key="current_human_side_key"
    :flip="current_flip"
    @update:play_mode_advanced_full_moves_sfen="app.vs_func_play_mode_advanced_full_moves_sfen_set"
  )

  the_battle_question_sy_versus_membership.mt-3(:membership="app.current_membership")

  .buttons.is-centered.are-small.mt-3
    b-button.has-text-weight-bold(@click="app.vs_func_toryo_handle(false)") 投了
    b-button.has-text-weight-bold(@click="app.vs_func_toryo_handle(true)" v-if="development_p") 相手投了

  template(v-if="development_p")
    .buttons.are-small.is-centered
      b-button(@click="app.chess_clock.generation_next(-1)") -1
      b-button(@click="app.chess_clock.generation_next(-60)") -60
      b-button(@click="app.chess_clock.generation_next(1)") +1
      b-button(@click="app.chess_clock.generation_next(60)") +60
      b-button(@click="app.chess_clock.clock_switch()") 切り替え
      b-button(@click="app.chess_clock.timer_start()") START
      b-button(@click="app.chess_clock.timer_stop()") STOP
      b-button(@click="app.chess_clock.params.every_plus = 5") フィッシャールール
      b-button(@click="app.chess_clock.params.every_plus = 0") 通常ルール
      b-button(@click="app.chess_clock.reset()") RESET
      b-button(@click="app.chess_clock.value_set(3)") 両方残り3秒
    b-message
      | 1手毎に{{app.chess_clock.params.every_plus}}秒加算

</template>

<script>
import { support } from "../support.js"
import the_battle_question_sy_versus_membership from "./the_battle_question_sy_versus_membership.vue"

export default {
  name: "the_battle_question_sy_versus",
  mixins: [
    support,
  ],
  components: {
    the_battle_question_sy_versus_membership,
  },
  computed: {
    current_human_side_key() {
      if (this.app.room.bot_user_id) {
        return "both"
      } else {
        return this.app.current_membership.location_key
      }
    },
    current_flip() {
      return this.app.current_membership.location_key === "white"
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_battle_question_sy_versus
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
