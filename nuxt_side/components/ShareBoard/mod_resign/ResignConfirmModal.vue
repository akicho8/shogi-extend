<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title 投了
    a.cc_timeout_trigger(@click="SB.cc_timeout_trigger" v-if="SB.debug_mode_p") 時間切れ
  .modal-card-body
    .content
      p {{SB.resign_confirm_message}}
      p.resign_warn_message.is-size-7.has-text-grey(v-if="SB.my_team_member_is_many_p")
        | 自分本位の投了は仲間から反感を買う恐れがあります
  .modal-card-foot
    b-button.resign_confirm_modal_close_handle.has-text-weight-normal(@click="SB.resign_confirm_modal_close_handle" icon-left="chevron-left") 諦めない
    b-button.resign_submit_handle(@click="SB.resign_submit_handle" type="is-danger") 投了する
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "ResignConfirmModal",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"

.ResignConfirmModal
  +modal_width(24rem)

  .modal-card-body
    padding: 1.5rem

  .modal-card-foot
    .button
      min-width: 6rem

.STAGE-development
  .ResignConfirmModal
    __css_keep__: 0
</style>
