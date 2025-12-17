<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 同期失敗 {{SB.resend_failed_count}}回目
  .modal-card-body(v-if="SB.resend_next_user_name")
    | {{SB.user_call_name(SB.resend_next_user_name)}}の反応がないので再送してください
    ul.has-text-grey.is-size-7.mt-2
      template(v-if="true")
        li {{SB.user_call_name(SB.resend_next_user_name)}}がいなくなっている場合は順番設定から外してください
      template(v-if="SB.debug_mode_p")
        li 再送{{SB.resend_adjusted_delay_sec}}秒後に再度確認します
    template(v-if="development_p && false")
      pre {{SB.sfen_sync_params}}
    template(v-if="SB.debug_mode_p")
      b-button.resend_next_member_delete(size="is-small" @click="SB.resend_next_member_delete" type="is-danger")
        | {{SB.user_call_name(SB.resend_next_user_name)}}を順番から外す
  .modal-card-foot
    b-button.resend_confirm_break_handle(@click="SB.resend_confirm_break_handle" type="is-danger") 対局を中断する
    b-button.resend_confirm_execute_handle(@click="SB.resend_confirm_execute_handle" type="is-primary") 再送する
</template>

<script>
import { support_child } from "../support_child.js"
import { GX } from "@/components/models/gx.js"
import _ from "lodash"

export default {
  name: "ResendConfirmModal",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.ResendConfirmModal
  // +modal_max_width(480px)
  +modal_width_auto

.STAGE-development
  .ResendConfirmModal
    .modal-card-body
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
