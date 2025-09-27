<template lang="pug">
.SwarsBattleIndexBoard.columns.is-multiline.mt-4
  template(v-for="e in APP.xi.records")
    nuxt-link.column.is-one-fifth-widescreen.is-one-quarter-desktop.is-one-third-tablet(:to="APP.show_route_params(e)" @click.native="sfx_click()")
      CustomShogiPlayer(
        sp_mode="view"
        sp_layout="vertical"
        :sp_player_info="e.player_info"
        :sp_turn="APP.scene_info.sp_turn_of(e)"
        :sp_body="e.sfen_body"
        sp_operation_disabled
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
  __css_keep__: 0
</style>
