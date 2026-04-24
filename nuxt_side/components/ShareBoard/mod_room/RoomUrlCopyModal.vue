<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 部屋のリンクをコピーしますか？
  .modal-card-body
    p フレンドに伝えるとこの部屋に誘導できます
  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="SB.room_url_copy_modal_close_handle" icon-left="chevron-left")
    b-button.apply_button(@click="SB.room_url_copy_handle" type="is-primary") コピーする
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "RoomUrlCopyModal",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../stylesheets/support"
.RoomUrlCopyModal
  .modal-card-body
    display: flex
    flex-direction: column
    gap: 0.5rem
</style>
