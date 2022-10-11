<template lang="pug">
.ShareBoardMessageLog(v-if="TheSb.message_logs.length >= 1 || true")
  .scroll_block.is_scroll_y
    template(v-for="(e, i) in TheSb.message_logs")
      template(v-if="TheSb.message_share_received_p(e)")
        //- .message_log_one(:key="e.unique_key")
        ShareBoardAvatarLine(:info="e" :key="e.unique_key")
          XemojiWrap.flex_item.is_line_break_on.message_body(:class="{'has-text-success': e.message_scope_key === 'is_message_scope_private'}" :str="auto_link(e.message)")
        //- template(v-if="present_p(e.result_str)")
        //-   pre.result_pre.is_line_break_on {{e.result_str}}
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "ShareBoardMessageLog",
  mixins: [support_child],
  inject: ["TheSb"],
  mounted() {
    // ここで実行しても効かない
    // this.TheSb.ml_scroll_to_bottom()
  },
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
    .result_pre
      padding: 0.5rem

.STAGE-development
  .ShareBoardMessageLog
    .scroll_block
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
