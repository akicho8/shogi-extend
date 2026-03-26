<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | {{xhistory_record.modal_title_or_default}} \#{{master.turn}}
  .modal-card-body
    .sp_container
      CustomShogiPlayer(
        sp_mode="view"
        :sp_mobile_vertical="false"
        sp_layout="horizontal"
        :sp_slider="sp_operation"
        :sp_controller="sp_operation"
        :sp_view_mode_piece_movable="false"
        :sp_viewpoint.sync="mut_viewpoint"
        :sp_turn="xhistory_record.turn"
        :sp_body="timeline_resolver.to_sfen_and_turn.sfen"
        @ev_turn_offset_change="v => mut_turn = v"
      )
    .buttons.mb-0.is-centered.are-small.is-marginless.mt-4
      PiyoShogiButton(:href="current_kifu_vo.piyo_url" @click="SB.other_app_click_handle('ぴよ将棋')")
      KentoButton(tag="a" :href="current_kifu_vo.kento_url" target="_blank" @click="SB.other_app_click_handle('KENTO')")
      KifCopyButton(@click="kifu_copy_handle") コピー

    .buttons.mb-0.is-centered.are-small.is-marginless.mt-3
      b-button.kifu_download_handle(tag="a" :href="kifu_download_url(current_format_type_info)" @click.prevent="kifu_download_handle(current_format_type_info)") 棋譜ダウンロード

    .buttons.mb-0.is-centered.are-small.is-marginless.mt-3(v-if="SB.debug_mode_p")
      b-button.current_long_url_copy_handle( tag="a" :href="current_url"                             @click.prevent="current_long_url_copy_handle") 棋譜再生用URL
      b-button.kifu_show_handle(        tag="a" :href="kifu_show_url(current_format_type_info)" @click.prevent="kifu_show_handle(current_format_type_info)") 棋譜表示
      b-button(tag="a" :href="current_url"      target="_blank") 別タブで開く
      b-button(tag="a" :href="json_debug_url"   target="_blank") json
      b-button(tag="a" :href="twitter_card_url" target="_blank") png

    pre.mt-4(v-if="SB.debug_mode_p") {{timeline_resolver.to_debug_h}}
    pre.mt-4(v-if="SB.debug_mode_p") {{$GX.pretty_inspect(xhistory_record)}}

  .modal-card-foot
    b-button.time_machine_modal_close_handle.has-text-weight-normal(@click="SB.time_machine_modal_close_handle" icon-left="chevron-left")
    b-button.time_machine_modal_apply_handle(@click="time_machine_modal_apply_handle" type="is-primary") {{timeline_resolver.will_message}}
</template>

<script>
import { support_child } from "../support_child.js"
import { time_machine_url_support } from "./time_machine_url_support.js"
import { GX } from "@/components/models/gx.js"
// import { TimelineResolver } from "../mod_reflector/timeline_resolver.js"

export default {
  name: "TimeMachineModal",
  mixins: [
    support_child,
    time_machine_url_support,
  ],
  props: {
    xhistory_record: { type: Object, required: true, },
    timeline_resolver_params: { type: Object, required: true, },
    sp_operation: { type: Boolean, default: true, },
  },
  data() {
    return {
      mut_turn: this.xhistory_record.turn,
      mut_viewpoint: this.xhistory_record.viewpoint,
    }
  },
  mounted() {
    GX.assert(this.mut_viewpoint === "white" || this.mut_viewpoint === "black")
    GX.assert('sfen' in this.xhistory_record, "'sfen' in this.xhistory_record")
    GX.assert('turn' in this.xhistory_record, "'turn' in this.xhistory_record")
  },
  methods: {
    time_machine_modal_apply_handle() {
      this.SB.time_machine_modal_apply_handle({...this.timeline_resolver.to_reflector_call_params, think_mark_clear_all: true})
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
@import "../sass/support.sass"
.TimeMachineModal
  +modal_width(512px)

  .modal-card-body
    padding: 1.25rem
    .buttons > *
      margin-bottom: 0

.STAGE-development
  .TimeMachineModal
    .sp_container
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .modal-card-body
      border: 1px dashed change_color($info, $alpha: 0.5)
</style>
