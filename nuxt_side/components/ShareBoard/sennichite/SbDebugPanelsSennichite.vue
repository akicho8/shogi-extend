<template lang="pug">
.SbDebugPanelsSennichite.column.is-3
  .panel
    .panel-heading
      | 千日手指摘
    a.panel-block(@click="TheSb.sennichite_cop.increment('x')") 同局面カウント +1
    a.panel-block(@click="TheSb.sennichite_cop.reset()") リセット
    a.panel-block(@click="TheSb.sennichite_modal_handle()") 千日手指摘
  .panel.assert_system_variable
    .panel-heading
      | [assert_system_variable]
    .panel-block sennichite_cop.keys_count:{{TheSb.sennichite_cop.keys_count}}
    .panel-block sennichite_cop.count:{{TheSb.sennichite_cop.count}}
    .panel-block sennichite_cop.available_p:{{TheSb.sennichite_cop.available_p('x')}}
    .panel-block sennichite_check_p:{{TheSb.foul_behavior_info.sennichite_check_p}}
</template>

<script>
export default {
  name: "SbDebugPanelsSennichite",
  inject: ["TheSb"],
}
</script>

<style lang="sass">
@import "../support.sass"
.SbDebugPanelsSennichite
</style>
