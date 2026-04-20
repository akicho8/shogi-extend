<template lang="pug">
a.navbar_item.navbar_item_wide.SbChatOpenButton2.chat_modal_open_handle(
  @click="SB.chat_modal_open_handle"
  v-if="SB.play_mode_p && SB.chat_button_visibility_info.show_p"
  )
  .mdi.mdi-account
  .mdi.mdi-chat-processing
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbChatOpenButton2",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../scss/support"
.SbChatOpenButton2
  font-size: 1.5rem
  .mdi
    position: relative
  .mdi-account
    top: 5px
    left: 3px
  .mdi-chat-processing
    top: -7px
    left: -3px
</style>
