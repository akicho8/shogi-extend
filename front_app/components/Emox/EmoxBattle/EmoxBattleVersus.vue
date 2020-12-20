<template lang="pug">
.EmoxBattleVersus
  //- EmoxBattleVersusMembership.mt-3(:base="base" :membership="base.opponent_membership")

  b-navbar(type="is-primary" wrapper-class="container")
    template(slot="end")
      b-navbar-item.has-text-weight-bold(@click="base.vs_func_toryo_handle(false)") 投了
      b-navbar-item.has-text-weight-bold(@click="base.vs_func_toryo_handle(true)" v-if="development_p") 相手投了

  MainSection.is_mobile_padding_zero
    .container
      .CustomShogiPlayerWrap
        CustomShogiPlayer(
          :run_mode="'play_mode'"
          :kifu_body="base.vs_share_sfen"
          :summary_show="false"
          :setting_button_show="false"
          :human_side_key="current_human_side_key"
          :flip="current_flip"
          @update:play_mode_advanced_full_moves_sfen="base.vs_func_play_mode_advanced_full_moves_sfen_set"
          :player_info="player_info"
        )

      //- EmoxBattleVersusMembership.mt-3(:base="base" :membership="base.current_membership")

      //- .buttons.is-centered.are-small.mt-3
      //-   b-button.has-text-weight-bold(@click="base.vs_func_toryo_handle(false)") 投了
      //-   b-button.has-text-weight-bold(@click="base.vs_func_toryo_handle(true)" v-if="development_p") 相手投了

  template(v-if="development_p && base.chess_clock")
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
      b-button(@click="base.chess_clock.main_sec_set(3)") 両方残り3秒
    b-message
      | 1手毎に{{base.chess_clock.params.every_plus}}秒加算

</template>

<script>
import { support_child } from "../support_child.js"
import Location from "shogi-player/components/models/location.js"

export default {
  name: "EmoxBattleVersus",
  mixins: [support_child],
  computed: {
    current_human_side_key() {
      return this.base.current_membership.location_key
    },
    current_flip() {
      return this.base.current_membership.location_key === "white"
    },
    player_info() {
      if (this.base.chess_clock) {
        return this.base.chess_clock.single_clocks.reduce((a, e, i) => {
          return {
            ...a,
            [Location.fetch(i).key]: {time: e.to_time_format},
          }
        }, {})
      }
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.EmoxBattleVersus
  +mobile
    .navbar > .container .navbar-menu, .container > .navbar .navbar-menu
      margin-right: 0

  .CustomShogiPlayerWrap
    display: flex
    align-items: center
    justify-content: center
    flex-direction: column
    width: 100%

    .CustomShogiPlayer
      max-width: 640px

.STAGE-development
  .CustomShogiPlayerWrap, .CustomShogiPlayer
    border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
