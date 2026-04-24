<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | {{SB.ending_context.modal_title}}
  .modal-card-body
    .content.is_line_break_on
      | {{SB.ending_context.modal_body}}
  .modal-card-foot
    b-button.ending_modal_close_handle.has-text-weight-normal(@click="SB.ending_modal_close_handle" type="is-primary") OK
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
@import "../stylesheets/support"

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
