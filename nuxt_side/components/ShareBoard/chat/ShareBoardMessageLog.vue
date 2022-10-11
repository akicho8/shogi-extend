<template lang="pug">
.ShareBoardMessageLog
  .scroll_block.is_scroll_y
    template(v-for="e in TheSb.message_logs")
      template(v-if="TheSb.message_share_received_p(e)")
        ShareBoardAvatarLine(:info="e" :key="e.unique_key")
          XemojiWrap.flex_item.is_line_break_on.message_body(:class="e.css_class" :str="e.auto_linked_message")
</template>

<script>
export default {
  name: "ShareBoardMessageLog",
  inject: ["TheSb"],
}
</script>

<style lang="sass">
@import "../support.sass"

.ShareBoardMessageLog
  position: relative
  height: 10rem
  margin-bottom: 1rem

  .scroll_block
    @extend %overlay
    padding: 0
    .ShareBoardAvatarLine
      padding: 0.2rem 0
      .message_body
        flex-shrink: 1
        // line-height: 1.1  // 発言が1行のとき名前と発言がずれるので設定しない方が良い
      .user_name
        color: $grey

.STAGE-development
  .ShareBoardMessageLog
    .scroll_block
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
