<template lang="pug">
.the_room_message.mt-4
  .messages_box.has-background-light(ref="messages_box" :style="{height: `${app.config.room_messages_window_height}rem`}")
    template(v-for="message in app.droped_room_messages")
      message_row(:message="message")
  b-field.input_field
    b-input(v-model="app.room_message_body" expanded @keypress.native.enter="app.room_speak_handle")
    p.control
      button.button.is-primary(@click="app.room_speak_handle")
        b-icon.play_icon(icon="play")
</template>

<script>
import { support } from "./support.js"
import message_row from "./components/message_row.vue"

export default {
  name: "the_room_message",
  mixins: [
    support,
  ],
  components: {
    message_row,
  },
  watch: {
    "app.room_messages": {
      handler() { this.scroll_to_bottom(this.$refs.messages_box) },
      immediate: true,
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_room_message
  margin-left: $lr_sukima
  margin-right: $lr_sukima
  .messages_box
    overflow-y: scroll
  .input_field
    margin-top: 0.5rem
    .play_icon
      min-width: 3rem
</style>
