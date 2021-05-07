<template lang="pug">
.ShareBoardMessageLog(v-if="base.message_logs.length >= 1")
  .scroll_block
    template(v-for="(e, i) in base.message_logs")
      .message_log.is_line_break_on(:key="`${e.from_user_code}_${i}`")
        span.has-text-primary {{e.from_user_name}}
        span.ml-1(v-html="auto_link(e.message)")
</template>

<script>
import { support_child } from "./support_child.js"
import dayjs from "dayjs"
import { Location } from "shogi-player/components/models/location.js"

export default {
  name: "ShareBoardMessageLog",
  mixins: [support_child],
  mounted() {
    // ここで実行しても効かない
    // this.base.ml_scroll_to_bottom()
  },
}
</script>

<style lang="sass">
@import "./support.sass"

.ShareBoardMessageLog
  position: relative
  height: 10rem
  margin-bottom: 1rem

  .scroll_block
    @extend %overlay

    overflow-y: auto

    border-radius: 3px
    background-color: $white-ter
    padding: 0

    .message_log
      line-height: 1.5
      padding: 0 0.5rem

.STAGE-development
  // .ShareBoardMessageLog
  //   border: 1px dashed change_color($primary, $alpha: 0.5)
  //   .message_log
  //     border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
