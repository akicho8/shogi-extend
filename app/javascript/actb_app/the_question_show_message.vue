<template lang="pug">
.the_question_show_message
  .articles_container(ref="articles_container")
    article.media(v-for="message in new_question.messages")
      figure.media-left.is_clickable(@click="app.ov_user_info_set(message.user.id)")
        p.image.is-64x64
          img.is-rounded(:src="message.user.avatar_path")
      .media-content
        .content
          p
            strong.is_clickable(@click="app.ov_user_info_set(message.user.id)")
              | {{message.user.name}}
            br
            span(v-html="simple_format(auto_link(message.body))")
            br
            //- small
            //-   a Like
            //-   a Reply
            //-   | · 3 hrs
            span.diff_time_format
              | {{diff_time_format(message.created_at)}}
        nav.level.is-mobile(v-if="false")
          .level-left
            a.level-item
              span.icon.is-small
                i.fas.fa-reply
            a.level-item
              span.icon.is-small
                i.fas.fa-retweet
            a.level-item
              span.icon.is-small
                i.fas.fa-heart
    article.media
      figure.media-left.is_clickable(@click="app.ov_user_info_set(app.current_user.id)")
        p.image.is-64x64
          img.is-rounded(:src="app.current_user.avatar_path")
      .media-content
        .field
          p.control
            textarea.textarea(v-model.trim="message_body")
        .field
          p.control
            button.button(@click="speak_handle" :class="{'is-primary': message_body.length >= 1}")
              | 送信

  ////////////////////////////////////////////////////////////////////////////////
  template(v-if="false")
    .messages_box.has-background-light(ref="messages_box" :style="{height: `${app.config.question_messages_display_lines}rem`}")
      .message_line(v-for="message in $parent.question.messages")
        | {{message.user.name}}: {{message.body}}
        span.diff_time_format
          | ({{diff_time_format(message.created_at)}})
    b-field.input_field
      b-input(v-model="message_body" expanded @keypress.native.enter="speak_handle")
      p.control
        button.button.is-primary(@click="speak_handle")
          b-icon.play_icon(icon="play")
</template>

<script>
import { support } from "./support.js"

export default {
  name: "the_question_show_message",
  mixins: [
    support,
  ],
  props: {
    question: { type: Object, required: true },
  },
  data() {
    return {
      message_body: null,
      new_question: this.question,
    }
  },

  created() {
    this.speak_init()
    this.question_subscribe()
  },

  mounted() {
    this.scroll_to_bottom(this.$refs.messages_box)
  },

  beforeDestroy() {
    this.question_unsubscribe()
  },

  watch: {
    "new_question.messages": {
      handler() { this.scroll_to_bottom(this.$refs.messages_box) },
      immediate: true,
    },
  },

  methods: {
    question_unsubscribe() {
      this.ac_unsubscribe("$ac_question")
    },

    question_subscribe() {
      this.__assert__(this.$ac_question == null)
      this.$ac_question = this.ac_subscription_create({channel: "Actb::QuestionChannel", question_id: this.new_question.id})
    },

    ////////////////////////////////////////////////////////////////////////////////

    speak_init() {
      this.message_body = ""
    },

    speak_handle() {
      this.speak(this.message_body)
      this.message_body = ""
    },

    speak(message_body) {
      this.$ac_question.perform("speak", {message_body: message_body}) // --> app/channels/actb/question_channel.rb
    },

    speak_broadcasted(params) {
      this.app.lobby_speak_broadcasted_shared_process(params)
      this.new_question.messages.push(params.message)
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_question_show_message
  .articles_container
    // height: 100vh
    // overflow-y: scroll
    margin: 1.5rem 1rem 0rem
    article
      .diff_time_format
        // margin-left: 0.25rem
        font-size: $size-7
        color: $grey

  .messages_box
    margin-top: 1.8rem
    padding: 0.5rem
    overflow-y: scroll
    .diff_time_format
      font-size: $size-7
      margin-left: 0.25rem
      color: $grey-light
  .input_field
    margin-top: 0.5rem
    .play_icon
      min-width: 3rem
</style>
