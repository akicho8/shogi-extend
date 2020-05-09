<template lang="pug">
.the_chat.columns
  .column
    .messages_box.has-background-light(ref="messages_box")
      template(v-for="message in $parent.messages")
        div {{message.user.name}}: {{message.body}}
    b-field.input_field
      b-input(v-model="$parent.message" expanded @keypress.native.enter="$parent.speak_handle")
      p.control
        button.button.is-primary(@click="$parent.speak_handle")
          b-icon.play_icon(icon="play")
</template>

<script>
import the_support from './the_support'

export default {
  name: "the_ready_go",
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
    "$parent.messages": {
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
.the_chat
  .messages_box
    padding: 0.5rem
    height: 5em
    overflow-y: scroll
  .input_field
    margin-top: 0.5rem
    .play_icon
      min-width: 3rem
</style>
