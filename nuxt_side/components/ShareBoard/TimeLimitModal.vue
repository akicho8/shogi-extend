<template lang="pug">
.modal-card(v-if="clock_running_p")
  .modal-card-head
    .modal-card-title
      template(v-if="time_limit_info.key === 'default'")
        | 時間切れで
      template(v-if="time_limit_info.key === 'judge'")
        | 判定により
      | {{clock.current.location.flip.name}}の勝ち！
  .modal-card-body
    template(v-if="time_limit_info.key === 'judge'")
      p {{user_call_name(base.current_turn_user_name)}}は時間切れになったと思われますが{{base.cc_auto_time_limit_delay}}秒待っても本人からの通知がありませんでした
    template(v-if="clock.current.time_recovery_mode_p")
      p 時間切れになっても時計は止まってないので合意の上で続行できます
    template(v-else)
      p 時間切れになっても合意の上で続行できますが、<b>秒読み</b>や<b>1手毎加算</b>の値がもともと0のため時間が回復しません
      p もし続行する場合は時計を再設定してください
  .modal-card-foot
    b-button(@click="close_handle" type="is-primary") 閉じる
</template>

<script>
import { TimeLimitInfo } from "../models/time_limit_info.js"

export default {
  name: "TimeLimitModal",
  props: {
    base:           { type: Object, required: true, },
    time_limit_key: { type: String, required: true, },
  },
  mounted() {
    if (!this.clock_running_p) {
      this.base.tl_alert("対局時計は設定されていません")
    }
  },
  watch: {
    // 共有によって時計を止められたり消されたりしたら自動的に閉じる
    clock_running_p(v) {
      if (!v) {
        this.close_handle()
      }
    },
  },
  methods: {
    close_handle() {
      this.sound_play("click")
      this.base.time_limit_modal_close()
      this.$emit("close")
    },
    submit_handle() {
      this.close_handle()
    },
  },
  computed: {
    clock()           { return this.base.clock_box              },
    clock_running_p() { return this.clock && this.clock.running_p },

    TimeLimitInfo()   { return TimeLimitInfo },
    time_limit_info() { return this.TimeLimitInfo.fetch(this.time_limit_key) },
  },
}
</script>

<style lang="sass">
.TimeLimitModal
  +modal_max_width(25rem)
  .modal-card-body
    p:not(:first-child)
      margin-top: 0.75rem
  .modal-card-foot
    justify-content: flex-end
</style>
