<template lang="pug">
.SbDebugPanelsRoomCodeCopyModal.column.is-2
  .panel
    .panel-heading
      | 部屋のリンクをコピーする
    a.panel-block(@click="TheSb.room_code_copy_modal_handle") モーダル発動
    a.panel-block(href="/share-board?auto_room_code_copy_modal_p=true") 自動発動有効化
</template>

<script>
export default {
  name: "SbDebugPanelsRoomCodeCopyModal",
  inject: ["TheSb"],
}
</script>
