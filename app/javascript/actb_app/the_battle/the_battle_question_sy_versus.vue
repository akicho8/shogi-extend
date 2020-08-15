<template lang="pug">
.the_battle_question_sy_versus
  shogi_player(
    :run_mode="'play_mode'"
    :kifu_body="app.vs_share_sfen"
    :summary_show="false"
    :setting_button_show="false"
    :theme="app.config.sp_theme"
    :size="app.config.sp_size"
    :human_side_key="current_human_side_key"
    :flip="current_flip"
    :sound_effect="true"
    :volume="0.5"
    @update:play_mode_advanced_full_moves_sfen="app.vs_func_play_mode_advanced_full_moves_sfen_set"
  )
</template>

<script>
import { support } from "../support.js"

export default {
  name: "the_battle_question_sy_versus",
  mixins: [
    support,
  ],
  created() {
    // this.app.main_interval_start()
  },
  beforeDestroy() {
    // this.app.main_interval_clear()
    // this.app.ops_interval_stop()
  },
  computed: {
    current_human_side_key() {
      if (this.app.room.bot_user_id) {
        return "both"
      } else {
        return this.app.current_membership.location_key
      }
      // this.current_sfen = this.preset_info.sfen                     // 手合割に対応する盤面設定
      // this.flip = (this.preset_info.first_location_key === "white") // 駒落ちなら反転して上手を持つ
      // this.human_side_key = this.preset_info.first_location_key     // 人間側だけの操作にする
    },
    current_flip() {
      return this.app.current_membership.location_key === "white"
      // this.current_sfen = this.preset_info.sfen                     // 手合割に対応する盤面設定
      // this.flip = (this.preset_info.first_location_key === "white") // 駒落ちなら反転して上手を持つ
      // this.human_side_key = this.preset_info.first_location_key     // 人間側だけの操作にする
    },
  },

}
</script>

<style lang="sass">
@import "../support.sass"
.the_battle_question_sy_versus
</style>
