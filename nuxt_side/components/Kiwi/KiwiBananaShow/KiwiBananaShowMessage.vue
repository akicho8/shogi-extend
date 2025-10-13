<template lang="pug">
.KiwiBananaShowMessage
  .media(v-for="banana_message in base.banana.banana_messages")
    KiwiBananaShowAvatarLinkTo(:base="base" :user="banana_message.user")
    .media-content
      .content
        p
          nuxt-link.user_link.has-text-weight-semibold(:to="{name: 'users-id', params: {id: banana_message.user.id}}" @click.native="sfx_click()")
            | {{banana_message.user.name}}
          br
          template(v-if="banana_message.deleted_at")
            span.is_line_break_on.has-text-grey-light.is-italic
              | コメントは削除されました
          template(v-else)
            span.is_line_break_on(v-html="base.message_decorate(banana_message.body)")
          br
          template(v-if="false")
            small
              a Like
              a Reply
              | · 3 hrs
          span.is-size-7.has-text-grey-light.is_line_break_off.mr-1(v-if="false")
            | \#{{banana_message.position}}
          span.is-size-7.has-text-grey-light.is_line_break_off
            | {{$time.format_diff(banana_message.created_at)}}
          span.is-hidden
            | {{banana_message.id}}
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

  .box.mt-6.has-background-white-bis.is-shadowless.is-flex.is-justify-content-center.is-align-items-center.is-flex-direction-column(v-if="!base.g_current_user")
    .has-text-grey-light
      | ログインするとコメントできます
    b-button.has-text-weight-bold.mt-2(@click="nuxt_login_modal_handle" type="is-primary" size="is-small")
      | ログイン

  .media.MessageInput(v-if="base.g_current_user")
    KiwiBananaShowAvatarLinkTo(:base="base" :user="base.g_current_user")
    .media-content
      .field
        .control
          textarea.textarea(v-model.trim="base.message_body")
      .field
        .control
          b-button.speak_handle(@click="base.speak_handle" :class="{'is-primary': $GX.present_p(base.message_body)}") 送信
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiBananaShowMessage",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../all_support.sass"
.KiwiBananaShowMessage
  .user_link
    color: inherit

.STAGE-development
  .KiwiBananaShowMessage
    .media
      &:hover
        background-color: $white-ter
</style>
