<template lang="pug">
.SbDebugRoomLatestStateLoader.column.is-12
  .columns.is-multiline
    .column.is-6
      .panel
        .panel-heading
          | 盤面ロード
        a.panel-block(href="/share-board?room_restore_key=enable") リストアする環境に変更する
        a.panel-block(href="/share-board?room_restore_key=skip") リストアしない環境に変更する
        a.panel-block(href="/share-board?room_restore_key=enable&room_key=dev_room1&user_name=alice") 部屋のURLから入室する
        a.panel-block(@click="SB.room_latest_state_loader_load") room_latest_state_loader_load: 入室直前の盤面ロード
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbDebugRoomLatestStateLoader",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbDebugRoomLatestStateLoader
  __css_keep__: 0
</style>
