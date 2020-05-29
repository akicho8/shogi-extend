<template lang="pug">
.the_question_message.columns
  .column
    .messages_box.has-background-light(ref="messages_box" :style="{height: `${app.config.question_messages_display_lines}rem`}")
      .message_line(v-for="message in question.messages")
        | {{message.user.name}}: {{message.body}}
        | (12:34)
    b-field.input_field
      b-input(v-model="message_body" expanded @keypress.native.enter="speak_handle")
      p.control
        button.button.is-primary(@click="speak_handle")
          b-icon.play_icon(icon="play")
</template>

<script>
import consumer from "channels/consumer"
import { support } from "./support.js"

export default {
  name: "the_question_message",
  mixins: [
    support,
  ],
  data() {
    return {
      message_body: null,
    }
  },

  created() {
    this.speak_init()
    this.question_subscribe()
  },

  beforeDestroy() {
    this.question_unsubscribe()
  },

  watch: {
    "app.overlay_record.question.messages": {
      handler() { this.scroll_to_bottom(this.$refs.messages_box) },
      immediate: true,
    },
  },

  methods: {
    question_unsubscribe() {
      if (this.$ac_question) {
        this.$ac_question.unsubscribe()
        this.$ac_question = null
        this.ac_info_update()
      }
    },

    question_subscribe() {
      this.__assert__(this.$ac_question == null)
      this.$ac_question = consumer.subscriptions.create({channel: "Actb::QuestionChannel", question_id: this.question.id}, {
        connected: () => {
          this.ac_info_update()
          this.debug_alert("question 接続")
        },
        disconnected: () => {
          this.ac_info_update()
          this.debug_alert("question 切断")
        },
        received: (data) => {
          this[data.bc_action](data.bc_params)
        },
      })
    },

    ////////////////////////////////////////////////////////////////////////////////

    speak_init() {
      this.message_body = ""
    },

    speak_handle() {
      this.speak(this.message_body)
      this.message_body = ""
    },

    speak(message) {
      this.$ac_question.perform("speak", {message: message}) // --> app/channels/actb/question_channel.rb
    },

    speak_broadcasted(params) {
      this.app.lobby_speak_broadcasted_shared_process(params)
      this.app.overlay_record.question.messages.push(params.message)
    },
  },

  computed: {
    question() {
      return this.app.overlay_record.question
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_question_message
  .messages_box
    padding: 0.5rem
    overflow-y: scroll
  .input_field
    margin-top: 0.5rem
    .play_icon
      min-width: 3rem
</style>
