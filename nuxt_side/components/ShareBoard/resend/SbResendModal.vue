<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 同期失敗 {{TheSb.rs_failed_count}}回目
  .modal-card-body(v-if="TheSb.rs_next_user_name")
    | 次の手番の{{TheSb.user_call_name(TheSb.rs_next_user_name)}}の通信状況が悪いため再送してください
    ul.has-text-grey.is-size-7.mt-2
      li {{TheSb.user_call_name(TheSb.rs_next_user_name)}}がいなくなっている場合は順番設定から除外してください
      template(v-if="TheSb.debug_mode_p")
        li {{TheSb.rs_retry_check_delay}}秒後に再度確認します
    template(v-if="development_p")
      pre {{TheSb.sfen_share_params}}
    template(v-if="TheSb.debug_mode_p")
      b-button.rs_next_member_delete(size="is-small" @click="TheSb.rs_next_member_delete" type="is-danger")
        | {{TheSb.user_call_name(TheSb.rs_next_user_name)}}を順番から外す
  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left") 閉じる
    b-button.resend_handle(@click="resend_handle" type="is-warning") 再送する
</template>

<script>
import { support_child } from "../support_child.js"
import { Gs } from "@/components/models/gs.js"
import _ from "lodash"

export default {
  name: "SbResendModal",
  mixins: [support_child],
  data() {
    return {
    }
  },
  inject: ["TheSb"],
  methods: {
    close_handle() {
      this.$sound.play_click()
      this.TheSb.rs_modal_close()
    },
    resend_handle() {
      this.$sound.play_click()
      this.TheSb.rs_modal_close()
      this.TheSb.sfen_share()
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.SbResendModal
  // +modal_max_width(480px)
  +modal_width_auto

.STAGE-development
  .SbResendModal
    .modal-card-body
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
