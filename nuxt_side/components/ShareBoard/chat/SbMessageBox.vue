<template lang="pug">
.SbMessageBox.is_scroll_y
  template(v-for="e in SB.message_records")
    SbAvatarLine(:info="e" :key="e.unique_key")
      .flex_item.is-size-7(v-if="development_p") [{{e.unique_key}}]
      XemojiWrap.flex_item.message_body(:class="e.message_class" :str="SB.ml_show(e)")
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbMessageBox",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"

.SbMessageBox
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
    .UserBadge
      color: $grey

.SbApp.debug_mode_p
  .SbMessageBox
    border: 1px dashed change_color($primary, $alpha: 0.5)
    .SbAvatarLine
      &.visible_false
        background-color: LightPink
      &.visible_true
        background-color: LightSkyBlue
</style>
