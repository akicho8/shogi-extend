<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | {{xhistory_record.modal_title_or_default}} \#{{new_turn}}
  .modal-card-body
    //- pre
    //-   | turn_progress.old_sfen={{turn_progress.old_sfen}}
    //-   | turn_progress.new_sfen={{turn_progress.new_sfen}}
    //-   | turn_progress.to_sfen_and_turn={{turn_progress.to_sfen_and_turn}}
    .sp_container
      CustomShogiPlayer(
        sp_mode="view"
        :sp_mobile_vertical="false"
        sp_layout="horizontal"
        sp_slider
        sp_controller
        :sp_view_mode_piece_movable="false"
        :sp_viewpoint.sync="viewpoint"
        :sp_turn="xhistory_record.turn"
        :sp_body="turn_progress.to_sfen_and_turn.sfen"
        @ev_turn_offset_change="v => new_turn = v"
      )
    .buttons.mb-0.is-centered.are-small.is-marginless.mt-4
      PiyoShogiButton(:href="current_kifu_vo.piyo_url" @click="SB.other_app_click_handle('ぴよ将棋')")
      KentoButton(tag="a" :href="current_kifu_vo.kento_url" target="_blank" @click="SB.other_app_click_handle('KENTO')")
      KifCopyButton(@click="kifu_copy_handle") コピー

    .buttons.mb-0.is-centered.are-small.is-marginless.mt-3
      b-button.kifu_download_handle(tag="a" :href="kifu_download_url(current_format_type_info)" @click.prevent="kifu_download_handle(current_format_type_info)") 棋譜ダウンロード

    .buttons.mb-0.is-centered.are-small.is-marginless.mt-3(v-if="SB.debug_mode_p")
      b-button.current_url_copy_handle( tag="a" :href="current_url"                             @click.prevent="current_url_copy_handle") 棋譜再生用リンク
      b-button.kifu_show_handle(        tag="a" :href="kifu_show_url(current_format_type_info)" @click.prevent="kifu_show_handle(current_format_type_info)") 棋譜表示
      b-button(tag="a" :href="current_url"      target="_blank") 別タブで開く
      b-button(tag="a" :href="json_debug_url"   target="_blank") json
      b-button(tag="a" :href="twitter_card_url" target="_blank") png

    pre.mt-4(v-if="SB.debug_mode_p") {{$GX.pretty_inspect(xhistory_record)}}

  .modal-card-foot
    b-button.time_machine_modal_close_handle.has-text-weight-normal(@click="SB.time_machine_modal_close_handle" icon-left="chevron-left")
    b-button.time_machine_modal_apply_handle(@click="time_machine_modal_apply_handle" type="is-primary") {{turn_progress.will_message}}
</template>

<script>
import { support_child } from "../support_child.js"
import { time_machine_url_support } from "./time_machine_url_support.js"
import { GX } from "@/components/models/gx.js"
import { TurnProgress } from "../mod_reflector/turn_progress.js"

export default {
  name: "TimeMachineModal",
  mixins: [
    support_child,
    time_machine_url_support,
  ],
  props: {
    xhistory_record: { type: Object, required: true, },
  },
  data() {
    return {
      new_turn: this.xhistory_record.turn,
      viewpoint: this.xhistory_record.viewpoint,
    }
  },
  mounted() {
    GX.assert(this.viewpoint === "white" || this.viewpoint === "black")
    GX.assert('sfen' in this.xhistory_record, "'sfen' in this.xhistory_record")
    GX.assert('turn' in this.xhistory_record, "'turn' in this.xhistory_record")
  },
  methods: {
    time_machine_modal_apply_handle() {
      this.SB.time_machine_modal_apply_handle({...this.xhistory_record, turn: this.new_turn})
    },
  },
  computed: {
    current_format_type_info() {
      return this.SB.FormatTypeInfo.fetch("kif_utf8")
    },
    turn_progress() { return this.SB.turn_progress_create({new_sfen: this.xhistory_record.sfen, to: this.new_turn}) },
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
