<template lang="pug">
.SbDebugPanelsPerpetual.column.is-3
  .panel
    .panel-heading
      | 千日手指摘
    a.panel-block(@click="TheSb.perpetual_cop.increment('x')") 同局面カウント +1
    a.panel-block(@click="TheSb.perpetual_cop.reset()") リセット
    a.panel-block(@click="TheSb.perpetual_modal_handle()") 千日手指摘
  .panel.assert_system_variable
    .panel-heading
      | [assert_system_variable]
    .panel-block perpetual_cop.keys_count:{{TheSb.perpetual_cop.keys_count}}
    .panel-block perpetual_cop.count:{{TheSb.perpetual_cop.count}}
    .panel-block perpetual_cop.available_p:{{TheSb.perpetual_cop.available_p('x')}}
    .panel-block perpetual_check_p:{{TheSb.illegal_behavior_info.perpetual_check_p}}
</template>

<script>
export default {
  name: "SbDebugPanelsPerpetual",
  inject: ["TheSb"],
}
</script>

<style lang="sass">
@import "../support.sass"
.SbDebugPanelsPerpetual
</style>
