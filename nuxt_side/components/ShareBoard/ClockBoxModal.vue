<template lang="pug">
.modal-card
  ////////////////////////////////////////////////////////////////////////////////
  .modal-card-head
    .modal-card-title
      | 対局時計
      span.mx-1.has-text-grey(v-if="instance") {{instance.human_status}}

    // footer の close_handle は位置がずれて Capybara (spec/system/share_board_spec.rb) で押せないため上にもう1つ設置
    a.mx-2.close_handle_for_capybara.delete(@click="close_handle" v-if="development_p")

    template(v-if="!instance || !instance.running_p")
      b-switch.main_switch(size="is-small" type="is-primary" v-model="clock_box_p" @input="main_switch_handle") 設置

  ////////////////////////////////////////////////////////////////////////////////
  .modal-card-body
    template(v-if="!instance")
      .has-text-centered.has-text-grey.my-6
        | 設置する場合は右上のスイッチを有効にしよう
    template(v-if="instance")
      template(v-if="instance.running_p")
        .level.is-mobile
          .level-item.has-text-centered(v-if="base.cc_params.initial_main_min >= 0")
            div
              p.heading 持ち時間
              p.title.is-5 {{base.cc_params.initial_main_min}}分
          .level-item.has-text-centered(v-if="base.cc_params.initial_read_sec >= 1")
            div
              p.heading 秒読み
              p.title.is-5 {{base.cc_params.initial_read_sec}}秒
          .level-item.has-text-centered(v-if="base.cc_params.initial_extra_sec >= 1")
            div
              p.heading 猶予
              p.title.is-5 {{base.cc_params.initial_extra_sec}}秒
          .level-item.has-text-centered(v-if="base.cc_params.every_plus >= 1")
            div
              p.heading 1手毎加算
              p.title.is-5 {{base.cc_params.every_plus}}秒
        hr
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
      .fields_container(v-if="!instance.running_p")
        b-field(horizontal label="持ち時間(分)" custom-class="is-small")
          b-numberinput.initial_main_min(expanded controls-position="compact" v-model="base.cc_params.initial_main_min"  :min="0" :max="60*6" :exponential="true")
        b-field(horizontal label="秒読み" custom-class="is-small")
          b-numberinput.initial_read_sec(expanded controls-position="compact" v-model="base.cc_params.initial_read_sec"  :min="0" :max="60*60" :exponential="true")
        b-field(horizontal label="猶予(秒)" custom-class="is-small")
          b-numberinput.initial_extra_sec(expanded controls-position="compact" v-model="base.cc_params.initial_extra_sec" :min="0" :max="60*60" :exponential="true")
        b-field(horizontal label="1手毎加算(秒)" custom-class="is-small")
          b-numberinput.every_plus(expanded controls-position="compact" v-model="base.cc_params.every_plus"        :min="0" :max="60*60" :exponential="true")
  .modal-card-foot
    b-button.close_handle.mx-0(@click="close_handle" icon-left="chevron-left") 閉じる
    template(v-if="instance")
      b-dropdown.mx-2(position="is-top-right" @active-change="e => base.cc_dropdown_active_change(e)" v-if="!instance.running_p")
        b-button(slot="trigger" icon-left="menu-up") プリセット
        template(v-for="e in base.CcRuleInfo.values")
          b-dropdown-item(@click="cc_params_set_handle(e)") {{e.name}}
      .buttons
        b-button.stop_button(@click="stop_handle" icon-left="stop" v-if="instance.running_p && !instance.timer")
        template(v-if="instance.running_p && instance.timer")
          b-button.pause_button(@click="pause_handle" icon-left="pause" type="is-primary")
        template(v-if="instance.running_p && !instance.timer")
          b-button.resume_button(@click="resume_handle" icon-left="play-pause")
        template(v-if="!instance.running_p")
          b-button.play_button(@click="play_handle" icon-left="play")
</template>

<script>
import { support_child } from "./support_child.js"
const AUTO_CLOSE_IF_START_RESUME = false // START と RESUME 実行後にモーダルを閉じるか？

export default {
  name: "ClockBoxModal",
  mixins: [
    support_child,
  ],
  methods: {
    main_switch_handle(v) {
      this.sound_play("click")
      if (v) {
        this.base.cc_create()
        this.base.cc_params_apply() // すぐにパラメータを反映する
        this.base.clock_box_share("設置")
      } else {
        this.base.cc_destroy()
        this.base.clock_box_share("破棄")
      }
    },
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
    play_handle() {
      this.__assert__(!this.instance.running_p)
      this.sound_play("click")
      this.base.cc_params_apply()
      this.base.cc_play_handle()
      this.base.clock_box_share("開始")
      if (AUTO_CLOSE_IF_START_RESUME) {
        this.$emit("close")
      }
    },
    stop_handle() {
      this.sound_play("click")
      if (this.instance.running_p) {
        this.base.cc_stop_handle()
        this.base.clock_box_share("停止")
      } else {
        this.toast_ok("すでにリセットしています")
      }
    },
    pause_handle() {
      this.sound_play("click")
      this.base.cc_pause_handle()
      this.base.clock_box_share("一時停止")
    },
    resume_handle() {
      this.sound_play("click")
      this.base.cc_resume_handle()
      this.base.clock_box_share("再開")
      if (AUTO_CLOSE_IF_START_RESUME) {
        this.$emit("close")
      }
    },
    save_handle() {
      this.sound_play("click")
      this.base.cc_params_apply()
      this.toast_ok("反映しました")
    },
    cc_params_set_handle(e) {
      this.base.cc_params = {...e.cc_params}
      if (false) {
        this.toast_ok(`${e.name}のプリセットを読み込みました`)
      } else {
        this.toast_ok(`読み込みました`, {toast_only: true})
      }
    },
  },
  computed: {
    instance() { return this.base.clock_box },
    clock_box_p: {
      get()  { return !!this.instance },
      set(v) {},
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"

.STAGE-development
  .ClockBoxModal
    .modal-card-body, .field
      border: 1px dashed change_color($primary, $alpha: 0.5)

.ClockBoxModal
  +modal_width(32rem)

  .modal-card-body
    padding: 2rem

  .field:not(:last-child)
    margin-bottom: 1.1rem

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

  // b-sidebar の左の文言のY軸を中央にする
  .fields_container
    +tablet
      .field
        align-items: center
        .field-label.is-small
          padding-top: 0
          margin-right: 1rem
          .label
            white-space: nowrap
            width: 6rem
</style>
