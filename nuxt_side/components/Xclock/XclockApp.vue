<template lang="pug">
.Xclock(:class="clock_box.pause_or_play_p ? 'is_xclock_active' : 'is_xclock_inactive'")
  DebugBox(v-if="development_p")
    div turn: {{clock_box.turn}}
    div pause_or_play_p: {{clock_box.pause_or_play_p}}
    div timer: {{clock_box.timer}}
    div counter: {{clock_box.counter}}
    div any_zero_p: {{clock_box.any_zero_p}}
    div mouse_cursor_p: {{mouse_cursor_p}}

  //////////////////////////////////////////////////////////////////////////////// form
  template(v-if="!clock_box.pause_or_play_p")
    .screen_container.is-flex
      .level.is-mobile.is-unselectable.is-marginless
        template(v-for="(e, i) in clock_box.single_clocks")
          .level-item.has-text-centered.is-marginless(@pointerdown="xswitch_handle(e)" :class="e.dom_class")
            .active_current_bar(:class="e.rest_class" v-if="e.active_p")
            .inactive_current_bar(v-else)
            .wide_container.form.is-flex
              b-field(label="持ち時間(分)" custom-class="is-small")
                b-numberinput(size="is-small" controls-position="compact" v-model="e.initial_main_min_for_vmodel" :min="0" :max="60*9" :exponential="true" @pointerdown.native.stop="" :checkHtml5Validity="false")
              b-field(label="1手ごとに加算(秒)" custom-class="is-small")
                b-numberinput(size="is-small" controls-position="compact" v-model="e.every_plus" :min="0" :max="60*60" :exponential="true" @pointerdown.native.stop="")
              b-field(label="秒読み" custom-class="is-small")
                b-numberinput(size="is-small" controls-position="compact" v-model="e.initial_read_sec_for_v_model" :min="0" :max="60" :exponential="true" @pointerdown.native.stop="")
              b-field(label="考慮時間(分)" custom-class="is-small")
                b-numberinput(size="is-small" controls-position="compact" v-model="e.initial_extra_min_for_v_model" :min="0" :max="60" :exponential="true" @pointerdown.native.stop="")
      XclockAppFooter(:base="base" ref="XclockAppFooter")

  //////////////////////////////////////////////////////////////////////////////// 実行中
  template(v-if="clock_box.pause_or_play_p")
    .pause_bg(v-if="!clock_box.timer")
    .screen_container.is-flex(:class="{mouse_cursor_hidden_p: mouse_cursor_hidden_p}")
      b-icon.controll_button.pause.is-clickable(icon="pause" v-if="clock_box.timer" @click.native="pause_handle")
      b-icon.controll_button.resume.is-clickable(icon="play" v-if="!clock_box.timer" @click.native="resume_handle")
      b-icon.controll_button.stop.is-clickable(icon="stop" v-if="!clock_box.timer" @click.native="stop_handle")
      .level.is-mobile.is-unselectable.is-marginless
        template(v-for="(e, i) in clock_box.single_clocks")
          .level-item.has-text-centered.is-marginless(@pointerdown="xswitch_handle(e)" :class="e.dom_class")
            .active_current_bar(:class="e.rest_class" v-if="e.active_p && clock_box.timer")
            .inactive_current_bar(v-else)
            .wide_container.time_fields.is-flex(:class="[`display_lines-${e.display_lines}`, `text_width-${e.main_sec_mmss.length}`]")
              .field(v-if="e.initial_main_sec >= 1 || e.every_plus >= 1")
                .time_label 残り時間
                .time_value.is-family-monospace.is_line_break_off
                  | {{e.main_sec_mmss}}
              .field(v-if="e.initial_read_sec >= 1")
                .time_label 秒読み
                .time_value.is-family-monospace.is_line_break_off
                  | {{e.read_sec_mmss}}
              .field(v-if="e.initial_extra_sec >= 1")
                .time_label 猶予
                .time_value.is-family-monospace.is_line_break_off
                  | {{e.extra_sec_mmss}}

  //////////////////////////////////////////////////////////////////////////////// form
  .debug_container.mt-5(v-if="development_p")
    ClockBoxInspector(:clock_box="clock_box" v-if="clock_box")
    .box
      p mouse_cursor_p: {{mouse_cursor_p}}

</template>

<script>
import { ClockBox                   } from "@/components/models/clock_box/clock_box.js"
import { DeviseAngle                } from "@/components/models/devise_angle.js"
import { MyMobile                   } from "@/components/models/my_mobile.js"
import { FullScreenController       } from "@/components/models/full_screen_controller.js"
import { CcRuleInfo                 } from "@/components/models/cc_rule_info.js"

import { support                    } from "./support.js"

import { mouse_cursor_hidden_mixin  } from "../models/mouse_cursor_hidden_mixin.js"
import { mobile_screen_adjust_mixin } from "../models/mobile_screen_adjust_mixin.js"
import { mod_keyboard_shortcut      } from "./mod_keyboard_shortcut.js"

import { Gs                         } from "@/components/models/gs.js"

export default {
  name: "XclockApp",
  mixins: [
    support,
    mouse_cursor_hidden_mixin,
    mod_keyboard_shortcut,
    mobile_screen_adjust_mixin,
  ],
  data() {
    return {
      clock_box: null,
      full_screen: null,
    }
  },
  created() {
    this.clock_box = new ClockBox({
      initial_turn: 0,
      switched_fn: () => {
        this.sfx_play_click()
      },
      time_zero_fn: e => {
        this.sfx_play("lose")
        this.say("時間切れ")
        this.$buefy.dialog.alert({
          message: "時間切れ",
          onConfirm: () => { this.stop_handle() },
        })
      },
      second_decriment_fn: (single_clock, key, sec, mm, ss) => {
        if (1 <= mm && mm <= 10) {
          if (ss === 0) {
            this.say(`${mm}分`)
          }
        }
        if (sec === 10 || sec === 20 || sec === 30) {
          this.say(`${sec}秒`)
        }
        if (sec <= 5) {
          this.say(`${sec}`)
        }
        if (sec <= 6 && false) {
          const index = single_clock.index
          setTimeout(() => {
            if (index === single_clock.base.current_index) {
              this.say(`${sec - 1}`)
            }
          }, 1000 * 0.75)
        }
      },
    })

    // 初期値
    this.rule_set({initial_main_min: 5, initial_read_sec:0, initial_extra_min: 0, every_plus: 5})

    if (this.development_p) {
      this.rule_set({initial_main_min: 60*2, initial_read_sec:0,  initial_extra_min:  0,  every_plus: 0}) // 1行 7文字
      this.rule_set({initial_main_min: 30,   initial_read_sec:0,  initial_extra_min:  0,  every_plus: 0}) // 1行 5文字
      this.rule_set({initial_main_min: 60*2, initial_read_sec:0,  initial_extra_min:  1,  every_plus: 0}) // 2行 7文字
      this.rule_set({initial_main_min: 60*2, initial_read_sec:60, initial_extra_min:  2,  every_plus:60}) // 3行 7文字
    }
  },
  mounted() {
    this.app_log("対局時計")
    if (this.development_p) {
    } else {
      // this.$refs.XclockAppFooter.$refs.preset_menu_pull_down.toggle()
    }
    this.full_screen = new FullScreenController()
  },
  beforeDestroy() {
    this.full_screen.off()
    this.clock_box.timer_stop()
  },
  methods: {
    resume_handle() {
      this.sfx_play_click()
      this.clock_box.resume_handle()
      this.behavior_notify("resume")
      this.sfx_stop_all()
    },
    pause_handle() {
      if (this.clock_box.pause_or_play_p) {
        this.sfx_stop_all()
        this.sfx_play_click()
        this.clock_box.pause_handle()
        this.behavior_notify("pause")

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
      if (this.clock_box.pause_or_play_p) {
        this.full_screen.off()
        this.sfx_stop_all()
        this.sfx_play_click()
        this.clock_box.stop_handle()
        this.behavior_notify("stop")
      }
    },
    play_handle() {
      if (this.clock_box.pause_or_play_p) {
      } else {
        this.full_screen.on()
        this.sfx_play("start")
        this.app_log("対局時計●")
        this.say(this.play_talk_message())
        this.clock_box.play_handle()
        this.behavior_notify("play")
      }
    },
    play_talk_message() {
      let s = ""
      s += "対局かいし。"
      if (MyMobile.mobile_p) {
        if (DeviseAngle.portrait_p()) {
          s += "ブラウザのタブを1つだけにして、スマホを横向きにしてください"
        } else {
          s += "ブラウザのタブを1つだけにして、スマホをいったん縦持ちにしてから横持ちにすると、全画面になります"
        }
      } else {
        s += "キーボードの左右のシフトキーとかで、てばんを変更できます"
      }
      return s
    },
    xswitch_handle(e) {
      // 開始前の状態では条件なく手番を切り替える
      if (!this.clock_box.pause_or_play_p) {
        this.clock_box.clock_switch()
        return
      }

      e.tap_on()
    },
    copy_handle() {
      this.sfx_play_click()
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
          this.sfx_stop_all()
          this.sfx_play_click()
          this.clock_box.copy_1p_to_2p()
          this.say("コピーしました")
        },
        onCancel: () => {
          this.sfx_stop_all()
          this.sfx_play_click()
        },
      })
    },
    keyboard_handle() {
      this.sfx_play_click()
      this.sfx_stop_all()
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
          this.sfx_stop_all()
          this.sfx_play_click()
        },
        onCancel: () => {
          this.sfx_stop_all()
          this.sfx_play_click()
        },
      })
    },
    dropdown_active_change(on) {
      if (on) {
        this.sfx_play_click()
      } else {
        this.sfx_play_click()
      }
    },
    rule_set(params) {
      params = {...params}
      Gs.assert("initial_main_min" in params, '"initial_main_min" in params')
      params.initial_main_sec  = params.initial_main_min * 60
      params.initial_extra_sec = params.initial_extra_min * 60
      this.clock_box.rule_set_all(params)
    },
    behavior_notify(behavior) {
      this.app_log({emoji: ":目覚まし時計:", subject: "対局時計単体", body: behavior})
    },
  },
  computed: {
    base()                  { return this                                         },
    CcRuleInfo()            { return CcRuleInfo                                   },
    mouse_cursor_hidden_p() { return this.clock_box.timer && !this.mouse_cursor_p },
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
    &.mouse_cursor_hidden_p
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
                __css_keep__: 0
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
        &.cc_rest_gteq_60
          background-color: $blue
          &.cc_rest_gteq_1
            animation: xclock_bar_blink 1s ease-in-out 0.5s infinite alternate
        &.cc_rest_lt_60
          background-color: $yellow
          &.cc_rest_gteq_1
            animation: xclock_bar_blink 0.5s ease-in-out 0.5s infinite alternate
        &.cc_rest_lteq_10
          background-color: $red
          &.cc_rest_gteq_1
            animation: xclock_bar_blink 0.5s ease-in-out 0.5s infinite alternate
        &.cc_rest_lteq_5
          background-color: $red
          &.cc_rest_gteq_1
            animation: xclock_bar_blink 0.25s ease-in-out 0.5s infinite alternate

@keyframes xclock_bar_blink
  0%
    opacity: 1.0
  100%
    opacity: 0.25

=xray($level)
  $color: hsla(calc(360 / 8 * $level), 50%, 50%, 1.0)
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
