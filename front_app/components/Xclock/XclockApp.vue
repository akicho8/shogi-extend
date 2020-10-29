<template lang="pug">
.Xclock(:class="chess_clock.running_p ? 'is_xclock_active' : 'is_xclock_inactive'")
  DebugBox
    div turn: {{chess_clock.turn}}
    div running_p: {{chess_clock.running_p}}
    div timer: {{chess_clock.timer}}
    div counter: {{chess_clock.counter}}
    div zero_arrival: {{chess_clock.zero_arrival}}
    div mouse_cursor_p: {{mouse_cursor_p}}

  //////////////////////////////////////////////////////////////////////////////// form
  template(v-if="!chess_clock.running_p")
    .screen_container.is-flex
      .level.is-mobile.is-unselectable.is-marginless
        template(v-for="(e, i) in chess_clock.single_clocks")
          .level-item.has-text-centered.is-marginless(@pointerdown="switch_handle(e)" :class="e.dom_class")
            .active_current_bar(:class="e.bar_class" v-if="e.active_p")
            .inactive_current_bar(v-else)
            .wide_container.form.is-flex
              b-field(label="持ち時間(分)" custom-class="is-small")
                b-numberinput(size="is-small" controls-position="compact" v-model="e.main_minute_for_vmodel" :min="0" :max="60*9" :exponential="true" @pointerdown.native.stop="" :checkHtml5Validity="false")
              b-field(label="1手ごとに加算" custom-class="is-small")
                b-numberinput(size="is-small" controls-position="compact" v-model="e.every_plus" :min="0" :max="60*60" :exponential="true" @pointerdown.native.stop="")
              b-field(label="秒読み" custom-class="is-small")
                b-numberinput(size="is-small" controls-position="compact" v-model="e.initial_read_sec_for_v_model" :min="0" :max="60*60" :exponential="true" @pointerdown.native.stop="")
              b-field(label="猶予" custom-class="is-small")
                b-numberinput(size="is-small" controls-position="compact" v-model="e.initial_extra_sec" :min="0" :max="60*60" :exponential="true" @pointerdown.native.stop="")
      XclockAppFooter(:base="base" ref="XclockAppFooter")

  //////////////////////////////////////////////////////////////////////////////// 実行中
  template(v-if="chess_clock.running_p")
    .pause_bg(v-if="!chess_clock.timer")
    .screen_container.is-flex(:class="{mouse_cursor_hidden: mouse_cursor_hidden}")
      b-icon.controll_button.pause.is_clickable(icon="pause" v-if="chess_clock.timer" @click.native="pause_handle")
      b-icon.controll_button.resume.is_clickable(icon="play" v-if="!chess_clock.timer" @click.native="resume_handle")
      b-icon.controll_button.stop.is_clickable(icon="stop" v-if="!chess_clock.timer" @click.native="stop_handle")
      .level.is-mobile.is-unselectable.is-marginless
        template(v-for="(e, i) in chess_clock.single_clocks")
          .level-item.has-text-centered.is-marginless(@pointerdown="switch_handle(e)" :class="e.dom_class")
            .active_current_bar(:class="e.bar_class" v-if="e.active_p && chess_clock.timer")
            .inactive_current_bar(v-else)
            .wide_container.time_fields.is-flex(:class="[`display_lines-${e.display_lines}`, `text_width-${e.to_time_format.length}`]")
              .field(v-if="e.initial_main_sec >= 1 || e.every_plus >= 1")
                .time_label 残り時間
                .time_value.fixed_font.is_line_break_off
                  | {{e.to_time_format}}
              .field(v-if="e.initial_read_sec >= 1")
                .time_label 秒読み
                .time_value.fixed_font.is_line_break_off
                  | {{e.read_sec}}
              .field(v-if="e.initial_extra_sec >= 1")
                .time_label 猶予
                .time_value.fixed_font.is_line_break_off
                  | {{e.extra_sec}}

  //////////////////////////////////////////////////////////////////////////////// form
  .debug_container.mt-5(v-if="development_p")
    .buttons.are-small.is-centered
      b-button(@click="chess_clock.generation_next(-1)") -1
      b-button(@click="chess_clock.generation_next(-60)") -60
      b-button(@click="chess_clock.generation_next(1)") +1
      b-button(@click="chess_clock.generation_next(60)") +60
      b-button(@click="chess_clock.clock_switch()") 切り替え
      b-button(@click="chess_clock.timer_start()") START ({{chess_clock.running_p}})
      b-button(@click="chess_clock.timer_stop()") STOP
      b-button(@click="chess_clock.params.every_plus = 5") フィッシャールール
      b-button(@click="chess_clock.params.every_plus = 0") 通常ルール
      b-button(@click="chess_clock.reset()") RESET
      b-button(@click="chess_clock.main_sec_set(3)") 両方残り3秒
      input(type="range" v-model.number="chess_clock.speed")
      | スピード {{chess_clock.speed}}
    b-message
      p 1手毎に{{chess_clock.params.every_plus}}秒加算
      p mouse_cursor_p: {{mouse_cursor_p}}

</template>

<script>

import { ChessClock   } from "../Training/models/chess_clock.js"
import { DeviseAngle  } from "@/components/models/DeviseAngle.js"
import { isMobile     } from "@/components/models/isMobile.js"
import { FullScreen   } from "@/components/models/FullScreen.js"

import { support      } from "./support.js"

import { app_mouse_hidden         } from "./app_mouse_hidden.js"
import { app_keyboard_shortcut    } from "./app_keyboard_shortcut.js"
import { app_mobile_screen_adjust } from "./app_mobile_screen_adjust.js"

export default {
  name: "XclockApp",
  mixins: [
    support,
    app_mouse_hidden,
    app_keyboard_shortcut,
    app_mobile_screen_adjust,
  ],
  data() {
    return {
      chess_clock: null,
      full_screen: null,
    }
  },
  created() {
    this.chess_clock = new ChessClock({
      turn: 0,
      clock_switch_hook: () => {
        this.sound_play("click")
      },
      time_zero_callback: e => {
        this.sound_play("lose")
        this.say("時間切れ")
        this.$buefy.dialog.alert({
          message: "時間切れ",
          onConfirm: () => { this.stop_handle() },
        })
      },
      second_decriment_hook: (single_clock, key, t, m, s) => {
        if (1 <= m && m <= 10) {
          if (s === 0) {
            this.say(`${m}分`)
          }
        }
        if (t === 10 || t === 20 || t === 30) {
          this.say(`${t}秒`)
        }
        if (t <= 5) {
          this.say(`${t}`)
        }
        if (t <= 6 && false) {
          const index = single_clock.index
          setTimeout(() => {
            if (index === single_clock.base.current_index) {
              this.say(`${t - 1}`)
            }
          }, 1000 * 0.75)
        }
      },
    })

    // 初期値
    this.rule_set({initial_main_sec: 60*5, initial_read_sec:0, initial_extra_sec: 0, every_plus: 5})

    if (this.development_p) {
      this.rule_set({initial_main_sec: 60*60*2, initial_read_sec:0,  initial_extra_sec:  0,  every_plus: 0}) // 1行 7文字
      this.rule_set({initial_main_sec: 60*30,   initial_read_sec:0,  initial_extra_sec:  0,  every_plus: 0}) // 1行 5文字
      this.rule_set({initial_main_sec: 60*60*2, initial_read_sec:0,  initial_extra_sec: 60,  every_plus: 0}) // 2行 7文字
      this.rule_set({initial_main_sec: 60*60*2, initial_read_sec:60, initial_extra_sec: 60,  every_plus:60}) // 3行 7文字
    }
  },
  mounted() {
    this.ga_click("対局時計")
    if (this.development_p) {
    } else {
      // this.$refs.XclockAppFooter.$refs.preset_menu_pull_down.toggle()
    }
    this.full_screen = new FullScreen()
  },
  beforeDestroy() {
    this.full_screen.off()
    this.chess_clock.timer_stop()
  },
  methods: {
    resume_handle() {
      this.sound_play("click")
      this.chess_clock.pause_off()
      this.talk_stop()
    },
    pause_handle() {
      if (this.chess_clock.running_p) {
        this.talk_stop()
        this.sound_play("click")
        this.chess_clock.pause_on()

        if (false) {
          this.$buefy.dialog.confirm({
            title: "ポーズ中",
            message: `終了しますか？`,
            confirmText: "終了",
            cancelText: "再開",
            type: "is-danger",
            hasIcon: false,
            trapFocus: true,
            focusOn: "cancel",
            onCancel:  () => this.resume_handle(),
            onConfirm: () => this.stop_handle(),
          })
        }
      }
    },
    stop_handle() {
      if (this.chess_clock.running_p) {
        this.full_screen.off()
        this.talk_stop()
        this.sound_play("click")
        this.chess_clock.stop_button_handle()
      }
    },
    play_handle() {
      if (this.chess_clock.running_p) {
      } else {
        this.full_screen.on()
        this.sound_play("start")
        this.ga_click("対局時計●")
        this.say(this.play_talk_message())
        this.chess_clock.play_button_handle()
      }
    },
    play_talk_message() {
      let s = ""
      s += "対局かいし。"
      if (isMobile.any()) {
        if (DeviseAngle.portrait_p()) {
          s += "ブラウザのタブを1つだけにして、スマホを横向きにしてください"
        } else {
          s += "ブラウザのタブを1つだけにして、スマホをいったん縦持ちにしてから横持ちにすると、全画面になるはずです"
        }
      } else {
        s += "キーボードの左右のシフトキーとかで、てばんを変更できます"
      }
      return s
    },
    switch_handle(e) {
      if (this.chess_clock.running_p) {
        e.simple_switch_handle()
      } else {
        e.tap_and_auto_start_handle()
      }
    },
    copy_handle() {
      this.sound_play("click")
      this.say("左の設定を右にコピーしますか？")

      this.$buefy.dialog.confirm({
        title: "コピー",
        message: `左の設定を右にコピーしますか？`,
        confirmText: "コピーする",
        cancelText: "キャンセル",
        // type: "is-danger",
        hasIcon: false,
        trapFocus: true,
        onConfirm: () => {
          this.talk_stop()
          this.sound_play("click")
          this.chess_clock.copy_1p_to_2p()
          this.say("コピーしました")
        },
        onCancel: () => {
          this.talk_stop()
          this.sound_play("click")
        },
      })
    },
    keyboard_handle() {
      this.sound_play("click")
      this.talk_stop()
      const dialog = this.$buefy.dialog.alert({
        title: "ショートカットキー",
        message: `
          <p class="mt-0"><b>左</b> → <code>左SHIFT</code> <code>左CONTROL</code> <code>TAB</code></p>
          <p class="mt-2"><b>右</b> → <code>右SHIFT</code> <code>右CONTROL</code> <code>ENTER</code> <code>↑↓←→</code></p>
        `,
        confirmText: "OK",
        canCancel: ["outside", "escape"],
        trapFocus: true,
        onConfirm: () => {
          this.talk_stop()
          this.sound_play("click")
        },
        onCancel: () => {
          this.talk_stop()
          this.sound_play("click")
        },
      })
    },
    dropdown_active_change(on) {
      if (on) {
        this.sound_play("click")
      } else {
        this.sound_play("click")
      }
    },
    rule_set(params) {
      this.chess_clock.rule_set_all(params)
    },
  },
  computed: {
    base() { return this },
    mouse_cursor_hidden() {
      return this.chess_clock.timer && !this.mouse_cursor_p
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
@import "time_fields_default.sass"
@import "time_fields_desktop.sass"

.Xclock
  // ポーズのときのカバー
  .pause_bg
    position: fixed
    top: 0
    left: 0
    right: 0
    bottom: 0
    background-color: hsla(0, 0%, 0%, 0.7)
    z-index: 2

  .screen_container // 100vw x 100vh 相当の範囲
    height: 100vh   // 初期値(JSで上書きする)

    //////////////////////////////////////////////////////////////////////////////// カーソルを消す
    &.mouse_cursor_hidden
      cursor: none

    //////////////////////////////////////////////////////////////////////////////// 動作中は背景黒にする場合
    @at-root
      .is_xclock_active
        .screen_container // & と書きたい
          color: $white
          background-color: $black-ter
          .level-item
            &.is_sclock_inactive
              background-color: $black

    ////////////////////////////////////////////////////////////////////////////////

    // 停止ボタンを画面中央に配置
    .controll_button
      z-index: 2
      position: fixed
      top: 0
      left: 0
      right: 0
      bottom: 0
      margin: auto
      padding: 1.5rem
      border-radius: 50%
      color: $grey-lighter
      &.pause
        color: $grey
      &.resume, &.stop
        background-color: hsla(0, 50%, 100%, 0.2)
        background-color: change_color($primary, $alpha: 0.5)
      &.stop
        top: 50%
        +desktop
          top: 25%

    // .level を左右均等に配置
    flex-direction: column
    justify-content: space-between
    align-items: center

    // 半分を囲むブロック(つまりフッターを含まない)
    .level
      height: 100%
      width: 100%

      // 半分
      .level-item
        height: 100%
        width: 50%

        // 文字やフォームを中央縦並び配置
        flex-direction: column
        justify-content: space-between
        align-items: center

        // どちらがアクティブかを表すバー
        .active_current_bar, .inactive_current_bar
          height: 48px
          width: 100%
        .active_current_bar
          background-color: $primary

        // 時間表示(フォームも含む)
        .wide_container
          height: 100%
          width: 100%

          // 中央縦並び
          flex-direction: column
          justify-content: center
          align-items: center

          // 時間表示だけを囲むブロック
          &.time_fields
            @at-root
              .is_sclock_inactive
                .time_fields
                  opacity: 0.4
            .time_label
              font-weight: bold
            .time_value
              line-height: 1
              font-weight: bold
            // 1行表示
            &.display_lines-1
              .time_label
                display: none   // ラベル除去

          ////////////////////////////////////////////////////////////////////////////////
          &.form
            > .field
              margin-left: 1rem
              margin-right: 1rem
              &:not(:first-child)
            label
              margin-bottom: 0
            .b-numberinput
              margin-top: 0
              input
                min-width: 5rem
                +desktop
                  min-width: 8rem

  &.is_xclock_active
    .screen_container
      .active_current_bar
        &.is_level1
          background-color: $blue
          &.is_blink
            animation: bar_blink 1s ease-in-out 0.5s infinite alternate
        &.is_level2
          background-color: $yellow
          &.is_blink
            animation: bar_blink 0.5s ease-in-out 0.5s infinite alternate
        &.is_level3
          background-color: $red
          &.is_blink
            animation: bar_blink 0.5s ease-in-out 0.5s infinite alternate
        &.is_level4
          background-color: $red
          &.is_blink
            animation: bar_blink 0.25s ease-in-out 0.5s infinite alternate

@keyframes bar_blink
  0%
    opacity: 1.0
  100%
    opacity: 0.25

=xray($level)
  $color: hsla((360 / 8) * $level, 50%, 50%, 1.0)
  border: 2px solid $color

.STAGE-development
  .Xclock
    .screen_container
      .level
        +xray(0)
        .level-item
          +xray(1)
          .wide_container
            .field
              +xray(2)
            .time_fields
              .time_label
                +xray(3)
              .time_value
                +xray(4)
      .XclockAppFooter
        .item
          +xray(5)
</style>
