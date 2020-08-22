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
  .buttons.is-centered.are-small.mt-3
    b-button.has-text-weight-bold(@click="app.vs_func_toryo_handle(false)") 投了
    b-button.has-text-weight-bold(@click="app.vs_func_toryo_handle(true)" v-if="development_p") 相手投了
</template>

<script>
import { support } from "../support.js"

export default {
  name: "the_battle_question_sy_versus",
  mixins: [
    support,
  ],
  created() {
  },
  beforeDestroy() {
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
</style>
