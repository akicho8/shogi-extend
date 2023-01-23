<template lang="pug">
.SbDebugPanelsSennichite.column.is-3
  .panel
    .panel-heading
      | 千日手指摘
    a.panel-block(@click="TheSb.sennichite_modal_handle_if(true)") 千日手指摘
  .panel.assert_system_variable
    .panel-heading
      | [assert_system_variable]
    .panel-block sennichite_cop.keys_count:{{TheSb.sennichite_cop.keys_count}}
    .panel-block sennichite_cop.count:{{TheSb.sennichite_cop.count}}
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
