<template lang="pug">
.modal-card(v-if="SB.illegal_params")
  .modal-card-head
    .modal-card-title
      | {{SB.latest_illegal_name}}で{{SB.latest_illegal_location.flip.name}}の勝ち
  .modal-card-body
    p 終局です
  .modal-card-foot
    b-button.illegal_lose_modal_close_handle(@click="SB.illegal_lose_modal_close_handle" type="is-primary") 閉じる
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "IllegalLoseModal",
  mixins: [support_child],
}
</script>

<style lang="sass">
.IllegalLoseModal
  +modal_max_width(25rem)
  .modal-card-foot
    justify-content: flex-end
</style>
