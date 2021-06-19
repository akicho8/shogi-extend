<template lang="pug">
.ShareBoardMessageLog(v-if="base.message_logs.length >= 1")
  .scroll_block
    template(v-for="(e, i) in base.message_logs")
      ShareBoardAvatarLine(:info="e" :key="`${e.from_connection_id}_${i}`")
        .flex_item.is_line_break_on.my_message(v-html="auto_link(e.message)" v-xemoji)
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

    // border-radius: 3px
    // background-color: $white-ter
    padding: 0

    .ShareBoardAvatarLine
      padding: 0.2rem 0
      .my_message
        flex-shrink: 1
        line-height: 1.1

    // .message_log
    //   line-height: 1.5
    //   padding: 0.1rem 0.5rem
    //
    //   display: flex
    //   justify-content: start
    //   align-items: center

.STAGE-development
  .ShareBoardMessageLog
    .scroll_block
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
