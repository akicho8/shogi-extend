<template lang="pug">
.SbDebugPanelsSennichite.column.is-3
  .panel
    .panel-heading
      | 千日手指摘
    a.panel-block(@click="TheSb.sennichite_modal_handle_if(true)") 千日手指摘
  .panel.assert_system_variable
    .panel-heading
      | [assert_system_variable]
    .panel-block sennichite_obj.keys_count:{{TheSb.sennichite_obj.keys_count}}
    .panel-block sennichite_obj.count:{{TheSb.sennichite_obj.count}}
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
