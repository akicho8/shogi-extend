<template lang="pug">
.modal-card.haiti_kimeru_modal(style="width: auto")
  header.modal-card-head
    p.modal-card-title 局面を確定させてください
  section.modal-card-body
    shogi_player(
      :run_mode="'view_mode'"
      :kifu_body="yomikonda_sfen"
      :start_turn="start_turn"
      :key_event_capture="false"
      :slider_show="true"
      :controller_show="true"
      :setting_button_show="false"
      :theme="'simple'"
      :size="'default'"
      :sound_effect="true"
      :volume="0.5"
      @update:mediator_snapshot_sfen="mediator_snapshot_sfen_set"
      )
  footer.modal-card-foot
    b-button(@click="submit_handle" type="is-primary") この局面にする
</template>

<script>
import { support } from "../support.js"

export default {
  name: "haiti_kimeru_modal",
  mixins: [
    support,
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
.haiti_kimeru_modal
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
