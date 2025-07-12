<template lang="pug">
.SbDebugPanelsHonpu.column.is-12
  .panel
    .panel-heading
      | 本譜
    .panel-block(v-if="SB.current_sfen") 現在 \#{{SB.current_turn}} {{SB.current_sfen}}
    .panel-block(v-if="SB.honpu_main") 本譜 \#{{SB.honpu_main.turn}} {{SB.honpu_main.sfen}}
    .panel-block(v-if="SB.honpu_branch") ブランチ \#{{SB.honpu_branch.turn}} {{SB.honpu_branch.sfen}}
    .panel-block 直近の指し手は本譜をなぞっている？ {{SB.honpu_branch_is_same_route_p}}
    .panel-block 直近の指し手は本譜から外れた？ {{SB.honpu_branch_exist_p}}
    a.panel-block.honpu_main_setup(@click="SB.honpu_main_setup") 作成
    a.panel-block.honpu_open_click_handle(@click="SB.honpu_open_click_handle") 開く
    a.panel-block.honpu_all_clear(@click="SB.honpu_all_clear") 削除
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbDebugPanelsHonpu",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbDebugPanelsHonpu
  __css_keep__: 0
</style>
