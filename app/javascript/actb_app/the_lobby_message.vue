<template lang="pug">
.the_lobby_message
  .messages_box(ref="messages_box")
    .message_line(v-for="message in app.lobby_messages")
      message_row(:message="message")
  b-field.input_field
    b-input(v-model="app.lobby_message_body" expanded @keypress.native.enter="app.lobby_speak_handle" :disabled="!app.current_user")
    p.control
      button.button.is-primary(@click="app.lobby_speak_handle" :disabled="!app.current_user")
        b-icon.play_icon(icon="play")
</template>

<script>
import { support } from "./support.js"
import message_row from "./components/message_row.vue"

export default {
  name: "the_lobby",
  components: {
    message_row,
  },
  mixins: [
    support,
  ],
  watch: {
    "app.lobby_messages": {
      handler() {
        this.scroll_to_bottom(this.$refs.messages_box)
      },
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_lobby_message
  margin-top: 1rem
  padding: 0 0.5rem
  .messages_box
    height: 42.5vh
    +desktop
      height: 62vh
    padding: 0.5rem
    overflow-y: scroll
  .input_field
    margin-top: 0.5rem
    .play_icon
      min-width: 3rem
</style>
