<template lang="pug">
.modal-card(v-if="SB.tab_dup_info")
  .modal-card-head
    .modal-card-title(v-html="SB.tab_dup_info.subject")
  .modal-card-body(v-html="SB.tab_dup_info.message")
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
  +modal_max_width(25rem)
  .modal-card-body
    display: flex
    flex-direction: column
    gap: 1rem
    padding: 1.5rem
    text-wrap: pretty
  .modal-card-foot
    flex-direction: row-reverse
</style>
