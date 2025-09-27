<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      template(v-if="timeout_info.key === 'self_notify'")
        | 時間切れで
      template(v-if="timeout_info.key === 'audo_judge'")
        | 接続切れで
      | {{snapshot_clock.current.location.flip.name}}の勝ち
  .modal-card-body
    template(v-if="SB.auto_resign_info.key === 'is_auto_resign_on'")
      p 終局です
    template(v-else)
      template(v-if="timeout_info.key === 'audo_judge'")
        p {{user_call_name(SB.current_turn_user_name)}}は接続切れのまま時間切れになりました
      template(v-else)
        p ルールを守って時間内に指しましょう
        p 対戦相手がお情けで許可してくれた場合は次の手を指して対局を続行できます
        template(v-if="!snapshot_clock.current.time_recovery_mode_p")
          p しかし現在の時計の設定では<b>秒読み</b>や<b>1手毎加算</b>の値がもともと0のため回復しません
          p もし続行する場合は時計を再設定してください
        p 続行しない場合は左上から投了しましょう
  .modal-card-foot
    b-button.close_handle(@click="close_handle" type="is-primary") 閉じる
</template>

<script>
import { TimeoutInfo } from "./timeout_info.js"
import { Location } from "shogi-player/components/models/location.js"
import { support_child } from "../support_child.js"
import { Gs } from "@/components/models/gs.js"

export default {
  name: "TimeoutModal",
  mixins: [support_child],
  props: {
    timeout_key: { type: String, required: true, },
  },
  data() {
    return {
      snapshot_clock: null,
    }
  },
  created() {
    Gs.assert(this.SB.clock_box, "this.SB.clock_box")
    this.snapshot_clock = this.SB.clock_box.duplicate
  },
  // mounted() {
  //   if (!this.clock_running_p) {
  //     this.SB.tl_alert("対局時計は設定されていません")
  //   }
  // },
  // watch: {
  //   // 共有によって時計を止められたり消されたりしたら自動的に閉じる
  //   clock_running_p(v) {
  //     if (!v) {
  //       this.close_handle()
  //     }
  //   },
  // },
  methods: {
    close_handle() {
      this.sfx_play_click()
      this.SB.cc_timeout_modal_close()
      this.$emit("close")
    },
    submit_handle() {
      this.close_handle()
    },
  },
  computed: {
    TimeoutInfo()  { return TimeoutInfo                              },
    timeout_info() { return this.TimeoutInfo.fetch(this.timeout_key) },
  },
}
</script>

<style lang="sass">
@import "../sass/support.sass"

.TimeoutModal
  +modal_max_width(25rem)
  .modal-card-body
    p:not(:first-child)
      margin-top: 0.75rem
  .modal-card-foot
    justify-content: flex-end
</style>
