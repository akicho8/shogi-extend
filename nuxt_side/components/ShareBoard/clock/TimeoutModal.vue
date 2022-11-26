<template lang="pug">
.modal-card(v-if="clock_running_p")
  .modal-card-head
    .modal-card-title
      template(v-if="timeout_info.key === 'self_notification'")
        | 時間切れで
      template(v-if="timeout_info.key === 'audo_judgement'")
        | 接続切れで
      | {{current_location.flip.name}}の勝ち！
  .modal-card-body
    template(v-if="TheSb.toryo_timing_info.toryo_auto_run")
      p 終局です
    template(v-else)
      template(v-if="timeout_info.key === 'audo_judgement'")
        p {{user_call_name(TheSb.current_turn_user_name)}}は接続切れのまま時間切れになりました
      template(v-else)
        p ルールを守って時間内に指しましょう
        p 対戦相手がお情けで許可してくれた場合は次の手を指して対局を続行できます
        template(v-if="!clock.current.time_recovery_mode_p")
          p しかし現在の時計の設定では<b>秒読み</b>や<b>1手毎加算</b>の値がもともと0のため回復しません
          p もし続行する場合は時計を再設定してください
        p 続行しない場合は投了しましょう
  .modal-card-foot
    b-button(@click="close_handle" type="is-primary") 閉じる
</template>

<script>
import { TimeoutInfo } from "./timeout_info.js"
import { Location } from "shogi-player/components/models/location.js"

export default {
  name: "TimeoutModal",
  props: {
    timeout_key: { type: String, required: true, },
  },
  inject: ["TheSb"],
  data() {
    return {
      current_location: null, // モーダル発動時の先後
    }
  },
  created() {
    // モーダル発動後に指すとモーダル内の先後が変わって勝敗が逆になる表記をしてしまうのを防ぐため保持しておく
    if (this.clock_running_p) {
      this.current_location = this.clock.current.location
    }
  },
  mounted() {
    if (!this.clock_running_p) {
      this.TheSb.tl_alert("対局時計は設定されていません")
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
      this.$sound.play_click()
      this.TheSb.timeout_modal_close()
      this.$emit("close")
    },
    submit_handle() {
      this.close_handle()
    },
  },
  computed: {
    clock()           { return this.TheSb.clock_box              },
    clock_running_p() { return this.clock && this.clock.pause_or_play_p },

    TimeoutInfo()   { return TimeoutInfo },
    timeout_info() { return this.TimeoutInfo.fetch(this.timeout_key) },
  },
}
</script>

<style lang="sass">
@import "../support.sass"

.TimeoutModal
  +modal_max_width(25rem)
  .modal-card-body
    p:not(:first-child)
      margin-top: 0.75rem
  .modal-card-foot
    justify-content: flex-end
</style>
