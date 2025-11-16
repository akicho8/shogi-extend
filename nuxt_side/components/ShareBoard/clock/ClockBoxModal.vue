<template lang="pug">
.modal-card
  ////////////////////////////////////////////////////////////////////////////////
  .modal-card-head
    .modal-card-title
      | 対局時計
      span.has-text-grey.has-text-weight-normal.mx-1(v-if="SB.clock_box")
        span.clock_box_human_status.mx-1
          | {{SB.clock_box.human_status}}
        span.clock_box_pause_sec_human.is-family-monospace.mx-1
          | {{SB.clock_box.pause_sec_human}}

    // footer の close_handle は位置がずれて Capybara (spec/system/share_board_spec.rb) で押せないため上にもう1つ設置
    a.close_handle_for_capybara.delete(@click="SB.cc_modal_close_handle" v-if="development_p")

    template(v-if="SB.clock_box && !SB.clock_box.pause_or_play_p")
      b-switch.cbm_cc_unique_mode_sete_handle(:value="SB.cc_unique_p" @input="SB.cbm_cc_unique_mode_sete_handle" size="is-small") 個別

    template(v-if="!SB.clock_box || !SB.clock_box.pause_or_play_p")
      b-switch.main_switch(size="is-small" type="is-primary" v-model="clock_box_p" @input="SB.cbm_main_switch_handle") 設置

  ////////////////////////////////////////////////////////////////////////////////
  .modal-card-body(@click="!SB.clock_box && SB.cbm_main_switch_handle(true)")
    //- pre
    //-   | {{SB.cc_params}}

    template(v-if="!SB.clock_box")
      .has-text-centered.has-text-grey.my-6
        | 右上のスイッチで設置しよう
    template(v-if="SB.clock_box")
      template(v-if="SB.clock_box.pause_or_play_p")
        .level.is-mobile
          template(v-for="(e, i) in SB.clock_box.single_clocks")
            .level-item.has-text-centered.has-text-weight-bold.is-flex-direction-column
              // ↓縦並び
              .is-size-2 {{e.location.name}}
              // →横並び
              .is-family-monospace
                span.mx-1.is-size-4(v-if="e.initial_main_sec >= 1 || e.every_plus >= 1") {{e.main_sec_mmss}}
                span.mx-1.is-size-4(v-if="e.initial_read_sec >= 1") {{e.read_sec}}
                span.mx-1.is-size-4(v-if="e.initial_extra_sec >= 1") {{e.extra_sec}}
              // ↓縦並び
              .active_bar(:class="[SB.clock_box.timer_to_css_class, {is_active: e.active_p}]")

      .forms_block(v-if="!SB.clock_box.pause_or_play_p")
        ClockBoxForm

        template(v-if="SB.cc_soft_validator_info")
          .cc_soft_validator_container.mt-4.is-unselectable.is_line_break_on
            b-icon.mx-1(:icon="SB.cc_soft_validator_info.icon_code" :type="SB.cc_soft_validator_info.icon_type")
            span(v-html="SB.cc_soft_validator_info.message")

        pre.is-size-7(v-if="SB.debug_mode_p") {{SB.cc_params}}

  .modal-card-foot
    b-button.cc_modal_close_handle.has-text-weight-normal(@click="SB.cc_modal_close_handle" icon-left="chevron-left")
    template(v-if="SB.clock_box")
      b-dropdown.mx-2.preset_dropdown(position="is-top-right" @active-change="e => SB.cc_dropdown_active_change(e)" v-if="!SB.clock_box.pause_or_play_p && SB.AppConfig.CLOCK_PRESET_USE")
        b-button.preset_dropdown_button(slot="trigger" icon-left="menu-up")
        template(v-for="e in SB.CcRuleInfo.values")
          b-dropdown-item(@click="SB.cbm_cc_params_set_handle(e)") {{e.name}}
      .buttons
        template(v-if="SB.clock_box.stop_p")
          b-button.play_button(@click="SB.cbm_play_handle" icon-left="play" type="is-primary") 対局開始
        template(v-if="SB.clock_box.play_p")
          b-button.pause_button(@click="SB.cbm_pause_handle" icon-left="pause" type="is-primary")
        template(v-if="SB.clock_box.pause_p")
          b-button.stop_button(@click="SB.cbm_stop_handle" icon-left="stop")
          b-button.resume_button(@click="SB.cbm_resume_handle" icon-left="play-pause" type="is-primary")
</template>

<script>
import { support_child } from "../support_child.js"
import _ from "lodash"

export default {
  name: "ClockBoxModal",
  mixins: [support_child],
  computed: {
    clock_box_p: {
      get()  { return !!this.SB.clock_box },
      set(v) {},
    },
  },
}
</script>

<style lang="sass">
@import "../sass/support.sass"

.ClockBoxModal
  +modal_width(24rem)

  .modal-card-head
    gap: 0.5rem

  .modal-card-body
    padding: 1.5rem

  .modal-card-foot
    .button
      min-width: 6rem
      font-weight: bold
      &.preset_dropdown_button
        min-width: unset        // プリセット選択は常に目立たないようにする

  .field:not(:last-child)
    margin-bottom: 0.75rem

  .active_bar
    margin-top: 1rem
    height: 6px
    width: 100%
    border-radius: 4px
    &.is_active
      background-color: $primary
      &.is_pause_off
        animation: clock_box_modal_bar_blink 0.5s ease-in-out 0s infinite alternate
        @keyframes clock_box_modal_bar_blink
          0%
            opacity: 1.0
          100%
            opacity: 0.0

  .cc_soft_validator_container
    display: flex
    justify-content: center
    align-items: center

.STAGE-development
  .ClockBoxModal
    .modal-card-body, .field, .cc_soft_validator_container, .cc_soft_validator_info, .XemojiWrap
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
