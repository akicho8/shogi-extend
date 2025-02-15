<template lang="pug">
.SbDebugPanelsThinkMark.column.is-3
  .panel
    .panel-heading
      | 印
    a.panel-block(@click="SB.think_mark_toggle_button_click_handle") 切り替え
    a.panel-block(@click="SB.think_mark_all_clear") 全消し
  .panel.assert_system_variable
    .panel-heading
      | [assert_system_variable]
    .panel-block think_mark_mode_p:{{SB.think_mark_mode_p}}
    .panel-block think_mark_mode_global_p:{{SB.think_mark_mode_global_p}}
    .panel-block think_mark_receive_scope_key:{{SB.think_mark_receive_scope_key}}
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbDebugPanelsThinkMark",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.SbDebugPanelsThinkMark
  __css_keep__: 0
</style>
