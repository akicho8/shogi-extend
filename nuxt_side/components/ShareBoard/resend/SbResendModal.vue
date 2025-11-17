<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 同期失敗 {{SB.rs_failed_count}}回目
  .modal-card-body(v-if="SB.rs_next_user_name")
    | 次の手番の{{SB.user_call_name(SB.rs_next_user_name)}}の通信状況が悪いため再送してください
    ul.has-text-grey.is-size-7.mt-2
      li {{SB.user_call_name(SB.rs_next_user_name)}}がいなくなっている場合は順番設定から外してください
      template(v-if="SB.debug_mode_p")
        li {{SB.rs_resend_delay_real_sec}}秒後に再度確認します
    template(v-if="development_p")
      pre {{SB.sfen_share_params}}
    template(v-if="SB.debug_mode_p")
      b-button.rs_next_member_delete(size="is-small" @click="SB.rs_next_member_delete" type="is-danger")
        | {{SB.user_call_name(SB.rs_next_user_name)}}を順番から外す
  .modal-card-foot
    b-button.rs_break_handle(@click="SB.rs_break_handle" type="is-danger") 対局を中断する
    b-button.rs_resend_handle(@click="SB.rs_resend_handle" type="is-primary") 再送する
</template>

<script>
import { support_child } from "../support_child.js"
import { GX } from "@/components/models/gx.js"
import _ from "lodash"

export default {
  name: "SbResendModal",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbResendModal
  // +modal_max_width(480px)
  +modal_width_auto

.STAGE-development
  .SbResendModal
    .modal-card-body
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
