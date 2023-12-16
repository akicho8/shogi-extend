<template lang="pug">
.SbMessageList.is_scroll_y
  template(v-for="e in TheSb.message_list")
    SbAvatarLine(:info="e" :key="e.unique_key")
      .flex_item.is-size-7(v-if="development_p") [{{e.unique_key}}]
      XemojiWrap.flex_item.message_body(:class="e.message_class" :str="TheSb.ml_show(e)")
</template>

<script>
export default {
  name: "SbMessageList",
  inject: ["TheSb"],
}
</script>

<style lang="sass">
@import "../support.sass"

.SbMessageList
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

.SbApp.debug_mode_p
  .SbMessageList
    border: 1px dashed change_color($primary, $alpha: 0.5)
    .SbAvatarLine
      &.visible_false
        background-color: LightPink
      &.visible_true
        background-color: LightSkyBlue
</style>
