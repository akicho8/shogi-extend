<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | {{xhistory_record.modal_title_or_default}}
    .master_turn(v-if="SB.debug_mode_p")
      | \#{{master.turn}}
  .modal-card-body
    .sp_container
      CustomShogiPlayer(
        sp_mode="view"
        :sp_mobile_vertical="false"
        sp_layout="horizontal"
        :sp_slider="sp_operation"
        :sp_controller="sp_operation"
        :sp_view_mode_piece_movable="false"
        :sp_viewpoint="xhistory_record.viewpoint"
        :sp_turn="xhistory_record.turn"
        :sp_body="timeline_resolver.to_sfen_and_turn.sfen"
        @ev_turn_offset_change="v => mut_turn = v"
      )

    pre.mt-4(v-if="SB.debug_mode_p") {{timeline_resolver.to_debug_h}}
    pre.mt-4(v-if="SB.debug_mode_p") {{$GX.pretty_inspect(xhistory_record)}}

  .modal-card-foot
    b-button.time_machine_modal_close_handle.has-text-weight-normal(@click="SB.time_machine_modal_close_handle" icon-left="chevron-left")
    b-button.time_machine_modal_apply_handle(@click="time_machine_modal_apply_handle" type="is-primary") {{timeline_resolver.will_message}}
</template>

<script>
import { support_child } from "../support_child.js"
import { GX } from "@/components/models/gx.js"
// import { TimelineResolver } from "../mod_reflector/timeline_resolver.js"

export default {
  name: "TimeMachineModal",
  mixins: [support_child],
  props: {
    xhistory_record: { type: Object, required: true, },
    timeline_resolver_params: { type: Object, required: true, },
    sp_operation: { type: Boolean, default: true, },
  },
  data() {
    return {
      mut_turn: this.xhistory_record.turn,
    }
  },
  mounted() {
    GX.assert('sfen' in this.xhistory_record, "'sfen' in this.xhistory_record")
    GX.assert('turn' in this.xhistory_record, "'turn' in this.xhistory_record")
  },
  methods: {
    time_machine_modal_apply_handle() {
      this.SB.time_machine_modal_apply_handle({...this.timeline_resolver.to_reflector_call_params, general_mark_clear_all: true})
    },
  },
  computed: {
    current_format_type_info() { return this.SB.FormatTypeInfo.fetch("kif_utf8") },

    timeline_resolver() {
      return this.SB.timeline_resolver_create({
        ...this.timeline_resolver_params,
        new_sfen: this.xhistory_record.sfen,
        to: this.mut_turn,
      })
    },

    master() {
      return this.timeline_resolver.to_sfen_and_turn
    },
  },
}
</script>

<style lang="sass">
@import "../stylesheets/support"
.TimeMachineModal
  +modal_width(512px)

  .modal-card-head
    justify-content: space-between

  .modal-card-body
    padding: 1.25rem

.STAGE-development
  .TimeMachineModal
    .sp_container
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .modal-card-body
      border: 1px dashed change_color($info, $alpha: 0.5)
</style>
