<template lang="pug">
b-navbar-item.SbChatOpenButton.px_5_if_tablet.is-unselectable.chat_modal_open_handle(
  tag="a"
  @click="SB.chat_modal_open_handle"
  v-if="SB.ac_room || true"
  )
  b-icon.account_icon(icon="account")
  b-icon.message_icon(icon="chat-processing")
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbChatOpenButton",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbChatOpenButton
  // チャットアイコンは2つをずらして組み合わせる
  .icon
    position: relative
    &.account_icon
      top: 5px
      left: 3px
    &.message_icon
      top: -7px
      left: -3px
</style>
