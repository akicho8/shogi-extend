<template lang="pug">
.SbMessageLog.is_scroll_y
  template(v-for="e in TheSb.message_logs")
    template(v-if="TheSb.message_share_received_p(e)")
      SbAvatarLine(:info="e" :key="e.unique_key")
        .flex_item(v-if="development_p") [{{e.unique_key}}]
        XemojiWrap.flex_item.message_body(:class="e.message_class" :str="e.auto_linked_message")
</template>

<script>
export default {
  name: "SbMessageLog",
  inject: ["TheSb"],
}
</script>

<style lang="sass">
@import "../support.sass"

.SbMessageLog
  @extend %overlay
  padding: 0
  .SbAvatarLine
    align-items: flex-start   // オーバーライドして全体を上に揃える
    line-height: 1.4          // 1.4 ぐらいがちょうどよい
    padding: 0.2rem 0         // 発言毎の隙間
    .message_body
      white-space: normal     // 発言は改行させる
      word-break: break-all
      flex-shrink: 1          // 縮んでよしとする
      pre
        padding: 0.5rem
        border-radius: 4px
    .user_name
      color: $grey
    .UserMedal
      color: $grey
.STAGE-development
  .SbMessageLog
    border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
