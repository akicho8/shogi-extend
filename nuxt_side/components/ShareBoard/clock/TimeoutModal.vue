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
    p 終局です
  .modal-card-foot
    b-button.ok_handle(@click="ok_handle" type="is-primary") 閉じる
</template>

<script>
import { TimeoutInfo } from "./timeout_info.js"
import { support_child } from "../support_child.js"
import { GX } from "@/components/models/gx.js"

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
    GX.assert(this.SB.clock_box, "this.SB.clock_box")
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
  //       this.ok_handle()
  //     }
  //   },
  // },
  methods: {
    ok_handle() {
      this.sfx_click()
      this.SB.cc_timeout_modal_close()
      this.$emit("close")
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
