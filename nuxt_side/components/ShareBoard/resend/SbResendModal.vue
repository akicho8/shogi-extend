<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 同期失敗 {{TheSb.rs_failed_count}}回目
  .modal-card-body
    | 次の手番の{{TheSb.rs_next_user_name}}の通信状況が悪いため再送してください
    ul.has-text-grey.is-size-7.mt-2
      li 再送しないと対局を続けられません
      li {{TheSb.rs_retry_check_delay}}秒後に再度確認します
  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left") 諦める
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
