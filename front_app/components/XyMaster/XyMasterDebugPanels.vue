<template lang="pug">
.columns.is-multiline.XyMasterDebugPanels
  .column.is-3
    .panel
      .panel-heading
        | デバッグ用
      a.panel-block(@click="base.reset_all_handle") リセット
      a.panel-block(@click="base.goal_handle") ゴール
      a.panel-block(@click="base.rebuild_handle") リビルド
      a.panel-block(@click="base.ls_reset") ブラウザに記憶した情報の削除
      a.panel-block(@click="base.var_init") 保存可能な変数のリセット
  .column.is-3
    .panel
      .panel-heading
        | その他
      a.panel-block(@click="base.name_input_dialog") 名前入力
  .column.is-3
    .panel
      .panel-heading
        | ランキングタブの各表示ページ
      .panel-block
        | {{base.current_pages}}
  .column.is-6
    .panel
      .panel-heading
        | $data
      .panel-block
        DebugPre {{base.$data}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XyMasterDebugPanels",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "./support.sass"
.XyMasterDebugPanels
</style>
