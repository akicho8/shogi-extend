<template lang="pug">
.SbDebugBattleRanking.column.is-3
  .panel
    .panel-heading
      | ランキング
    a.panel-block(@click="SB.battle_ranking_modal_open_handle") 起動
    a.panel-block(href="?self_vs_self_enable_p=false&room_restore_feature_p=false&room_key=dev_room&user_name=alice&FIXED_MEMBER=alice,b&FIXED_ORDER=alice,b&room_after_create=battle_ranking_modal_open_handle") テスト用固定URL
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbDebugBattleRanking",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../stylesheets/support"
.SbDebugBattleRanking
  __css_keep__: 0
</style>
