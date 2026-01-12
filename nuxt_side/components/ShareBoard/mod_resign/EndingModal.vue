<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title {{SB.ending_context.m_subject}}
  .modal-card-body
    .content
      | {{SB.ending_context.m_body}}
  .modal-card-foot
    b-button.ending_modal_close_handle.has-text-weight-normal(@click="SB.ending_modal_close_handle" type="is-primary") 閉じる
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "EndingModal",
  mixins: [support_child],
  props: ["params"],
}
</script>

<style lang="sass">
@import "../sass/support.sass"

.EndingModal
  +modal_width_auto
  // +modal_width(12rem)

  .modal-card-body
    padding: 1.5rem

  .modal-card-foot
    flex-direction: row-reverse

.STAGE-development
  .EndingModal
    __css_keep__: 0
</style>
