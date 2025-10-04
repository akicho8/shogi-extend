<template lang="pug">
.SbDebugChat.column.is-3
  .panel
    .panel-heading
      | チャット履歴
    a.panel-block(@click="SB.mh_reset_all") 初期化
  .panel.assert_var
    .panel-heading
      | [assert_var]
    .panel-block ml_count:{{SB.ml_count}}
    .panel-block mh_page_index:{{SB.mh_page_index}}
</template>

<script>
import { support_child } from "../support_child.js"
import _ from "lodash"

export default {
  name: "SbDebugChat",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbDebugChat
  __css_keep__: 0
</style>
