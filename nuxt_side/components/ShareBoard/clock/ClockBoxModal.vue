<template lang="pug">
.modal-card
  ////////////////////////////////////////////////////////////////////////////////
  .modal-card-head
    .modal-card-title
      | 対局時計

      span.mx-1.has-text-grey.has-text-weight-normal(v-if="instance")
        | {{instance.human_status}}

    // footer の close_handle は位置がずれて Capybara (spec/system/share_board_spec.rb) で押せないため上にもう1つ設置
    a.mx-2.close_handle_for_capybara.delete(@click="close_handle" v-if="development_p")

    template(v-if="!instance || !instance.pause_or_play_p")
      b-switch.main_switch(size="is-small" type="is-primary" v-model="clock_box_p" @input="main_switch_handle") 設置

  ////////////////////////////////////////////////////////////////////////////////
  .modal-card-body(@click="!instance && main_switch_handle(true)")
    //- pre
    //-   | {{TheSb.cc_params}}

    template(v-if="!instance")
      .has-text-centered.has-text-grey.my-6
        | 右上のスイッチで設置しよう
    template(v-if="instance")
      template(v-if="instance.pause_or_play_p")
        .level.is-mobile
          template(v-for="(e, i) in instance.single_clocks")
            .level-item.has-text-centered.has-text-weight-bold.is-flex-direction-column
              // ↓縦並び
              .is-size-2 {{e.location.name}}
              // →横並び
              .is-family-monospace
                span.mx-1.is-size-4(v-if="e.initial_main_sec >= 1 || e.every_plus >= 1") {{e.to_time_format}}
                span.mx-1.is-size-4(v-if="e.initial_read_sec >= 1") {{e.read_sec}}
                span.mx-1.is-size-4(v-if="e.initial_extra_sec >= 1") {{e.extra_sec}}
              // ↓縦並び
              .active_bar(:class="[instance.timer_to_css_class, {is_active: e.active_p}]")

      .forms_block(v-if="!instance.pause_or_play_p")
        template(v-for="(e, i) in TheSb.cc_params")
          .cc_form_block
            .location_mark(v-if="TheSb.cc_unique_p")
              | {{Location.fetch(i).name}}
            b-field(horizontal label="持ち時間(分)" custom-class="is-small")
              b-numberinput.initial_main_min(expanded controls-position="compact"  v-model="e.initial_main_min"  :min="0" :max="60*6"  :exponential="true")
            b-field(horizontal label="秒読み" custom-class="is-small")
              b-numberinput.initial_read_sec(expanded controls-position="compact"  v-model="e.initial_read_sec"  :min="0" :max="60*60" :exponential="true")
            b-field(horizontal label="猶予(秒)" custom-class="is-small")
              b-numberinput.initial_extra_sec(expanded controls-position="compact" v-model="e.initial_extra_sec" :min="0" :max="60*60" :exponential="true")
            b-field(horizontal label="1手毎加算(秒)" custom-class="is-small")
              b-numberinput.every_plus(expanded controls-position="compact"        v-model="e.every_plus"        :min="0" :max="60*60" :exponential="true")

        b-switch.cc_unique_mode_set_handle.mt-5(:value="TheSb.cc_unique_p" @input="cc_unique_mode_set_handle" size="is-small") 個別設定

  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left") 閉じる
    template(v-if="instance")
      b-dropdown.mx-2.preset_dropdown(position="is-top-right" @active-change="e => TheSb.cc_dropdown_active_change(e)" v-if="!instance.pause_or_play_p && TheSb.AppConfig.CLOCK_PRESET_USE")
        b-button.preset_dropdown_button(slot="trigger" icon-left="menu-up")
        template(v-for="e in TheSb.CcRuleInfo.values")
          b-dropdown-item(@click="cc_params_set_handle(e)") {{e.name}}
      .buttons
        template(v-if="instance.pause_or_play_p && !instance.timer")
          b-button.stop_button(@click="stop_handle" icon-left="stop")
        template(v-if="instance.pause_or_play_p && instance.timer")
          b-button.pause_button(@click="pause_handle" icon-left="pause" type="is-primary")
        template(v-if="instance.pause_or_play_p && !instance.timer")
          b-button.resume_button(@click="resume_handle" icon-left="play-pause")
        template(v-if="!instance.pause_or_play_p")
          b-button.play_button(@click="play_handle" icon-left="play")
</template>

<script>
import { support_child } from "../support_child.js"
import { Location } from "shogi-player/components/models/location.js"
import _ from "lodash"

export default {
  name: "ClockBoxModal",
  mixins: [support_child],
  inject: ["TheSb"],
  methods: {
    main_switch_handle(v) {
      this.$sound.play_toggle(v)
      this.TheSb.cc_main_switch_set(v)
    },
    close_handle() {
      this.$sound.play_click()
      this.$emit("close")
    },
    play_handle() {
      if (this.TheSb.clock_start_even_though_order_is_not_enabled_p) {
        this.TheSb.cc_play_confirm({
          onConfirm: () => {
            this.play_core_handle()
          },
        })
        return
      }
      this.play_core_handle()
    },
    play_core_handle() {
      this.__assert__(!this.clock_box)
      this.$sound.play_click()
      this.TheSb.cc_params_apply()
      this.TheSb.cc_play_handle()
      this.TheSb.clock_box_share("ck_start")
      if (this.TheSb.auto_close_p) {
        this.$emit("close")
      }
    },
    pause_handle() {
      this.$sound.play_click()
      this.TheSb.cc_pause_handle()
      this.TheSb.clock_box_share("ck_pause")
      if (this.TheSb.ac_room && this.TheSb.order_enable_p) {
        this.delay_block(2.5, () => this.toast_ok("続けて検討する場合は順番設定を無効にしてください。誰でも駒を動かせるようになります", {duration: 1000 * 10}))
      }
    },
    stop_handle() {
      this.$sound.play_click()
      if (this.instance.pause_or_play_p) {
        this.TheSb.cc_stop_handle()
        this.TheSb.clock_box_share("ck_stop")
      } else {
        this.toast_ok("すでに停止しています")
      }
    },
    resume_handle() {
      this.$sound.play_click()
      this.TheSb.cc_resume_handle()
      this.TheSb.clock_box_share("ck_resume")
      if (this.TheSb.auto_close_p) {
        this.$emit("close")
      }
    },
    save_handle() {
      this.$sound.play_click()
      this.TheSb.cc_params_apply()
      this.toast_ok("反映しました")
    },
    cc_params_set_handle(e) {
      this.TheSb.cc_params = e.cc_params   // cloneDeep したものを渡している
      if (false) {
        this.toast_ok(`${e.name}のプリセットを読み込みました`)
      } else {
        this.toast_ok(`読み込みました`, {talk: false})
      }
    },
    cc_unique_mode_set_handle(value) {
      this.$sound.play_toggle(value)
      this.TheSb.cc_unique_mode_set(value)
    },
  },
  computed: {
    Location() { return Location },
    instance() { return this.TheSb.clock_box },
    clock_box_p: {
      get()  { return !!this.instance },
      set(v) {},
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"

.STAGE-development
  .ClockBoxModal
    .modal-card-body, .field, .location_mark
      border: 1px dashed change_color($primary, $alpha: 0.5)

.ClockBoxModal
  +modal_width(24rem)

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

  .forms_block
    .cc_form_block:not(:first-child)
      .location_mark
        margin-top: 1.5rem

    +tablet
      .cc_form_block
        .field
          align-items: center
          .field-label.is-small
            padding-top: 0
            margin-right: 1rem
            .label
              white-space: nowrap
              width: 6rem
</style>
