<template lang="pug">
.SbDebugResend.column.is-12
  .columns.is-multiline
    .column.is-4
      .panel
        .panel-heading
          | 再送
        a.panel-block(href="?self_vs_self_enable_p=false&room_restore_feature_p=false&room_key=dev_room&user_name=a&FIXED_MEMBER=a,b,c&FIXED_ORDER=a,b&room_after_create=cc_auto_start_10m&RESEND_DELAY=0") URL固定
        a.panel-block(@click="SB.resend_confirm_modal_open") モーダル起動
    .column.is-4
      .panel.assert_var
        .panel-heading
          | [assert_var]
        .panel-block resend_success_p:{{SB.resend_success_p}}
        .panel-block resend_failed_count:{{SB.resend_failed_count}}
        .panel-block resend_failed_total:{{SB.resend_failed_total}}
        .panel-block resend_sequence_ids:{{SB.resend_sequence_ids}}
</template>

<script>
import _ from "lodash"
import { support_child } from "../support_child.js"

export default {
  name: "SbDebugResend",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbDebugResend
  __css_keep__: 0
</style>
