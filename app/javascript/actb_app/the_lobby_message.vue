<template lang="pug">
.the_lobby_message
  | {{height}}
  .messages_box(ref="messages_box" :style="{height: height ? `${height * 0.5}px` : 'auto'}")
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

const innerHeight = require('ios-inner-height')

export default {
  name: "the_lobby",
  components: {
    message_row,
  },
  mixins: [
    support,
  ],
  data() {
    return {
      height: null
    };
  },
  watch: {
    "app.lobby_messages": {
      handler() {
        this.scroll_to_bottom(this.$refs.messages_box)
      },
    },
  },
  methods: {
    adjustHeight() {
      this.height = innerHeight()
    }
  },
  mounted() {
    this.adjustHeight()
    window.addEventListener("resize", this.adjustHeight)
  },
  destroyed() {
    window.removeEventListener("resize", this.adjustHeight)
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_lobby_message
  margin-top: 1rem
  padding: 0 0.5rem
  .messages_box
    padding: 0.5rem
    overflow-y: scroll
  .input_field
    margin-top: 0.5rem
    .play_icon
      min-width: 3rem
</style>
