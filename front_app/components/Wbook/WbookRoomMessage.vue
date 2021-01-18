<template lang="pug">
.WbookRoomMessage.mt-4(v-if="base.config.room_messages_display_p")
  .messages_box.has-background-light(ref="messages_box" :style="{height: `${base.config.room_messages_window_height}rem`}")
    template(v-for="message in base.droped_room_messages")
      WbookMessageRow(:base="base" :message="message")
  b-field.input_field
    b-input(v-model="base.room_message_body" expanded @keypress.native.enter="base.room_speak_handle")
    p.control
      button.button.is-primary(@click="base.room_speak_handle")
        b-icon.play_icon(icon="play")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WbookRoomMessage",
  mixins: [
    support_child,
  ],

  watch: {
    "base.room_messages": {
      handler() { this.scroll_to_bottom(this.$refs.messages_box) },
      immediate: true,
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.WbookRoomMessage
  margin-left: $lr_sukima
  margin-right: $lr_sukima
  .messages_box
    overflow-y: scroll
  .input_field
    margin-top: 0.5rem
    .play_icon
      min-width: 3rem
</style>
