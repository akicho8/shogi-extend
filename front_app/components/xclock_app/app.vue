<template lang="pug">
.xclock_app(:class="chess_clock.timer ? 'is_xclock_active' : 'is_xclock_inactive'")
  .screen_container.is-flex.is-relative(:class="{mouse_cursor_hidden: mouse_cursor_hidden}")
    b-icon.stop_button.is_clickable(icon="pause" @click.native="pause_handle" v-if="chess_clock.timer")
    .level.is-mobile.is-unselectable.is-marginless
      template(v-for="(e, i) in chess_clock.single_clocks")
        .level-item.has-text-centered.is-marginless(@click="switch_handle(e)" :class="e.dom_class")
          .acive_current_bar(v-if="e.active_p" :class="e.bar_class")
          .inacive_current_bar(v-if="!e.active_p")
          .digit_container.is-flex
            template(v-if="chess_clock.timer")
              .digit_values(:class="[`display_lines-${e.display_lines}`, `text_width-${e.to_time_format.length}`]")
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
            template(v-if="!chess_clock.timer")
              b-field.mt-0.mx-4(label="持ち時間(分)")
                b-numberinput(controls-position="compact" v-model="e.main_minute_for_vmodel" :min="0" :max="60*9" :exponential="true" @click.native.stop="" :checkHtml5Validity="false")
              b-field.mt-5.mx-4(label="1手ごとに加算")
                b-numberinput(controls-position="compact" v-model="e.every_plus" :min="0" :max="60*60" :exponential="true" @click.native.stop="")
              b-field.mt-5.mx-4(label="秒読み")
                b-numberinput(controls-position="compact" v-model="e.initial_read_sec_for_v_model" :min="0" :max="60*60" :exponential="true" @click.native.stop="")
              b-field.mt-5.mx-4(label="猶予")
                b-numberinput(controls-position="compact" v-model="e.initial_extra_sec" :min="0" :max="60*60" :exponential="true" @click.native.stop="")

    the_footer(ref="the_footer")

  .debug_container.mt-5(v-if="development_p")
    .buttons.are-small.is-centered
      b-button(@click="chess_clock.generation_next(-1)") -1
      b-button(@click="chess_clock.generation_next(-60)") -60
      b-button(@click="chess_clock.generation_next(1)") +1
      b-button(@click="chess_clock.generation_next(60)") +60
      b-button(@click="chess_clock.clock_switch()") 切り替え
      b-button(@click="chess_clock.timer_start()") START ({{chess_clock.timer}})
      b-button(@click="chess_clock.timer_stop()") STOP
      b-button(@click="chess_clock.params.every_plus = 5") フィッシャールール
      b-button(@click="chess_clock.params.every_plus = 0") 通常ルール
      b-button(@click="chess_clock.reset()") RESET
      b-button(@click="chess_clock.main_sec_set(3)") 両方残り3秒
    b-message
      p 1手毎に{{chess_clock.params.every_plus}}秒加算
      p mouse_cursor_p: {{mouse_cursor_p}}

</template>

<script>

import { ChessClock   } from "../../../app/javascript/actb_app/models/chess_clock.js"
import { DeviseAngle  } from "../../../app/javascript/models/DeviseAngle.js"
import { isMobile     } from "../../../app/javascript/models/isMobile.js"
import { support      } from "./support.js"
import { store        } from "./store.js"
import the_footer       from "./the_footer.vue"

import { app_mouse_hidden         } from "./app_mouse_hidden.js"
import { app_keyboard_shortcut    } from "./app_keyboard_shortcut.js"
import { app_mobile_screen_adjust } from "./app_mobile_screen_adjust.js"

export default {
  store,
  name: "xclock_app",
  mixins: [
    support,
    app_mouse_hidden,
    app_keyboard_shortcut,
    app_mobile_screen_adjust,
  ],
  components: {
    the_footer,
  },
  data() {
    return {
      chess_clock: null,
    }
  },
  beforeCreate() {
    this.$store.state.app = this
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
    if (this.development_p) {
      this.rule_set({initial_main_sec: 60*60*2, initial_read_sec:0,  initial_extra_sec:  0,  every_plus: 0}) // 1行 7文字
      this.rule_set({initial_main_sec: 60*30,   initial_read_sec:0,  initial_extra_sec:  0,  every_plus: 0}) // 1行 5文字
      this.rule_set({initial_main_sec: 60*60*2, initial_read_sec:0,  initial_extra_sec: 60,  every_plus: 0}) // 2行 7文字
      this.rule_set({initial_main_sec: 60*60*2, initial_read_sec:60, initial_extra_sec: 60,  every_plus:60}) // 3行 7文字
    }
  },
  mounted() {
    if (this.development_p) {
    } else {
      this.$refs.the_footer.$refs.preset_menu_pull_down.toggle()
    }
  },
  beforeDestroy() {
    this.chess_clock.timer_stop()
  },
  methods: {
    pause_handle() {
      if (this.chess_clock.timer) {
        this.talk_stop()
        this.sound_play("click")
        this.chess_clock.pause_on()

        this.$buefy.dialog.confirm({
          title: "ポーズ",
          message: `終了しますか？`,
          confirmText: "終了する",
          cancelText: "再開する",
          type: "is-danger",
          hasIcon: false,
          trapFocus: true,
          onCancel: () => {
            this.sound_play("click")
            this.chess_clock.pause_off()
            this.talk_stop()
          },
          onConfirm: () => {
            this.talk_stop()
            this.sound_play("click")
            this.chess_clock.stop_button_handle()
          },
        })
      }
    },

    stop_handle() {
      if (this.chess_clock.timer) {
        this.talk_stop()
        this.sound_play("click")
        this.say("停止")
        this.chess_clock.stop_button_handle()
      }
    },

    play_handle() {
      if (this.chess_clock.timer) {
      } else {
        this.sound_play("start")
        this.say(this.play_talk_message())
        this.chess_clock.play_button_handle()
      }
    },

    play_talk_message() {
      let s = ""
      s += "対局かいし。"
      if (isMobile.any()) {
        if (DeviseAngle.portrait_p()) {
          s += "ブラウザのタブを1つだけにしてスマホを横向きにしてください"
        }
      } else {
        s += "キーボードの左右のシフトキーとかで、てばんを変更できます"
      }
      return s
    },

    switch_handle(e) {
      if (this.chess_clock.timer_active_p) {
        e.tap_and_auto_start_handle()
      } else {
        e.set_or_tap_handle()
      }
    },
    back_handle() {
      location.href = "/"
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

    help_handle() {
      this.sound_play("click")
      this.talk_stop()
      const dialog = this.$buefy.dialog.alert({
        title: "ショートカットキー",
        message: `
          <div class="content is-size-7">
            <p>左 <code>左SHIFT</code> <code>左CONTROL</code> <code>TAB</code></p>
            <p>右 <code>右SHIFT</code> <code>右CONTROL</code> <code>ENTER</code> <code>↑↓←→</code></p>
          </div>`,
        // <p>PAUSE <code>SPACE</code></p>
        // <li>終了 <code>ESC</code></li>
        confirmText: "わかった",
        canCancel: ["outside", "escape"],
        type: "is-info",
        hasIcon: true,
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

      //       this.say(`
      // タップモードでは符号に対応する位置をタップします。
      // タップじゃないモードでは駒の場所をキーボードの数字2桁で入力していきます。最初の数字を間違えたときはエスケープキーでキャンセルできます。
      // 選択した数まで正解するまでの時間を競います。
      // ログインしていると毎回出る名前の入力を省略できます。
      // `, {onend: () => { dialog.close() }})
    },

    dropdown_active_change(on) {
      if (on) {
        this.sound_play("click")
      } else {
        this.sound_play("click")
      }
    },

    rule_set(params) {
      // this.sound_play("click")
      this.chess_clock.rule_set_all(params)
    },

  },
  computed: {
    mouse_cursor_hidden() {
      return this.chess_clock.timer && !this.mouse_cursor_p
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
@import "app.sass"
@import "digit_values_default.sass"
@import "digit_values_desktop.sass"

.xclock_app
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
    .stop_button
      position: absolute
      top: 0
      left: 0
      right: 0
      bottom: 0
      margin: auto

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
        .acive_current_bar, .inacive_current_bar
          height: 48px
          width: 100%
        .inacive_current_bar
        .acive_current_bar
          background-color: $primary

        // 時間表示(フォームも含む)
        .digit_container
          height: 100%
          width: 100%

          // 中央縦並び
          flex-direction: column
          justify-content: center
          align-items: center

          // 時間表示だけを囲むブロック
          .digit_values
            @at-root
              .is_sclock_inactive
                .digit_values
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

          .b-numberinput
            input
              min-width: 8rem

  &.is_xclock_active
    .screen_container
      .acive_current_bar
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
  // background-color: $color
  border: 2px solid $color

.development
  .xclock_app
    .screen_container
      .level
        +xray(0)
        .level-item
          +xray(1)
          .digit_container
            .field
              +xray(2)
            .digit_values
              .time_label
                +xray(3)
              .time_value
                +xray(4)
      .the_footer
        .item
          +xray(5)
</style>
