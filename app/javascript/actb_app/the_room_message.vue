<template lang="pug">
.the_room_message.columns
  .column
    .messages_box.has-background-light(ref="messages_box" :style="{height: `${app.config.room_messages_display_lines}rem`}")
      template(v-for="message in app.room_messages")
        div {{message.user.name}}: {{message.body}}
    b-field.input_field
      b-input(v-model="app.room_message" expanded @keypress.native.enter="app.room_speak_handle")
      p.control
        button.button.is-primary(@click="app.room_speak_handle")
          b-icon.play_icon(icon="play")
</template>

<script>
import support from "./support.js"

export default {
  name: "the_room_message",
  mixins: [
    support,
  ],
  props: {
  },
  data() {
    return {
    }
  },

  created() {
  },

  watch: {
    "app.room_messages": {
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
.the_room_message
  .messages_box
    padding: 0.5rem
    overflow-y: scroll
  .input_field
    margin-top: 0.5rem
    .play_icon
      min-width: 3rem
</style>
