<template lang="pug">
.modal-card.ActbSfenTrimModal(:base="base" style="width: auto")
  header.modal-card-head
    p.modal-card-title.is-size-6 局面を確定させてください
  section.modal-card-body
    CustomShogiPlayer(
      sp_mobile_vertical="is_mobile_vertical_off"
      sp_run_mode="view_mode"
      :sp_body="default_sp_body"
      :sp_turn="sp_turn"
      sp_slider="is_slider_on"
      sp_controller="is_controller_on"
      @update:mediator_snapshot_sfen="mediator_snapshot_sfen_set"
      )
  footer.modal-card-foot
    b-button(@click="submit_handle" type="is-primary") この局面にする
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "ActbSfenTrimModal",
  mixins: [
    support_child,
  ],
  props: {
    default_sp_body: { type: String, required: true,              },
    sp_turn:     { type: Number, required: true, default: -1, },
  },
  data() {
    return {
      fixed_sfen: null,
    }
  },
  created() {
    this.debug_alert(`sp_turn: ${this.sp_turn}`)
  },
  methods: {
    mediator_snapshot_sfen_set(sfen) {
      this.fixed_sfen = sfen
    },
    submit_handle() {
      this.$emit("update:fixed_sfen", this.fixed_sfen)
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.ActbSfenTrimModal
  .modal-card-body
    +mobile
      padding: 0
      padding-top: 1.5rem
      padding-bottom: 1rem
  .modal-card-foot
    justify-content: flex-end
    .button
      font-weight: bold
</style>
