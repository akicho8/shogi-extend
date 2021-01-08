<template lang="pug">
.ShareBoardActionLog.column
  .scroll_block(ref="scroll_block")
    template(v-for="(e, i) in filtered_action_logs")
      a.is-clickable.is-block.is_line_break_off(:key="action_log_key(e)" @click="action_log_click_handle(e)")
        span.has-text-weight-bold {{e.turn_offset}}
        span.ml-1 {{location_name(e)}}
        span.ml-1 {{e.from_user_name}}
        span.ml-1.is-size-7.time_format.has-text-grey-light {{time_format(e)}}
</template>

<script>
import { support_child } from "./support_child.js"
import dayjs from "dayjs"
import { Location } from "shogi-player/components/models/location.js"

const ACTION_LOG_CLICK_CONFIRM_SHOW = true

export default {
  name: "ShareBoardActionLog",
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
    if (this.development_p) {
      for (let i = 0; i < 100; i++) {
        this.base.al_add_test()
      }
    }
  },
  methods: {
    action_log_key(e) {
      return [e.performed_at, e.turn_offset, e.from_user_code].join("-")
    },
    action_log_click_handle(e) {
      if (ACTION_LOG_CLICK_CONFIRM_SHOW) {
        const message = `${this.base.call_name(e.from_user_name)}が指した${e.turn_offset}手目に戻りますか？`
        this.talk(message)
        this.$buefy.dialog.confirm({
          message: message,
          cancelText: "キャンセル",
          confirmText: `${e.turn_offset}手目に戻る`,
          onCancel:  () => {
            this.talk_stop()
            this.sound_play("click")
          },
          onConfirm: () => {
            this.talk_stop()
            this.action_log_jump(e)
          },
        })
      } else {
        this.action_log_jump(e)
      }
    },
    action_log_jump(e) {
      this.base.current_sfen = e.sfen
      this.base.turn_offset = e.turn_offset
    },
    time_format(v) {
      return dayjs.unix(v.performed_at).format("HH:mm:ss")
    },
    location_name(v) {
      return Location.fetch(v.performed_last_location_key).name
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
  +tablet
    max-width: 8rem
  +desktop
    max-width: 12rem
  +widescreen
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
    a
      text-overflow: ellipsis
      padding: 0.2rem 0.5rem
      color: inherit
      &:hover
        background-color: $grey-lighter

.STAGE-development
  .ShareBoardActionLog
</style>
