<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 警告
  .modal-card-body
    p もしかして検討モードで対局していませんか？
    p 対局するには対局設定をしてください
  .modal-card-foot
    b-button.misuse_modal_close_handle.has-text-weight-bold(@click="SB.misuse_modal_close_handle" type="is-primary") OK
</template>

<script>
import _ from "lodash"
import { GX } from "@/components/models/gx.js"
import { support_child } from "../support_child.js"

export default {
  name: "MisuseModal",
  mixins: [support_child],
}
</script>

<style lang="sass">
.MisuseModal
  // +modal_max_width(40rem)
  .modal-card-body
    padding: 1.5rem
    // text-wrap: balance
    text-wrap: pretty
  .modal-card-foot
    flex-direction: row-reverse
</style>
