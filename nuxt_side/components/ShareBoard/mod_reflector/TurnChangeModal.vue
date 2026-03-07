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
    b-button.turn_change_modal_close_handle.has-text-weight-normal(@click="SB.turn_change_modal_close_handle" icon-left="chevron-left")
    b-button.turn_change_call_handle(@click="SB.turn_change_call_handle(new_turn)" type="is-primary") {{timeline_resolver.will_message}}
</template>

<script>
import { support_child } from "../support_child.js"
import { TimelineResolver } from "./timeline_resolver.js"

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
  computed: {
    timeline_resolver() { return this.SB.timeline_resolver_create({new_sfen: this.sfen, to: this.new_turn}) },
  },
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.TurnChangeModal
  +modal_width(512px)
  .modal-card-body
    padding: 1.25rem
    .message_body
      margin-top: 0.75rem
      font-size: $size-7

.STAGE-development
  .TurnChangeModal
    .sp_container
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .modal-card-body
      border: 1px dashed change_color($info, $alpha: 0.5)
</style>
