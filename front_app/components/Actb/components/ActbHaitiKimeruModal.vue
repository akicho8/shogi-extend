<template lang="pug">
.modal-card.ActbHaitiKimeruModal(:base="base" style="width: auto")
  header.modal-card-head
    p.modal-card-title 局面を確定させてください
  section.modal-card-body
    MyShogiPlayer(
      :run_mode="'view_mode'"
      :kifu_body="yomikonda_sfen"
      :start_turn="start_turn"
      :key_event_capture="false"
      :slider_show="true"
      :controller_show="true"
      :setting_button_show="false"
      :theme="'simple'"
      :size="'default'"
      @update:mediator_snapshot_sfen="mediator_snapshot_sfen_set"
      )
  footer.modal-card-foot
    b-button(@click="submit_handle" type="is-primary") この局面にする
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "ActbHaitiKimeruModal",
  mixins: [
    support_child,
  ],
  props: {
    yomikonda_sfen: { type: String, required: true,              },
    start_turn:     { type: Number, required: true, default: -1, },
  },
  data() {
    return {
      kyokumen_kimeta_sfen: null,
    }
  },
  created() {
    this.debug_alert(`start_turn: ${this.start_turn}`)
  },
  methods: {
    mediator_snapshot_sfen_set(sfen) {
      this.kyokumen_kimeta_sfen = sfen
    },
    submit_handle() {
      this.$emit("update:kyokumen_kimeta_sfen", this.kyokumen_kimeta_sfen)
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.ActbHaitiKimeruModal
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
