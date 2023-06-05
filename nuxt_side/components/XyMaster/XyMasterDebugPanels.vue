<template lang="pug">
.columns.is-multiline.XyMasterDebugPanels.is-centered
  .column.is-3
    .panel
      .panel-heading
        | デバッグ用
      a.panel-block(@click="TheApp.reset_all_handle") 全削除
      a.panel-block(@click="TheApp.goal_handle") ゴール
      a.panel-block(@click="TheApp.rebuild_handle") リビルド
      a.panel-block(@click="TheApp.ls_reset") ブラウザに記憶した情報の削除
      a.panel-block(@click="TheApp.var_init") 保存可能な変数のリセット
      a.panel-block(@click="TheApp.sfen_set") sfen_set
      a.panel-block(@click="TheApp.sfen_clear") sfen_clear
      a.panel-block(@click="TheApp.time_over_alert") 時間切れ
      a.panel-block(@click="TheApp.too_many_miss_alert") ミスが多すぎるので終了
  .column.is-3
    .panel
      .panel-heading
        | その他
      a.panel-block(@click="TheApp.name_input_dialog") 名前入力
      a.panel-block(@click="TheApp.ios15_dialog_alert") iOS15の警告
    .panel
      .panel-heading
        | ランキングタブの各表示ページ
      .panel-block
        | {{TheApp.current_pages}}
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
  name: "XyMasterDebugPanels",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "./support.sass"
.XyMasterDebugPanels
  __css_keep__: 0
</style>
