<template lang="pug">
.SbDebugPanelsSpectatorMark.column.is-3
  .panel
    .panel-heading
      | 印
    a.panel-block(@click="SB.spectator_mark_toggle_button_click_handle") 切り替え
    a.panel-block(@click="SB.spectator_mark_all_clear") 全消し
  .panel.assert_system_variable
    .panel-heading
      | [assert_system_variable]
    .panel-block mark_mode_p:{{SB.mark_mode_p}}
    .panel-block mark_mode_global_p:{{SB.mark_mode_global_p}}
    .panel-block mark_receive_scope_info.key:{{SB.mark_receive_scope_info.key}}
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbDebugPanelsSpectatorMark",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.SbDebugPanelsSpectatorMark
  __css_keep__: 0
</style>
