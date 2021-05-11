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
          sp_run_mode="play_mode"
          :sp_body="base.vs_share_sfen"
          sp_summary="is_summary_off"
          :sp_human_side="sp_human_side"
          :sp_viewpoint="sp_viewpoint"
          @update:play_mode_advanced_full_moves_sfen="base.vs_func_play_mode_advanced_full_moves_sfen_set"
          :sp_player_info="sp_player_info"
        )

      //- EmoxBattleVersusMembership.mt-3(:base="base" :membership="base.current_membership")

      //- .buttons.is-centered.are-small.mt-3
      //-   b-button.has-text-weight-bold(@click="base.vs_func_toryo_handle(false)") 投了
      //-   b-button.has-text-weight-bold(@click="base.vs_func_toryo_handle(true)" v-if="development_p") 相手投了

  template(v-if="development_p && base.clock_box")
    .buttons.are-small.is-centered
      b-button(@click="base.clock_box.generation_next(-1)") -1
      b-button(@click="base.clock_box.generation_next(-60)") -60
      b-button(@click="base.clock_box.generation_next(1)") +1
      b-button(@click="base.clock_box.generation_next(60)") +60
      b-button(@click="base.clock_box.clock_switch()") 切り替え
      b-button(@click="base.clock_box.timer_start()") START
      b-button(@click="base.clock_box.timer_stop()") STOP
      b-button(@click="base.clock_box.params.every_plus = 5") フィッシャールール
      b-button(@click="base.clock_box.params.every_plus = 0") 通常ルール
      b-button(@click="base.clock_box.reset()") RESET
      b-button(@click="base.clock_box.main_sec_set(3)") 両方残り3秒
    b-message
      | 1手毎に{{base.clock_box.params.every_plus}}秒加算

</template>

<script>
import { support_child } from "../support_child.js"
import { Location } from "shogi-player/components/models/location.js"

export default {
  name: "EmoxBattleVersus",
  mixins: [support_child],
  computed: {
    sp_human_side() {
      return this.base.current_membership.location_key
    },
    sp_viewpoint() {
      return this.base.current_membership.location_key
    },
    sp_player_info() {
      if (this.base.clock_box) {
        return this.base.clock_box.single_clocks.reduce((a, e, i) => {
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
