<template lang="pug">
.SwarsBattleIndexBoard.columns.is-multiline.mt-4
  template(v-for="e in base.config.records")
    // https://bulma.io/documentation/columns/responsiveness/
    // widescreen 1/5 (is-one-fifth-widescreen)
    // desktop    1/4 (is-one-quarter-desktop)
    // table      1/4 (is-one-quarter-tablet)
    .column.is-one-fifth-widescreen.is-one-quarter-desktop.is-one-third-tablet.is-clickable(@click.stop="base.show_handle(e)")
      //- SwarsBattleShowUserLink.is_line_break_on.is-size-7(:membership="e.memberships[1]")
      CustomShogiPlayer(
        :sp_player_info="e.player_info"
        sp_layout="is_vertical"
        sp_run_mode="view_mode"
        :sp_turn="base.sp_start_turn(e)"
        :sp_body="e.sfen_body"
        :sp_sound_enabled="false"
        sp_summary="is_summary_off"
        :sp_op_disabled="true"
        :sp_viewpoint="e.memberships[0].location.key"
      )
      // :sp_hidden_if_piece_stand_blank="scene_key === 'critical'"
      //- SwarsBattleShowUserLink.is_line_break_on.is-size-7(:membership="e.memberships[0]")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsBattleIndexBoard",
  mixins: [support_child],
}
</script>

<style lang="sass">
.SwarsBattleIndexBoard
</style>
