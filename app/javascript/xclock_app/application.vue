<template lang="pug">
.xclock_app(:class="chess_clock.standby_mode_p ? 'xclock_inactive' : 'xclock_active'")
  .screen_container.is-flex
    .level.is-mobile.is-unselectable.is-marginless
      template(v-for="(e, i) in chess_clock.single_clocks")
        .level-item.has-text-centered.is-marginless(@click="switch_handle(e)" :class="e.dom_class")
          .current_bar
          .digit_container.is-flex
            template(v-if="chess_clock.timer")
              .digit_values.my-6(:class="[`display_lines-${e.display_lines}`, `text_width-${e.to_time_format.length}`]")
                .field(v-if="e.initial_main_sec >= 1")
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
                b-numberinput(controls-position="compact" v-model="e.main_minute_for_vmodel" :min="0" :exponential="10" @click.native.stop="" :checkHtml5Validity="false")
              b-field.mt-5.mx-4(label="1手ごとに加算")
                b-numberinput(controls-position="compact" v-model="e.every_plus" :min="0" :exponential="10" @click.native.stop="")
              b-field.mt-5.mx-4(label="秒読み")
                b-numberinput(controls-position="compact" v-model="e.initial_read_sec_for_v_model" :min="0" :exponential="2" @click.native.stop="")
              b-field.mt-5.mx-4(label="猶予")
                b-numberinput(controls-position="compact" v-model="e.initial_extra_sec" :min="0" @click.native.stop="")

    .the_footer.footer_nav.is-flex
      .item(@click="copy_handle" :class="{'is-invisible': chess_clock.timer}")
        b-icon(icon="content-duplicate")

      template(v-if="!chess_clock.timer")
        .item(@click="play_handle")
          b-icon(icon="play")
      template(v-else)
        .item(@click="stop_handle")
          b-icon(icon="stop")

      //- template(v-if="chess_clock.timer_active_p")
      //- .item(@click="play_handle")
      //-   b-icon(icon="play")
      //- .item(@click="pause_handle")
      //-   b-icon(icon="pause")
      //- .item(@click="stop_handle")
      //-   b-icon(icon="stop")
      //- template(v-else)

      b-dropdown(position="is-top-left" :class="{'is-invisible': chess_clock.timer}" @active-change="e => dropdown_active_change(e)")
        .item(slot="trigger")
          b-icon(icon="cog")
        b-dropdown-item(@click="rule_set({initial_main_sec: 60*10, initial_read_sec:0,  initial_extra_sec: 0,  every_plus:0})") 将棋ウォーズ 10分
        b-dropdown-item(@click="rule_set({initial_main_sec: 60*3,  initial_read_sec:0,  initial_extra_sec: 0,  every_plus:0})") 将棋ウォーズ 3分
        b-dropdown-item(@click="rule_set({initial_main_sec: 0,     initial_read_sec:10, initial_extra_sec: 0,  every_plus:0})") 将棋ウォーズ 10秒
        b-dropdown-item(:separator="true")
        b-dropdown-item(@click="rule_set({initial_main_sec: 60*5,  initial_read_sec:0,  initial_extra_sec: 0,  every_plus:0})") 将棋クエスト 5分
        b-dropdown-item(@click="rule_set({initial_main_sec: 60*2,  initial_read_sec:0,  initial_extra_sec: 0,  every_plus:0})") 将棋クエスト 2分
        b-dropdown-item(:separator="true")
        b-dropdown-item(@click="rule_set({initial_main_sec: 60*5,  initial_read_sec:0,  initial_extra_sec: 0,  every_plus:5})") ABEMA フィッシャールール 5分 +5秒/手
        b-dropdown-item(:separator="true")
        b-dropdown-item(@click="rule_set({initial_main_sec: 60*1,  initial_read_sec:30, initial_extra_sec: 0,  every_plus:0})") 将棋倶楽部24 早指  1分切ると1手30秒
        b-dropdown-item(@click="rule_set({initial_main_sec: 0,     initial_read_sec:30, initial_extra_sec: 60, every_plus:0})") 将棋倶楽部24 早指2 1手30秒 猶予1分
        b-dropdown-item(@click="rule_set({initial_main_sec: 60*15, initial_read_sec:60, initial_extra_sec: 0,  every_plus:0})") 将棋倶楽部24 15分  切ると1手60秒
        b-dropdown-item(@click="rule_set({initial_main_sec: 60*30, initial_read_sec:60, initial_extra_sec: 0,  every_plus:0})") 将棋倶楽部24 長考  30分切ると1手60秒

      template(v-if="!chess_clock.timer")
        .item(@click="help_handle")
          b-icon(icon="help")

      //-   b-icon(icon="timer-outline")
      //- .item(@click="edit_handle")
      //-   b-icon(icon="cog")

      //- .item(@click="app.lobby_handle")
      //-   b-icon(:icon="app.mode === 'lobby'    ? 'home'        : 'home-outline'"  :class="{'has-text-primary': app.mode === 'lobby'}")
      //- .item(@click="app.ranking_handle")
      //-   b-icon(:icon="app.mode === 'ranking'  ? 'crown'       : 'crown-outline'" :class="{'has-text-primary': app.mode === 'ranking'}")
      //- .item(@click="app.history_handle")
      //-   b-icon(:icon="app.mode === 'history'  ? 'history'     : 'history'"       :class="{'has-text-primary': app.mode === 'history'}")
      //- .item(@click="app.builder_handle")
      //-   b-icon(:icon="app.mode === 'builder'  ? 'plus-thick'  : 'plus'"          :class="{'has-text-primary': app.mode === 'builder'}")
      //- .item(@click="app.menu_handle")
      //-   b-icon(:icon="app.mode === 'menu'     ? 'menu'        : 'menu'"          :class="{'has-text-primary': app.mode === 'menu'}")

      //- b-dropdown(position="is-top-left" v-if="false")
      //-   b-button(slot="trigger" icon-left="menu" @click="sound_play('click')")
      //-   b-dropdown-item(href="/" @click="sound_play('click')") TOP

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
      | 1手毎に{{chess_clock.params.every_plus}}秒加算
</template>

<script>

import { ChessClock } from "../actb_app//models/chess_clock.js"
import Location from "shogi-player/src/location.js"

import { support } from "./support.js"
import { store   } from "./store.js"
import { application_shortcut } from "./application_shortcut.js"
import { application_resize } from "./application_resize.js"
import the_footer from "./the_footer.vue"

export default {
  store,
  name: "xclock_app",
  mixins: [
    support,
    application_shortcut,
    application_resize,
  ],
  components: {
    the_footer,
  },
  props: {
    info: { required: true },
  },
  data() {
    return {
      chess_clock: null,
      mode: null,
    }
  },
  beforeCreate() {
    this.$store.state.app = this
  },
  created() {
    this.mode = "main"
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
      second_decriment_hook: (key, t, m, s) => {
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
    window.addEventListener("orientationchange", this.orientationchange_func)
  },

  beforeDestroy() {
    window.removeEventListener("orientationchange", this.orientationchange_func)
    this.chess_clock.timer_stop()
  },
  methods: {
    landscape_p() {
      let angle = screen && screen.orientation && screen.orientation.angle
      if (angle == null) {
        angle = window.orientation || 0
      }
      return (angle % 180) === 0
    },
    portrait_p() {
      return !this.landscape_p()
    },
    orientationchange_func(e) {
      alert(1)
    },
    pause_handle() {
      if (this.chess_clock.timer) {
        this.sound_play("click")
        this.say("ポーズ")
        this.chess_clock.timer_stop()
      }
    },
    stop_handle() {
      if (this.chess_clock.timer) {
        this.sound_play("click")
        this.say("ストップ")
        this.chess_clock.stop_button_handle()
      } else {
      }
    },
    play_handle() {
      if (this.chess_clock.timer) {
      } else {
        this.sound_play("start")
        this.say("対局かいし", {onend: () => {
          if (this.portrait_p()) {
            this.say("ブラウザのタブを1つだけにしてスマホを横向きにしてください")
          }
        }})
        this.chess_clock.play_button_handle()
      }
    },
    switch_handle(e) {
      if (this.chess_clock.timer_active_p) {
        e.tap_and_auto_start_handle()
      } else {
        e.set_or_tap_handle()
      }
    },
    copy_handle() {
      this.sound_play("click")

      this.$buefy.dialog.confirm({
        title: "コピー",
        message: `左の設定を右にコピーしますか？`,
        confirmText: "コピーする",
        cancelText: "キャンセル",
        // type: "is-danger",
        hasIcon: false,
        trapFocus: true,
        animation: "",
        onConfirm: () => {
          this.sound_play("click")
          this.chess_clock.copy_1p_to_2p()
          this.say("コピーしました")
        },
        onCancel: () => { this.sound_play("click") },
      })
    },

    // edit_handle() {
    //   this.sound_play("click")
    //   this.edit_mode_p = !this.edit_mode_p
    // },
    timer_handle() {
      this.sound_play("click")

      this.$buefy.dialog.prompt({
        title: "連番生成",
        message: "何問ありますか？",
        confirmText: "生成",
        cancelText: "キャンセル",
        inputAttrs: { type: 'number', value: 3, min: 0 },
        onConfirm: (value) => {
          // this.generate_max = parseInt(value, 10)
          // this.quest_text = [...Array(this.generate_max).keys()].map(i => 1 + i).join(" ")
        },
      })

    },

    help_handle() {
      this.sound_play("click")
      this.talk_stop()
      const dialog = this.$buefy.dialog.alert({
        title: "キーボード・ショートカット",
        message: `
          <div class="content is-size-7">
            <ol>
              <li>左は <code>TAB</code> <code>CONTROL</code> <code>左SHIFT</code> <code>SPACE</code> で切り替え</li>
              <li>右は <code>ENTER</code> <code>右SHIFT</code> <code>→</code> で切り替え</li>
            </ol>
          </div>`,
        confirmText: "わかった",
        canCancel: ["outside", "escape"],
        type: "is-info",
        hasIcon: true,
        trapFocus: true,
        onConfirm: () => { this.talk_stop() },
        onCancel:  () => { this.talk_stop() },
      })

      //       this.say(`
      // タップモードでは符号に対応する位置をタップします。
      // タップじゃないモードでは駒の場所をキーボードの数字2桁で入力していきます。最初の数字を間違えたときはエスケープキーでキャンセルできます。
      // 選択した数まで正解するまでの時間を競います。
      // ログインしていると毎回出る名前の入力を省略できます。
      // `, {onend: () => { dialog.close() }})
    },

    dropdown_active_change(e) {
      if (e) {
        // this.say("プリセット")
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
    Location() { return Location },
  },
}
</script>

<style lang="sass">
@import "support.sass"
@import "application.sass"

.xclock_app
  .screen_container
    // 初期値(JSで上書きする)
    height: 100vh

    flex-direction: column
    justify-content: space-between
    align-items: center

    .level
      height: 100%
      width: 100%
      .level-item
        flex-direction: column
        justify-content: space-between
        align-items: center

        height: 100%
        width: 50%

        .current_bar
          height: 48px
          width: 100%
          @at-root
            .is_sclock_active
              .current_bar
                background-color: $primary

        .digit_container
          flex-direction: column
          justify-content: center
          align-items: center

          height: 100%
          width: 100%

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
              // スマホ縦持ち
              @media (orientation: portrait)
                font-size: 10vmin !important
            // 1行表示
            &.display_lines-1
              .time_label
                display: none   // ラベル除去
              .time_value
                font-size: 25vmin // 1行5文字
                // font-size: calc(50vw / 4)
              &.text_width-7
                .time_value
                  font-size: 20vmin // 1行7文字
            // 2行表示
            &.display_lines-2
              .time_value
                font-size: 25vmin // 2行5文字
              &.text_width-7
                .time_value
                  font-size: 20vmin // 2行7文字
              .time_value
                margin-top: 1rem  // 2行表示では隙間がとれるので広めに開ける
              .field
                &:not(:first-child)
                  margin-top: 3rem // 2行表示では隙間がとれるので広めに開ける
            // 3行表示
            &.display_lines-3
              .time_value
                font-size: 16vmin // 3行5,7文字
              .time_value
                margin-top: 0.4rem
              .field
                &:not(:first-child)
                  margin-top: 3rem

  .the_footer
    &.footer_nav
      border-top: 1px solid $grey-lighter
      background-color: change_color($white-ter, $alpha: 0.96)
      .item
        cursor: pointer

        padding-right: 1rem
        padding-left: 1rem
        height: inherit

        display: flex
        justify-content: center
        align-items: center
</style>
