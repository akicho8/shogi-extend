<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 局面 \#{{new_turn}}
  .modal-card-body
    .sp_container
      CustomShogiPlayer(
        sp_mode="view"
        :sp_mobile_vertical="false"
        sp_layout="horizontal"
        sp_slider
        sp_controller
        :sp_view_mode_piece_movable="false"
        :sp_viewpoint="SB.viewpoint"
        :sp_body="sfen"
        :sp_turn="turn"
        @ev_turn_offset_change="v => new_turn = v"
      )

  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left")
    b-button.apply_button(@click="apply_handle" type="is-primary") {{new_turn}}手目まで戻る
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "TurnChangeModal",
  mixins: [support_child],
  props: {
    sfen: { type: String, required: true, },
    turn: { type: Number, required: true, },
  },
  data() {
    return {
      new_turn: this.turn,
    }
  },
  methods: {
    close_handle() {
      this.$sound.play_click()
      this.$emit("close")
    },
    apply_handle() {
      this.$sound.play_click()
      this.SB.new_turn_set_and_sync({sfen: this.sfen, turn: this.new_turn})
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
@import "./sass/support.sass"
.TurnChangeModal
  +modal_width(512px)
  .modal-card-body
    padding: 1.25rem

.STAGE-development
  .TurnChangeModal
    .sp_container
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .modal-card-body
      border: 1px dashed change_color($info, $alpha: 0.5)
</style>
