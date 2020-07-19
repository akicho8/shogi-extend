<template lang="pug">
.the_question_show_message
  .articles_container.mx-4(ref="articles_container")
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
            span(v-html="message_decorate(message.body)")
            br
            template(v-if="false")
              small
                a Like
                a Reply
                | · 3 hrs
            span.diff_time_format.is-size-7.has-text-grey-light.is_line_break_off
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
    article.media(v-if="app.current_user")
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
  beforeDestroy() {
    this.question_unsubscribe()
  },
  methods: {
    ////////////////////////////////////////////////////////////////////////////////
    question_unsubscribe() {
      this.ac_unsubscribe("$ac_question")
    },
    question_subscribe() {
      this.__assert__(this.$ac_question == null, "this.$ac_question == null")
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
    ////////////////////////////////////////////////////////////////////////////////
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_question_show_message
</style>
