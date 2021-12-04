<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 局面 \#{{new_turn}}
  .modal-card-body
    .sp_container
      CustomShogiPlayer(
        sp_summary="is_summary_off"
        sp_run_mode="view_mode"
        sp_mobile_vertical="is_mobile_vertical_off"
        sp_layout="is_horizontal"
        sp_slider="is_slider_on"
        sp_controller="is_controller_on"
        :sp_view_mode_soldier_movable="false"
        :sp_viewpoint="base.sp_viewpoint"
        :sp_sound_enabled="true"
        :sp_turn="action_log.turn"
        :sp_body="action_log.sfen"
        @update:turn="v => new_turn = v"
      )
    .buttons.mb-0.is-centered.are-small.is-marginless.mt-4
      PiyoShogiButton(:href="piyo_shogi_app_with_params_url" @click="base.other_app_click_handle('ぴよ将棋')")
      KentoButton(tag="a" :href="kento_app_with_params_url" target="_blank" @click="base.other_app_click_handle('KENTO')")
      KifCopyButton(@click="kifu_copy_handle('kif')") コピー
      b-button.room_code_except_url_copy_handle(@click="room_code_except_url_copy_handle" icon-left="link") リンク

  .modal-card-foot
    b-button.close_handle(@click="close_handle" icon-left="chevron-left") キャンセル
    b-button.apply_button(@click="apply_handle" type="is-primary") この局面まで戻る
</template>

<script>
import { support_child } from "./support_child.js"
import { HistoryJumpPreviewModalButtons } from "./HistoryJumpPreviewModalButtons.js"

export default {
  name: "HistoryJumpPreviewModal",
  mixins: [
    support_child,
    HistoryJumpPreviewModalButtons,
  ],
  props: {
    action_log: { type: Object, required: true, },
  },
  data() {
    return {
      new_turn: this.action_log.turn,
    }
  },
  mounted() {
    this.__assert__('sfen' in this.action_log, "'sfen' in this.action_log")
    this.__assert__('turn' in this.action_log, "'turn' in this.action_log")
  },
  methods: {
    close_handle() {
      this.sound_play_click()
      this.$emit("close")
    },
    apply_handle() {
      this.sound_play_click()
      this.base.action_log_jump({...this.action_log, turn: this.new_turn})
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.HistoryJumpPreviewModal
  +modal_width(512px)

  .modal-card-body
    padding: 1.25rem
    .buttons > *
      margin-bottom: 0

.STAGE-development
  .HistoryJumpPreviewModal
    .sp_container
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .modal-card-body
      border: 1px dashed change_color($info, $alpha: 0.5)
</style>
