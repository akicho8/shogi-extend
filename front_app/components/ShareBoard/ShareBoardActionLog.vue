<template lang="pug">
.ShareBoardActionLog.column
  .scroll_block(ref="scroll_block")
    template(v-for="(e, i) in filtered_action_logs")
      a.is-clickable.is-block.is_line_break_off(:key="action_log_key(e)" @click="action_log_click_handle(e)")
        span {{e.lmi.next_turn_offset}}
        span.ml-1 {{e.lmi.kif_without_from}}
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
      return [e.performed_at, e.turn_offset, e.from_connection_id].join("-")
    },
    action_log_click_handle(e) {
      if (ACTION_LOG_CLICK_CONFIRM_SHOW) {
        this.sound_play("click")
        this.$buefy.dialog.confirm({
          title: `${this.human_time_format(e)}の時点に飛びますか？`,
          message: `
            <p class="is-size-6">この時点の棋譜に変更します</p>
            <p class="is-size-6 mt-4">なので例えば対局後の検討で棋譜が消えてしまっても投了付近に飛べば棋譜を復元できます</p>
            <p class="is-size-7 has-text-grey mt-4">待ったや前の局面を見るときは盤の下のｺﾝﾄﾛｰﾗｰを使ってください</p>
          `,
          cancelText: "キャンセル",
          confirmText: `本当に飛ぶ`,
          focusOn: "cancel", // confirm or cancel
          type: "is-warning",
          // hasIcon: true,
          animation: "",
          onCancel:  () => {
            this.sound_stop_all()
            this.sound_play("click")
          },
          onConfirm: () => {
            this.sound_stop_all()
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
      return dayjs(v.performed_at).format("H時m分")
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
