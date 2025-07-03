<template lang="pug">
.columns.is-multiline.XyMasterLiteDebugPanels.is-centered
  .column.is-3
    .panel
      .panel-heading
        | デバッグ用
      //- a.panel-block(@click="TheApp.reset_all_handle") 全削除
      //- a.panel-block(@click="TheApp.rebuild_handle") リビルド
      //- a.panel-block(@click="TheApp.ls_reset") ブラウザに記憶した情報の削除
      //- a.panel-block(@click="TheApp.var_init") 保存可能な変数のリセット
      //- a.panel-block(@click="TheApp.sfen_set") sfen_set
      //- a.panel-block(@click="TheApp.sfen_clear") sfen_clear
  .column.is-6
    .panel
      .panel-heading
        | $data
      .panel-block
        DebugPre {{TheApp.$data}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XyMasterLiteDebugPanels",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "./support.sass"
.XyMasterLiteDebugPanels
  __css_keep__: 0
</style>
