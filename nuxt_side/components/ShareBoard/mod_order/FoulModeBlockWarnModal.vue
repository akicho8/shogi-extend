<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 警告
  .modal-card-body
    .content
      p 反則ブロックは反則時に御法度の「待った」ができる接待用のモードです
      p すでに将棋のルールを理解し、向上心と矜恃を拠り所として研鑽に励む{{SB.my_call_name}}には必要ないでしょう
  .modal-card-foot
    b-button.submit_handle(@click="submit_handle" type="is-warning") 接待する・される
    b-button.cancel_handle(@click="cancel_handle" type="is-primary") もちろん必要ない
</template>

<script>
import { GX } from "@/components/models/gx.js"
import { support_child } from "../support_child.js"

export default {
  name: "FoulModeBlockWarnModal",
  mixins: [support_child],
  inject: ["TheOSM"],
  methods: {
    submit_handle() {
      this.sfx_play("x")
      this.TheOSM.foul_mode_block_warn_modal_close()
    },
    cancel_handle() {
      this.sfx_play("o")
      this.toast_primary("さすがです")
      this.SB.order_draft.foul_mode_key = "lose"
      this.TheOSM.foul_mode_block_warn_modal_close()
    },
  },
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.FoulModeBlockWarnModal
  +modal_width(400px)
</style>
