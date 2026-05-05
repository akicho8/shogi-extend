<template lang="pug">
.modal-card(v-if="SB.tab_dup_info")
  .modal-card-head
    .modal-card-title(v-if="SB.tab_dup_info.subject" v-html="SB.tab_dup_info.subject")
  .modal-card-body
    template(v-if="SB.tab_dup_info")
      p(v-html="SB.tab_dup_info.message")
  .modal-card-foot
    b-button.tab_dup_modal_close_handle.has-text-weight-bold(@click="SB.tab_dup_modal_close_handle" type="is-primary") OK
</template>

<script>
import _ from "lodash"
import { GX } from "@/components/models/gx.js"

import { support_child } from "../support_child.js"

export default {
  name: "TabDupModal",
  mixins: [support_child],
}
</script>

<style lang="sass">
.TabDupModal
  // +modal_max_width(40rem)
  .modal-card-body
    padding: 1.5rem
    // text-wrap: balance
    text-wrap: pretty
  .modal-card-foot
    flex-direction: row-reverse
</style>
