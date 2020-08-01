<template lang="pug">
.the_lobby_message(v-if="permit_lobby_message_p")
  .messages_box(ref="messages_box")
    .message_line(v-for="message in app.lobby_messages")
      message_row(:message="message")
  .input_field.is-flex.mt-2(v-if="app.current_user")
    figure.media-left.is_clickable.ml-2.mr-0(@click="app.ov_user_info_set(app.current_user.id)")
      p.image.is-32x32.avatar_image
        img.is-rounded(:src="app.current_user.avatar_path")
    b-field.ml-2
      b-input(v-model="app.lobby_message_body" expanded @keypress.native.enter="app.lobby_speak_handle")
      p.control
        button.button.is-primary(@click="app.lobby_speak_handle")
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
    flex-direction: row
    justify-content: flex-start
    align-items: center

    .field
      flex-basis: 100%

    .play_icon
      min-width: 3rem
</style>
