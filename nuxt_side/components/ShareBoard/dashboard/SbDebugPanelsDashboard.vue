<template lang="pug">
.SbDebugPanelsDashboard.column.is-3
  .panel
    .panel-heading
      | 対局履歴
    a.panel-block(@click="SB.general_dashboard_modal_handle") モーダル版
    a.panel-block(:href="SB.dashboard_url") LINK
  .panel.assert_system_variable
    .panel-heading
      | [assert_system_variable]
    .panel-block dashboard_url:{{SB.dashboard_url}}
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbDebugPanelsDashboard",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbDebugPanelsDashboard
  __css_keep__: 0
</style>
