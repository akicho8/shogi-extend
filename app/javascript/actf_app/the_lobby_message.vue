<template lang="pug">
.the_lobby_message.columns
  .column
    .messages_box.has-background-light(ref="messages_box")
      template(v-for="message in $parent.lobby_messages")
        div {{message.user.name}}: {{message.body}}
    b-field.input_field
      b-input(v-model="$parent.lobby_message" expanded @keypress.native.enter="$parent.lobby_speak_handle")
      p.control
        button.button.is-primary(@click="$parent.lobby_speak_handle")
          b-icon.play_icon(icon="play")
</template>

<script>
import the_support from "./the_support.js"

export default {
  name: "the_lobby",
  mixins: [
    the_support,
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
    "$parent.lobby_messages": {
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
@import "../stylesheets/bulma_init.scss"
.the_lobby_message
  .messages_box
    padding: 0.5rem
    height: 20em
    overflow-y: scroll
  .input_field
    margin-top: 0.5rem
    .play_icon
      min-width: 3rem
</style>

