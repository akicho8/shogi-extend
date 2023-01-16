<template lang="pug">
.SbDebugPanelsSnt.column.is-3
  .panel
    .panel-heading
      | 千日手指摘
    a.panel-block(@click="TheSb.snt_modal_handle_if(true)") 千日手指摘
  .panel.assert_system_variable
    .panel-heading
      | [assert_system_variable]
    .panel-block snt_obj.keys_count:{{TheSb.snt_obj.keys_count}}
    .panel-block snt_obj.count:{{TheSb.snt_obj.count}}
</template>

<script>
export default {
  name: "SbDebugPanelsSnt",
  inject: ["TheSb"],
}
</script>

<style lang="sass">
@import "../support.sass"
.SbDebugPanelsSnt
</style>
