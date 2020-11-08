<template lang="pug">
.ActbLobbyMessage(:base="base" v-if="base.current_user && permit_lobby_message_p")
  .messages_box(ref="messages_box")
    .message_line(v-for="message in base.lobby_messages")
      ActbMessageRow(:base="base" :message="message")
  .input_field.is-flex.mt-2(v-if="base.current_user && permit_lobby_message_input_p")
    figure.media-left.is-clickable.ml-2.mr-0(@click="base.ov_user_info_set(base.current_user.id)")
      p.image.is-32x32.avatar_image
        img.is-rounded(:src="base.current_user.avatar_path")
    b-field.ml-2
      b-input(v-model="base.lobby_message_body" expanded @keypress.native.enter="base.lobby_speak_handle")
      p.control
        button.button.is-primary(@click="base.lobby_speak_handle")
          b-icon.play_icon(icon="play")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "ActbLobby",

  mixins: [
    support_child,
  ],
  watch: {
    "base.lobby_messages": {
      handler() {
        this.scroll_to_bottom(this.$refs.messages_box)
      },
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.ActbLobbyMessage
  margin-top: 1rem
  padding: 0 0.5rem
  .messages_box
    height: 32.5vh
    +desktop
      height: 52vh
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
