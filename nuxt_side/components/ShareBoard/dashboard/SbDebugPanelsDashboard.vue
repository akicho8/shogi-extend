<template lang="pug">
.SbDebugPanelsDashboard.column.is-3
  .panel
    .panel-heading
      | 部屋の情報
    a.panel-block(@click="TheSb.general_dashboard_modal_handle") モーダル版
    a.panel-block(:href="TheSb.dashboard_url") LINK
  .panel.assert_system_variable
    .panel-heading
      | [assert_system_variable]
    .panel-block dashboard_url:{{TheSb.dashboard_url}}
</template>

<script>
export default {
  name: "SbDebugPanelsDashboard",
  inject: ["TheSb"],
}
</script>

<style lang="sass">
@import "../support.sass"
.SbDebugPanelsDashboard
  __css_keep__: 0
</style>
