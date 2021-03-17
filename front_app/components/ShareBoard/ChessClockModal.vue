<template lang="pug">
.modal-card.ChessClockModal
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-6
      span.has-text-weight-bold
        | 対局時計
      span.mx-1.has-text-grey.is-size-6(v-if="instance") {{instance.human_status}}
    template(v-if="!instance || !instance.running_p")
      b-switch(size="is-small" type="is-primary" v-model="chess_clock_p" @input="chess_clock_switch_handle") 設置
  section.modal-card-body
    template(v-if="!instance")
      .has-text-centered.has-text-grey.my-6
        | 使う場合は右上のスイッチを有効にしてください
    template(v-if="instance")
      template(v-if="instance.running_p")
        .level.is-mobile
          .level-item.has-text-centered(v-if="base.cc_params.initial_main_min >= 0")
            div
              p.heading 持ち時間
              p.title.is-4 {{base.cc_params.initial_main_min}}分
          .level-item.has-text-centered(v-if="base.cc_params.initial_read_sec >= 1")
            div
              p.heading 秒読み
              p.title.is-4 {{base.cc_params.initial_read_sec}}秒
          .level-item.has-text-centered(v-if="base.cc_params.initial_extra_sec >= 1")
            div
              p.heading 猶予
              p.title.is-4 {{base.cc_params.initial_extra_sec}}秒
          .level-item.has-text-centered(v-if="base.cc_params.every_plus >= 1")
            div
              p.heading 1手毎加算
              p.title.is-4 {{base.cc_params.every_plus}}秒
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
          b-numberinput(expanded controls-position="compact" v-model="base.cc_params.initial_main_min"  :min="0" :max="60*6" :exponential="true")
        b-field(horizontal label="秒読み" custom-class="is-small")
          b-numberinput(expanded controls-position="compact" v-model="base.cc_params.initial_read_sec"  :min="0" :max="60*60" :exponential="true")
        b-field(horizontal label="猶予(秒)" custom-class="is-small")
          b-numberinput(expanded controls-position="compact" v-model="base.cc_params.initial_extra_sec" :min="0" :max="60*60" :exponential="true")
        b-field(horizontal label="1手毎加算(秒)" custom-class="is-small")
          b-numberinput(expanded controls-position="compact" v-model="base.cc_params.every_plus"        :min="0" :max="60*60" :exponential="true")
  footer.modal-card-foot
    b-button(@click="close_handle" icon-left="chevron-left") 閉じる
    template(v-if="instance")
      b-dropdown(position="is-top-right" @active-change="e => base.cc_dropdown_active_change(e)" v-if="!instance.running_p")
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

export default {
  name: "ChessClockModalApp",
  mixins: [
    support_child,
  ],
  methods: {
    chess_clock_switch_handle(v) {
      this.sound_play("click")
      if (v) {
        this.base.cc_create()
        this.base.cc_params_apply() // すぐにパラメータを反映する
        this.base.chess_clock_share("設置しました")
      } else {
        this.base.cc_destroy()
        this.base.chess_clock_share("捨てました")
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
      this.base.chess_clock_share("開始しました")
    },
    stop_handle() {
      this.sound_play("click")
      if (this.instance.running_p) {
        this.base.cc_stop_handle()
        this.base.chess_clock_share("停止しました")
      } else {
        this.toast_ok("すでにリセットしています")
      }
    },
    pause_handle() {
      this.sound_play("click")
      this.base.cc_pause_handle()
      this.base.chess_clock_share("一時停止しました")
    },
    resume_handle() {
      this.sound_play("click")
      this.base.cc_resume_handle()
      this.base.chess_clock_share("再開しました")
    },
    save_handle() {
      this.sound_play("click")
      this.base.cc_params_apply()
      this.toast_ok("反映しました")
    },
    cc_params_set_handle(e) {
      this.base.cc_params = {...e.cc_params}
      this.toast_ok(`${e.name}のプリセットを読み込みました`)
    },
  },
  computed: {
    instance() { return this.base.chess_clock },
    chess_clock_p: {
      get()  { return !!this.instance },
      set(v) {},
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"

.STAGE-development
  .ChessClockModal
    .modal-card-body, .field
      border: 1px dashed change_color($primary, $alpha: 0.5)

.ChessClockModal
  .modal-card-body
    padding: 2.0rem 2.0rem
  .modal-card-foot
    justify-content: space-between
    .stop_button
    .pause_button, .resume_button, .play_button
      min-width: 6rem

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
        animation: chess_clock_modal_bar_blink 1s ease-in-out 0s infinite alternate
        @keyframes chess_clock_modal_bar_blink
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
</style>
