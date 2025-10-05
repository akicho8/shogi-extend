<template lang="pug">
.SbDebugSfenLoader.column.is-12
  .columns.is-multiline
    .column.is-6
      .panel
        .panel-heading
          | 盤面ロード
        a.panel-block(href="/share-board?sfen_loader_p=true") 確認用の環境に変更する
        a.panel-block(href="/share-board?sfen_loader_p=true&room_key=dev_room1&user_name=alice") 部屋のURLから入室する
        a.panel-block(@click="SB.sfen_loader_load") sfen_loader_load: 入室直前の盤面ロード
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbDebugSfenLoader",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbDebugSfenLoader
  __css_keep__: 0
</style>
