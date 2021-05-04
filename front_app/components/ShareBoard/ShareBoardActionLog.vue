<template lang="pug">
.ShareBoardActionLog.column
  .scroll_block(ref="scroll_block")
    template(v-for="(e, i) in filtered_action_logs")
      a.is-clickable.is-block.is_line_break_off(:key="action_log_key(e)" @click="action_log_click_handle(e)")
        span {{e.turn_offset}}
        span.ml-1(v-if="e.last_move_kif") {{e.last_move_kif}}
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
      for (let i = 0; i < 5; i++) {
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
        this.sound_play("click")
        this.$buefy.dialog.confirm({
          message: `この時点にワープしますか？<p class="is-size-7 has-text-grey">待ったや前の局面を見るときは下のｺﾝﾄﾛｰﾗｰを使ってください</p>`,
          cancelText: "キャンセル",
          confirmText: `本当にワープする`,
          focusOn: "cancel", // confirm or cancel
          type: "is-warning",
          hasIcon: true,
          animation: "",
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
      // if (this.base.current_sfen === e.sfen && this.base.turn_offset === e.turn_offset) {
      //   this.toast_ok("同じ局面です")
      //   return
      // }
      this.base.current_sfen = e.sfen
      this.base.turn_offset = e.turn_offset
    },
    time_format(v) {
      return dayjs(v.performed_at).format("HH:mm:ss")
    },
    human_time_format(v) {
      return dayjs(v.performed_at).format("H時m分s秒")
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

    overflow-y: auto
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
