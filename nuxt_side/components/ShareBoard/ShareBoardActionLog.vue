<template lang="pug">
.ShareBoardActionLog.column(:class="{'content_blank_p': blank_p(filtered_action_logs)}")
  .is-hidden-tablet.is-size-7.has-text-weight-bold
    | 操作履歴
    span.has-text-grey-light.has-text-weight-normal.mx-1
      | タップで戻れる
  .scroll_block_container
    .scroll_block.is_scroll_y(ref="scroll_block")
      template(v-for="(e, i) in filtered_action_logs")
        ShareBoardAvatarLine.is-clickable(:base="base" :info="e" tag="a" :key="action_log_key(e)" @click="action_log_click_handle(e)")
          b-tag.flex_item(type="is-warning is-light" v-if="present_p(e.x_retry_count) && e.x_retry_count >= 1") 再送{{e.x_retry_count}}
          b-tag.flex_item(type="is-primary is-light" v-if="e.label") {{e.label}}
          template(v-if="e.lmi")
            .flex_item {{e.lmi.next_turn_offset}}
            .flex_item {{e.lmi.kif_without_from}}
          .flex_item.is-size-7.has-text-grey(v-if="'elapsed_sec' in e") {{-e.elapsed_sec}}秒
          .flex_item.is-size-7.time_format.has-text-grey-light(v-if="e.performed_at") {{time_format(e)}}
</template>

<script>
import { support_child } from "./support_child.js"
import dayjs from "dayjs"
import { Location } from "shogi-player/components/models/location.js"
import ActionLogJumpPreviewModal from "./ActionLogJumpPreviewModal.vue"

export default {
  name: "ShareBoardActionLog",
  mixins: [support_child],
  mounted() {
    if (this.development_p) {
      for (let i = 0; i < 3; i++) {
        this.base.al_add_test()
      }
    }
  },
  methods: {
    action_log_key(e) {
      return [e.performed_at, e.turn, e.from_connection_id || ""].join("-")
    },
    action_log_click_handle(e) {
      this.sound_play_click()
      this.modal_card_open({
        component: ActionLogJumpPreviewModal,
        props: {
          base: this.base,
          action_log: e,
        },
      })
    },
    time_format(v) {
      return dayjs(v.performed_at).format("HH:mm:ss")
    },
  },
  computed: {
    filtered_action_logs() {
      // return _.reverse(this.base.action_logs.slice())
      return this.base.action_logs
    },
  },
}
</script>

<style lang="sass">
@import "./support.sass"

.ShareBoardActionLog.column
  position: relative
  +mobile
    height: 16rem
  +tablet
    padding: 0
    max-width: 8rem
  +desktop
    max-width: 12rem
  +widescreen
    max-width: 16rem

  .scroll_block_container
    position: relative
    height: 100%
    .scroll_block
      @extend %overlay
      +is_scroll_x

      padding: 0

      .ShareBoardAvatarLine
        line-height: 2.25
        padding: 0.2rem 0rem
        color: inherit

        &:hover
          background-color: $white-ter

        +desktop
          .time_format
            display: none
          &:hover
            .time_format
              display: block

.ShareBoardApp.debug_mode_p
  .ShareBoardActionLog
    .scroll_block
      // border-radius: 3px
      // background-color: $white-ter

.ShareBoardActionLog.column
  &.content_blank_p
    +mobile
      display: none
</style>
