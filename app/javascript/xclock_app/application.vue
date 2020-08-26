<template lang="pug">
.xclock_app(:class="chess_clock.standby_mode_p ? 'xclock_inactive' : 'xclock_active'")
  .screen_container.is-flex
    .level.is-mobile.is-unselectable.is-marginless
      template(v-for="(e, i) in chess_clock.single_clocks")
        .level-item.has-text-centered.is-marginless(@click="switch_handle(e)" :class="e.dom_class")
          .mark_div
          .digit_div.is-flex
            .title.fixed_font.is_line_break_off
              | {{e.to_time_format}}
              span.ml-6(v-if="e.extra_second >= 1")
                | {{e.extra_second}}

            template(v-if="!chess_clock.timer")
              b-field.mt-5(label="持ち時間(分)")
                b-numberinput(v-model="e.main_minute_for_vmodel" :min="0" :exponential="10" @click.native.stop="" :checkHtml5Validity="false")
              b-field.mt-5(label="1手ごとに加算")
                b-numberinput(v-model="e.every_plus" :min="0" :exponential="10" @click.native.stop="")
              b-field.mt-5(label="最低持ち時間")
                b-numberinput(v-model="e.range_low_for_v_model" :min="0" :exponential="2" @click.native.stop="")
              b-field.mt-5(label="猶予")
                b-numberinput(v-model="e.extra_second" :min="0" @click.native.stop="")

    .the_footer.footer_nav.is-flex
      .item(@click="copy_handle" :class="{'is-invisible': chess_clock.timer}")
        b-icon(icon="content-duplicate")

      template(v-if="chess_clock.timer_active_p")
        .item(@click="pause_handle")
          b-icon(icon="stop")
      template(v-else)
        .item(@click="play_handle")
          b-icon(icon="play")

      b-dropdown(position="is-top-left" :class="{'is-invisible': chess_clock.timer}" @active-change="e => dropdown_active_change(e)")
        .item(slot="trigger")
          b-icon(icon="cog")
        b-dropdown-item(@click="rule_set({main_second: 60*10, range_low:0,  extra_second: 0,  every_plus:0})") 将棋ウォーズ 10分
        b-dropdown-item(@click="rule_set({main_second: 60*3,  range_low:0,  extra_second: 0,  every_plus:0})") 将棋ウォーズ 3分
        b-dropdown-item(@click="rule_set({main_second: null,  range_low:10, extra_second: 0,  every_plus:0})") 将棋ウォーズ 10秒
        b-dropdown-item(:separator="true")
        b-dropdown-item(@click="rule_set({main_second: 60*5,  range_low:0,  extra_second: 0,  every_plus:0})") 将棋クエスト 5分
        b-dropdown-item(@click="rule_set({main_second: 60*2,  range_low:0,  extra_second: 0,  every_plus:0})") 将棋クエスト 2分
        b-dropdown-item(:separator="true")
        b-dropdown-item(@click="rule_set({main_second: 60*5,  range_low:0,  extra_second: 0,  every_plus:5})") ABEMA フィッシャールール 5分 +5秒/手
        b-dropdown-item(:separator="true")
        b-dropdown-item(@click="rule_set({main_second: 60*1,  range_low:30, extra_second: 0,  every_plus:0})") 将棋倶楽部24 早指  1分切ると1手30秒
        b-dropdown-item(@click="rule_set({main_second: null,  range_low:30, extra_second: 60, every_plus:0})") 将棋倶楽部24 早指2 1手30秒 猶予1分
        b-dropdown-item(@click="rule_set({main_second: 60*15, range_low:60, extra_second: 0,  every_plus:0})") 将棋倶楽部24 15分  切ると1手60秒
        b-dropdown-item(@click="rule_set({main_second: 60*30, range_low:60, extra_second: 0,  every_plus:0})") 将棋倶楽部24 長考  30分切ると1手60秒

      //- .item(@click="timer_handle")
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
      b-button(@click="chess_clock.main_second_set(3)") 両方残り3秒
    b-message
      | 1手毎に{{chess_clock.params.every_plus}}秒加算
</template>

<script>
import { ChessClock } from "../actb_app//models/chess_clock.js"
import Location from "shogi-player/src/location.js"

import { support } from "./support.js"
import { store   } from "./store.js"
import the_footer from "./the_footer.vue"

export default {
  store,
  name: "xclock_app",
  mixins: [
    support,
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
          onConfirm: () => { this.pause_handle() },
        })
      },
      second_decriment_hook: (v, d, r) => {
        if (r === 0 && d >= 1) {
          this.say(`${d}分`)
        } else if (v === 10 || v === 20 || v === 30) {
          this.say(`${v}秒`)
        } else if (v <= 5) {
          this.say(`${v}`)
        }
      },
    })
  },
  beforeDestroy() {
    this.chess_clock.timer_stop()
  },
  methods: {
    pause_handle() {
      this.sound_play("click")
      this.say("ストップ")
      this.chess_clock.timer_stop2()
    },
    play_handle() {
      this.sound_play("start")
      this.say("対局かいし")
      this.chess_clock.timer_start()
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
  // @extend %padding_top_for_secondary_header
  // margin-bottom: $margin_bottom
  .screen_container
    height: 100vh
    border: 1px solid hsla(200, 50%, 50%, 1.0)

    flex-direction: column
    justify-content: space-between
    align-items: center

    .level
      height: 100%
      width: 100%
      // border: 8px solid hsla(200, 50%, 50%, 1.0)
      .level-item
        // border: 8px solid hsla(150, 50%, 50%, 1.0)
        flex-direction: column
        justify-content: space-between
        align-items: center

        height: 100%
        width: 50%

        .mark_div
          height: 4vh
          width: 100%
          // background-color: darken($white, 4%)

        // border: 1px solid hsla(0, 50%, 50%, 1.0)
        .digit_div
          // border: 8px solid hsla(64, 50%, 50%, 1.0)
          flex-direction: column
          justify-content: center
          align-items: center

          height: 100%
          width: 100%
          .title
            font-size: 10vh
            // input
            //   height: 25vh
            //   font-size: 2rem

        .text
          vertical-align: middle
          display: inline

        .tiisame
          input
            width: 3rem

        &.sclock_inactive
          // background-color: darken($white, 0%)
          .title
            color: lighten($text, 40%)
        &.sclock_active
          .mark_div
            background-color: $primary

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
