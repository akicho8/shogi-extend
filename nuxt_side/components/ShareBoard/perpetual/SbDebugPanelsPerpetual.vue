<template lang="pug">
.SbDebugPanelsPerpetual.column.is-3
  .panel
    .panel-heading
      | 千日手指摘
    a.panel-block(@click="SB.perpetual_cop.increment('x')") 同局面カウント +1
    a.panel-block(@click="SB.perpetual_cop.reset()") リセット
  .panel.assert_system_variable
    .panel-heading
      | [assert_system_variable]
    .panel-block perpetual_cop.keys_count:{{SB.perpetual_cop.keys_count}}
    .panel-block perpetual_cop.count:{{SB.perpetual_cop.count}}
    .panel-block perpetual_cop.available_p:{{SB.perpetual_cop.available_p('x')}}
    .panel-block perpetual_check_p:{{SB.foul_mode_info.perpetual_check_p}}
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbDebugPanelsPerpetual",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbDebugPanelsPerpetual
  __css_keep__: 0
</style>
