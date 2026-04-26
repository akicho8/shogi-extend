<template lang="pug">
.SbDebugDashboard3.column.is-3
  .panel
    .panel-heading
      | 対局履歴
    a.panel-block(@click="SB.general_dashboard3_modal_open_handle") モーダル版
    //- a.panel-block(:href="SB.dashboard3_url") LINK
  .panel.assert_var
    .panel-heading
      | [assert_var]
    .panel-block dashboard3_url:{{SB.dashboard3_url}}
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbDebugDashboard3",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../stylesheets/support"
.SbDebugDashboard3
  __css_keep__: 0
</style>
