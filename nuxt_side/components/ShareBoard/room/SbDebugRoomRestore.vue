<template lang="pug">
.SbDebugRoomRestore.column.is-12
  .columns.is-multiline
    .column.is-6
      .panel
        .panel-heading
          | 盤面ロード
        a.panel-block(href="/share-board?room_restore_feature_p=true") リストアする環境に変更する
        a.panel-block(href="/share-board?room_restore_feature_p=false") リストアしない環境に変更する
        a.panel-block(href="/share-board?room_restore_feature_p=true&room_key=dev_room1&user_name=alice") 部屋のURLから入室する
        a.panel-block(@click="SB.room_restore_call") room_restore_call: 入室直前の盤面ロード
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbDebugRoomRestore",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbDebugRoomRestore
  __css_keep__: 0
</style>
