<template lang="pug">
.SwarsBattleIndexBoard.columns.is-multiline.mt-4
  template(v-for="e in base.xi.records")
    .column.is-one-fifth-widescreen.is-one-quarter-desktop.is-one-third-tablet.is-clickable(@click.stop="base.show_handle(e)")
      CustomShogiPlayer(
        :sp_player_info="e.player_info"
        :sp_layout="'is_vertical'"
        :sp_run_mode="'view_mode'"
        :sp_turn="base.scene_info.sp_turn_of(e)"
        :sp_body="e.sfen_body"
        :sp_sound_enabled="false"
        :sp_summary="'is_summary_off'"
        :sp_op_disabled="true"
        :sp_viewpoint="e.memberships[0].location_key"
      )
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
