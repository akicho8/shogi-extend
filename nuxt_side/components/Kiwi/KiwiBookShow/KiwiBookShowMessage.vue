<template lang="pug">
.KiwiBookShowMessage
  .media(v-for="book_message in base.book.book_messages")
    .media-left.is-clickable
      nuxt-link.image.is-48x48(:to="{name: 'users-id', params: {id: book_message.user.id}}" @click.native="sound_play('click')")
        img.is-rounded(:src="book_message.user.avatar_path" :alt="book_message.user.name")

    .media-content
      .content
        p
          nuxt-link.user_link.has-text-weight-semibold(:to="{name: 'users-id', params: {id: book_message.user.id}}" @click.native="sound_play('click')")
            | {{book_message.user.name}}
          br
          span(v-html="base.message_decorate(book_message.body)")
          br
          template(v-if="false")
            small
              a Like
              a Reply
              | · 3 hrs
          span.is-size-7.has-text-grey-light.is_line_break_off
            | {{diff_time_format(book_message.created_at)}}
      .level.is-mobile(v-if="false")
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
  .media(v-if="base.g_current_user")
    .media-left.is-clickable
      nuxt-link.image.is-48x48(:to="{name: 'users-id', params: {id: base.g_current_user.id}}" @click.native="sound_play('click')")
        img.is-rounded(:src="base.g_current_user.avatar_path" :alt="base.g_current_user.name")
    .media-content
      .field
        .control
          textarea.textarea(v-model.trim="base.message_body")
      .field
        .control
          b-button(@click="base.speak_handle" :class="{'is-primary': present_p(base.message_body)}") 送信
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiBookShowMessage",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../all_support.sass"
.KiwiBookShowMessage
  .user_link
    color: inherit
</style>
