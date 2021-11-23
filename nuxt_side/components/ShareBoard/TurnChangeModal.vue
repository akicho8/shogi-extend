<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 局面 \#{{new_turn_offset}}
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
        :sp_turn="turn_offset"
        :sp_body="sfen"
        @update:turn_offset="v => new_turn_offset = v"
      )

  .modal-card-foot
    b-button.close_handle(@click="close_handle" icon-left="chevron-left") キャンセル
    b-button.apply_button(@click="apply_handle" type="is-primary") この局面まで戻る
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "TurnChangeModal",
  mixins: [
    support_child,
  ],
  props: {
    sfen:        { type: String, required: true, },
    turn_offset: { type: Number, required: true, },
  },
  data() {
    return {
      new_turn_offset: this.turn_offset,
    }
  },
  methods: {
    close_handle() {
      this.sound_play_click()
      this.$emit("close")
    },
    apply_handle() {
      this.sound_play_click()
      this.base.new_turn_set_and_sync({sfen: this.sfen, turn_offset: this.new_turn_offset})
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
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
