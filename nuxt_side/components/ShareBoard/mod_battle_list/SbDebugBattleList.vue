<template lang="pug">
.SbDebugBattleList.column.is-3
  .panel
    .panel-heading
      | 対局履歴
    a.panel-block(@click="SB.battle_list_modal_open_handle") 起動
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbDebugBattleList",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../stylesheets/support"
.SbDebugBattleList
  __css_keep__: 0
</style>
