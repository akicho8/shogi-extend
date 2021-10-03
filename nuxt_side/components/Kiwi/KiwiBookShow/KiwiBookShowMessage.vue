<template lang="pug">
.KiwiBookShowMessage
  .media(v-for="book_message in base.book.book_messages")
    KiwiBookShowAvatarLinkTo(:base="base" :user="book_message.user")
    .media-content
      .content
        p
          nuxt-link.user_link.has-text-weight-semibold(:to="{name: 'users-id', params: {id: book_message.user.id}}" @click.native="sound_play('click')")
            | {{book_message.user.name}}
          br
          template(v-if="book_message.deleted_at")
            span.is_line_break_on.has-text-grey-light.is-italic
              | コメントは削除されました
          template(v-else)
            span.is_line_break_on(v-html="base.message_decorate(book_message.body)")
          br
          template(v-if="false")
            small
              a Like
              a Reply
              | · 3 hrs
          span.is-size-7.has-text-grey-light.is_line_break_off
            | \#{{book_message.position}}
          span.is-size-7.has-text-grey-light.is_line_break_off.ml-1
            | {{diff_time_format(book_message.created_at)}}
          span.is-hidden
            | {{book_message.id}}
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
    KiwiBookShowAvatarLinkTo(:base="base" :user="base.g_current_user")
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

.STAGE-development
  .KiwiBookShowMessage
    .media
      &:hover
        background-color: $white-ter
</style>
