<template lang="pug">
.ShareBoardMemberList.column
  .scroll_block(ref="scroll_block")
    template(v-for="(e, i) in member_infos")
      .member_info.is_line_break_off(:key="e.from_user_code")
        span {{e.from_user_name}}
        span.ml-1.is-size-7.time_format.has-text-grey-light(v-if="development_p") {{time_format(e)}}
        span.ml-1(v-if="development_p") {{e.revision}}
        span.ml-1(v-if="development_p") {{e.user_age}}
</template>

<script>
import { support_child } from "./support_child.js"
import dayjs from "dayjs"
import { Location } from "shogi-player/components/models/location.js"

export default {
  name: "ShareBoardMemberList",
  mixins: [
    support_child,
  ],
  props: {
  },
  data() {
    return {
    }
  },
  mounted() {
  },
  methods: {
    action_log_click_handle(action_log) {
      // this.base.current_sfen = action_log.sfen
      // this.base.turn_offset = action_log.turn_offset
    },
    time_format(v) {
      return dayjs.unix(v.performed_at).format("HH:mm:ss")
    },
  },
  computed: {
    member_infos() {
      // return _.reverse(this.base.action_logs.slice())
      return this.base.member_infos
    },
  },
}
</script>

<style lang="sass">
@import "./support.sass"

.ShareBoardMemberList.column
  position: relative
  +tablet
    max-width: 12rem
  +desktop
    max-width: 16rem
  +mobile
    height: 10rem

  .scroll_block
    @extend %overlay

    overflow-y: scroll
    overflow-x: hidden

    border-radius: 3px
    background-color: $white-ter
    padding: 0

    .time_format
      vertical-align: middle
    .member_info
      text-overflow: ellipsis
      padding: 0.2rem 0.5rem
      color: inherit

.STAGE-development
  .ShareBoardMemberList
</style>
