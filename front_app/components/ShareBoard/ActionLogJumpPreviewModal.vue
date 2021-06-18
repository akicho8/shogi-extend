<template lang="pug">
.modal-card.ActionLogJumpPreviewModal
  ////////////////////////////////////////////////////////////////////////////////
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-5.has-text-weight-bold
      | 局面 \#{{new_turn_offset}}

  ////////////////////////////////////////////////////////////////////////////////
  section.modal-card-body
    .sp_container
      CustomShogiPlayer(
        sp_summary="is_summary_off"
        sp_run_mode="view_mode"
        sp_mobile_vertical="is_mobile_vertical_off"
        sp_layout="is_horizontal"
        sp_slider="is_slider_on"
        sp_controller="is_controller_on"
        :sp_viewpoint="base.sp_viewpoint"
        :sp_sound_enabled="true"
        :sp_turn="action_log.turn_offset"
        :sp_body="action_log.sfen"
        @update:turn_offset="v => new_turn_offset = v"
      )

  footer.modal-card-foot
    b-button.close_button(@click="close_handle" icon-left="chevron-left") キャンセル
    b-button.apply_button(@click="apply_handle" type="is-primary") この局面に移動する
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "ActionLogJumpPreviewModal",
  mixins: [
    support_child,
  ],
  props: {
    action_log: { type: Object, required: true, },
  },
  data() {
    return {
      new_turn_offset: this.action_log.turn_offset,
    }
  },
  mounted() {
    this.__assert__('sfen' in this.action_log, "'sfen' in this.action_log")
    this.__assert__('turn_offset' in this.action_log, "'turn_offset' in this.action_log")
  },
  methods: {
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
    apply_handle() {
      this.sound_play("click")
      this.base.action_log_jump({...this.action_log, turn_offset: this.new_turn_offset})
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.ActionLogJumpPreviewModal
  +tablet
    width: 32rem
  .modal-card-body
    padding: 1.25rem
  .modal-card-foot
    justify-content: space-between
    .button
      min-width: 6rem
      font-weight: bold

.STAGE-development
  .ActionLogJumpPreviewModal
    .sp_container
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .modal-card-body
      border: 1px dashed change_color($info, $alpha: 0.5)
</style>
