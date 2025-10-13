<template lang="pug">
.SbDebugRoom.column.is-12
  .columns.is-multiline
    .column.is-4
      .panel
        .panel-heading
          | 盤面ロード
        a.panel-block(href="?room_restore_feature_p=true") [環境] リストアする(初期値)
        a.panel-block(href="?room_restore_feature_p=false") [環境] リストアしない
        a.panel-block(href="?room_restore_feature_p=true&room_key=dev_room1&user_name=alice") 部屋のURLから入室する
        a.panel-block(@click="SB.room_restore_call") room_restore_call: 入室直前の盤面ロード
    .column.is-4
      .panel
        .panel-heading
          | 環境切り替え
        a.panel-block(href="?auto_room_url_copy_modal_p=true") 「部屋のリンクをコピーする」自動発動有効化
        a.panel-block(href="?handle_name_ng_word_check_p=true") 「NGワードチェック」有効化
    .column.is-4
      .panel
        .panel-heading
          | 起動
        a.panel-block(@click="SB.room_url_copy_modal_handle") 「部屋のリンクをコピーする」モーダル発動
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbDebugRoom",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbDebugRoom
  __css_keep__: 0
</style>
