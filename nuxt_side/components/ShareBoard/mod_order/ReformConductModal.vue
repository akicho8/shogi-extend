<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 警告
  .modal-card-body
    .content
      p これは「待った」で反則をなかったことにできる接待用のモードです
      p すでに将棋のルールを理解し、{{message_variant}}{{SB.my_call_name}}には必要ないでしょう
  .modal-card-foot
    b-button.submit_handle(@click="submit_handle" type="is-warning") 接待する・される
    b-button.cancel_handle(@click="cancel_handle" type="is-primary") もちろん必要ない
</template>

<script>
import { GX } from "@/components/models/gx.js"
import { support_child } from "../support_child.js"
import { PraiseInfo } from "./praise_info.js"

export default {
  name: "ReformConductModal",
  mixins: [support_child],
  inject: ["TheOSM"],
  methods: {
    submit_handle() {
      this.sfx_play("x")
      this.TheOSM.reform_conduct_modal_close()
    },
    cancel_handle() {
      this.sfx_play("o")
      this.toast_primary("さすがです")
      this.SB.order_draft.foul_mode_key = "lose"
      this.TheOSM.reform_conduct_modal_close()
    },
  },
  computed: {
    message_variant() { return GX.ary_sample(PraiseInfo.values).message },
  },
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.ReformConductModal
  +modal_width(400px)
</style>
