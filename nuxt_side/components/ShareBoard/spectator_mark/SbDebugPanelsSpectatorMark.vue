<template lang="pug">
.SbDebugPanelsSpectatorMark.column.is-3
  .panel
    .panel-heading
      | 千日手指摘
  //-   a.panel-block(@click="SB.spectator_mark_cop.increment('x')") 同局面カウント +1
  //-   a.panel-block(@click="SB.spectator_mark_cop.reset()") リセット
  //- .panel.assert_system_variable
  //-   .panel-heading
  //-     | [assert_system_variable]
  //-   .panel-block spectator_mark_cop.keys_count:{{SB.spectator_mark_cop.keys_count}}
  //-   .panel-block spectator_mark_cop.count:{{SB.spectator_mark_cop.count}}
  //-   .panel-block spectator_mark_cop.available_p:{{SB.spectator_mark_cop.available_p('x')}}
  //-   .panel-block spectator_mark_check_p:{{SB.illegal_behavior_info.spectator_mark_check_p}}
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
