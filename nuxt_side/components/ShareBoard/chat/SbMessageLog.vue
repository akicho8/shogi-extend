<template lang="pug">
.SbMessageLog.is_scroll_y
  //- .SbAvatarLine(v-for="iob_row in TheSb.iob_rows" :key="iob_row") {{iob_row}}
  template(v-for="e in TheSb.message_logs")
    SbAvatarLine(:info="e" :key="e.unique_key")
      .flex_item(v-if="development_p") [{{e.unique_key}}]
      XemojiWrap.flex_item.message_body(:class="e.message_class" :str="TheSb.ml_show(e)")
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

.STAGE-development
  .SbMessageLog
    .SbAvatarLine
      font-size: 4rem
      // color: hsl(0 0% 60%)
      // border: 1px solid hsl(0 0% 60%)
      // flex: 1 0 200px
      // display: flex
      // align-items: center
      // justify-content: center
      // background-color: hsl(0 0% 85%)
      &.visible_false
        background-color: LightPink
      &.visible_true
        background-color: LightSkyBlue
</style>
