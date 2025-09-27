<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 同期失敗 {{SB.rs_failed_count}}回目
  .modal-card-body(v-if="SB.rs_next_user_name")
    | 次の手番の{{SB.user_call_name(SB.rs_next_user_name)}}の通信状況が悪いため再送してください
    ul.has-text-grey.is-size-7.mt-2
      li {{SB.user_call_name(SB.rs_next_user_name)}}がいなくなっている場合は順番設定から除外してください
      template(v-if="SB.debug_mode_p")
        li {{SB.rs_resend_delay_real_sec}}秒後に再度確認します
    template(v-if="development_p")
      pre {{SB.sfen_share_params}}
    template(v-if="SB.debug_mode_p")
      b-button.rs_next_member_delete(size="is-small" @click="SB.rs_next_member_delete" type="is-danger")
        | {{SB.user_call_name(SB.rs_next_user_name)}}を順番から外す
  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left")
    b-button.resend_handle(@click="resend_handle" type="is-warning") 再送する
</template>

<script>
import { support_child } from "../support_child.js"
import { Gs } from "@/components/models/gs.js"
import _ from "lodash"

export default {
  name: "SbResendModal",
  mixins: [support_child],
  methods: {
    close_handle() {
      this.sfx_play_click()
      this.SB.rs_modal_with_timer_close()
    },
    resend_handle() {
      this.sfx_play_click()
      this.SB.rs_modal_with_timer_close()
      this.SB.sfen_share()
    },
  },
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
