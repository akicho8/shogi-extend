<template lang="pug">
.modal-card.TrackLogModal
  .modal-card-head
    .modal-card-title
      | ログ ({{SB.track_logs.length}})

  .modal-card-body
    TrackLogModalTable(ref="TrackLogModalTable")

  .modal-card-foot
    b-button.tl_modal_close_handle.has-text-weight-normal(@click="SB.tl_modal_close_handle" icon-left="chevron-left")
    b-button.tl_clear(@click="SB.tl_clear") クリア
</template>

<script>
import _ from "lodash"
import { support_child } from "../support_child.js"

export default {
  name: "TrackLogModal",
  mixins: [support_child],
  mounted() {
    this.SB.tl_scroll_to_bottom()
  },
}
</script>

<style lang="sass">
.TrackLogModal
  // +modal_width(50rem)
  // +modal_width(95vw)
  .modal-card-body
    padding: 0rem
</style>
