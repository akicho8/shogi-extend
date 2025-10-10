<template lang="pug">
.SbDebugRoomUrlCopyModal.column.is-2
  .panel
    .panel-heading
      | 部屋のリンクをコピーする
    a.panel-block(@click="SB.room_url_copy_modal_handle") 「部屋のリンクをコピーする」モーダル発動
    a.panel-block(href="/share-board?auto_room_url_copy_modal_p=true") 「部屋のリンクをコピーする」自動発動有効化
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbDebugRoomUrlCopyModal",
  mixins: [support_child],
}
</script>
