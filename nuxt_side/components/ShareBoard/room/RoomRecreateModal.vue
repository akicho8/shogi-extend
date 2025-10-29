<template lang="pug">
.modal-card
  .message.is-danger
    .message-header
      | 通信不調
    .message-body
      | インターネットに接続してください。
      | 接続したら自動的に部屋に復帰します。
      template(v-if="SB.debug_mode_p")
        a.mx-1.room_recreate_modal_close(@click="SB.room_recreate_modal_close") [CLOSE]
        a.mx-1.internet_on_trigger(@click="SB.internet_on_trigger") [接続]

  //- b-notification(type="is-danger is-light" has-icon)
  //-   | インターネットに接続してください。
  //-   | 接続したら自動的に部屋に復帰します。
  //-   template(v-if="SB.debug_mode_p")
  //-     a.mx-1.room_recreate_modal_close(@click="SB.room_recreate_modal_close") [CLOSE]
  //-     a.mx-1.internet_on_trigger(@click="SB.internet_on_trigger") [接続]

//- .modal-card
//-   .modal-card-head
//-     .modal-card-title
//-       | オフラインです
//-   .modal-card-body
//-     p 通信環境を見直してインターネットに接続してください
//-     p 接続したら自動的に部屋に復帰します
//-   .modal-card-foot.is-justify-content-end
//-     //- b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left")
//-     //- b-button.room_recreate_handle(@click="SB.room_recreate_handle" type="is-danger") 復帰する
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "RoomRecreateModal",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.RoomRecreateModal
  __css_keep__: 0
  //   +modal_width(26rem)
  //   .modal-card-body
  //     padding: 1.5rem
  //     p:not(:first-child)
  //       margin-top: 0.75rem
</style>
