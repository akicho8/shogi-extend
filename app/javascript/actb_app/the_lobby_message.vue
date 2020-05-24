<template lang="pug">
.the_lobby_message
  .messages_box.has-background-light(ref="messages_box")
    template(v-for="message in app.lobby_messages")
      div {{message.user.name}}: {{message.body}}
  b-field.input_field
    b-input(v-model="app.lobby_message" expanded @keypress.native.enter="app.lobby_speak_handle")
    p.control
      button.button.is-primary(@click="app.lobby_speak_handle")
        b-icon.play_icon(icon="play")
</template>

<script>
import { support } from "./support.js"

export default {
  name: "the_lobby",
  mixins: [
    support,
  ],
  watch: {
    "app.lobby_messages": {
      handler() {
        this.scroll_to_bottom()
      },
    },
  },
  methods: {
    scroll_to_bottom() {
      if (this.$refs.messages_box) {
        this.$nextTick(() => {
          this.$refs.messages_box.scrollTop = this.$refs.messages_box.scrollHeight
        })
      }
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_lobby_message
  margin-top: 2rem
  padding: 0 0.5rem
  .messages_box
    padding: 0.5rem
    height: 20em
    overflow-y: scroll
  .input_field
    margin-top: 0.5rem
    .play_icon
      min-width: 3rem
</style>

