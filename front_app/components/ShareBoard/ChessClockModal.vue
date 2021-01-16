<template lang="pug">
.modal-card.ChessClockModal
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title
      | 対局時計
      span.mx-1.has-text-grey.is-size-6(v-if="human_status") {{human_status}}
    template(v-if="!base.chess_clock || !base.chess_clock.running_p")
      b-switch(size="is-small" type="is-primary" v-model="chess_clock_p" @input="chess_clock_switch_handle") 設置
  section.modal-card-body
    template(v-if="!base.chess_clock")
      .has-text-centered.has-text-grey.my-6
        | 使う場合は右上のスイッチを有効にしてください

    template(v-if="base.chess_clock")
      template(v-if="base.chess_clock.running_p")
        .level.is-mobile
          .level-item.has-text-centered(v-if="base.cc_params.initial_main_min >= 0")
            div
              p.heading 持ち時間
              p.title {{base.cc_params.initial_main_min}}分
          .level-item.has-text-centered(v-if="base.cc_params.initial_read_sec >= 1")
            div
              p.heading 秒読み
              p.title {{base.cc_params.initial_read_sec}}秒
          .level-item.has-text-centered(v-if="base.cc_params.initial_extra_sec >= 1")
            div
              p.heading 猶予
              p.title {{base.cc_params.initial_extra_sec}}秒
          .level-item.has-text-centered(v-if="base.cc_params.every_plus >= 1")
            div
              p.heading 1手毎加算
              p.title {{base.cc_params.every_plus}}秒

        hr

        .level.is-mobile
          template(v-for="(e, i) in base.chess_clock.single_clocks")
            .level-item.has-text-centered
              .active_current_bar(:class="e.bar_class" v-if="e.active_p && base.chess_clock.timer")
              div
                p.heading {{e.location.name}}
                p.title.is-4.is-family-monospace
                  span.mx-1(v-if="e.initial_main_sec >= 1 || e.every_plus >= 1") {{e.to_time_format}}
                  span.mx-1(v-if="e.initial_read_sec >= 1") {{e.read_sec}}
                  span.mx-1(v-if="e.initial_extra_sec >= 1") {{e.extra_sec}}

        //- p 持ち時間{{base.cc_params.initial_main_min}}分
        //- p 秒読み{{base.cc_params.initial_read_sec}}秒
        //- p 猶予{{base.cc_params.initial_extra_sec}}秒
        //- p 1手毎加算{{base.cc_params.every_plus}}秒

      .fields(v-if="!base.chess_clock.running_p")
        b-field(horizontal label="持ち時間(分)" custom-class="is-small")
          b-numberinput(expanded controls-position="compact" v-model="base.cc_params.initial_main_min"  :min="0" :max="60*6" :exponential="true")
        b-field(horizontal label="秒読み" custom-class="is-small")
          b-numberinput(expanded controls-position="compact" v-model="base.cc_params.initial_read_sec"  :min="0" :max="60*60" :exponential="true")
        b-field(horizontal label="猶予(秒)" custom-class="is-small")
          b-numberinput(expanded controls-position="compact" v-model="base.cc_params.initial_extra_sec" :min="0" :max="60*60" :exponential="true")
        b-field(horizontal label="1手毎加算(秒)" custom-class="is-small")
          b-numberinput(expanded controls-position="compact" v-model="base.cc_params.every_plus"        :min="0" :max="60*60" :exponential="true")

  footer.modal-card-foot
    b-button(@click="close_handle" icon-left="chevron-left") 戻る
    //- b-button(@click="save_handle") 反映

    template(v-if="base.chess_clock")
      b-dropdown(position="is-top-right" @active-change="e => base.cc_dropdown_active_change(e)" v-if="!base.chess_clock.running_p")
        b-button(slot="trigger" icon-left="menu-up") プリセット
        //- .item(slot="trigger")
        //-   b-icon(icon="menu")
        template(v-for="e in base.CcRuleInfo.values")
          b-dropdown-item(@click="cc_params_set_handle(e)") {{e.name}}

      //- b-button.stop_handle(   @click="stop_handle"   type="is-primary" icon-left="stop")
      //- b-button.pause_handle(  @click="pause_handle"  type="is-primary" icon-left="pause")
      //- b-button.resume_handle( @click="resume_handle" type="is-primary" icon-left="resume")
      //- b-button.play_handle(   @click="play_handle"   type="is-primary" icon-left="play")

      .buttons
        b-button.stop_button(   @click="stop_handle"     icon-left="stop" v-if="base.chess_clock.running_p && !base.chess_clock.timer")

        template(v-if="base.chess_clock.running_p && base.chess_clock.timer")
          b-button.pause_button(  @click="pause_handle"  icon-left="pause" type="is-primary")
        template(v-if="base.chess_clock.running_p && !base.chess_clock.timer")
          b-button.resume_button( @click="resume_handle" icon-left="play-pause")
        template(v-if="!base.chess_clock.running_p")
          b-button.play_button(   @click="play_handle"   icon-left="play")

  //- //////////////////////////////////////////////////////////////////////////////// 実行中
  //- template(v-if="base.chess_clock.running_p")
  //-   .pause_bg(v-if="!base.chess_clock.timer")
  //-   .screen_container.is-flex(:class="{mouse_cursor_hidden: mouse_cursor_hidden}")
  //-     b-icon.controll_button.pause.is-clickable(icon="pause" v-if="base.chess_clock.timer" @click.native="base.cc_pause_handle")
  //-     b-icon.controll_button.resume.is-clickable(icon="play" v-if="!base.chess_clock.timer" @click.native="base.cc_resume_handle")
  //-     b-icon.controll_button.stop.is-clickable(icon="stop" v-if="!base.chess_clock.timer" @click.native="base.cc_stop_handle")
  //-     .level.is-mobile.is-unselectable.is-marginless
  //-       template(v-for="(e, i) in base.chess_clock.single_clocks")
  //-         .level-item.has-text-centered.is-marginless(@pointerdown="base.cc_switch_handle(e)" :class="e.dom_class")
  //-           .active_current_bar(:class="e.bar_class" v-if="e.active_p && base.chess_clock.timer")
  //-           .inactive_current_bar(v-else)
  //-           .wide_container.time_fields.is-flex(:class="[`display_lines-${e.display_lines}`, `text_width-${e.to_time_format.length}`]")
  //-             .field(v-if="e.initial_main_sec >= 1 || e.every_plus >= 1")
  //-               .time_label 残り時間
  //-               .time_value.fixed_font.is_line_break_off
  //-                 | {{e.to_time_format}}
  //-             .field(v-if="e.initial_read_sec >= 1")
  //-               .time_label 秒読み
  //-               .time_value.fixed_font.is_line_break_off
  //-                 | {{e.read_sec}}
  //-             .field(v-if="e.initial_extra_sec >= 1")
  //-               .time_label 猶予
  //-               .time_value.fixed_font.is_line_break_off
  //-                 | {{e.extra_sec}}

  //- //////////////////////////////////////////////////////////////////////////////// form
  //- .debug_container.mt-5(v-if="development_p")
  //-   .buttons.are-small.is-centered
  //-     b-button(@click="base.chess_clock.generation_next(-1)") -1
  //-     b-button(@click="base.chess_clock.generation_next(-60)") -60
  //-     b-button(@click="base.chess_clock.generation_next(1)") +1
  //-     b-button(@click="base.chess_clock.generation_next(60)") +60
  //-     b-button(@click="base.chess_clock.clock_switch()") 切り替え
  //-     b-button(@click="base.chess_clock.timer_start()") START ({{base.chess_clock.running_p}})
  //-     b-button(@click="base.chess_clock.timer_stop()") STOP
  //-     b-button(@click="base.chess_clock.params.every_plus = 5") フィッシャールール
  //-     b-button(@click="base.chess_clock.params.every_plus = 0") 通常ルール
  //-     b-button(@click="base.chess_clock.reset()") RESET
  //-     b-button(@click="base.chess_clock.main_sec_set(3)") 両方残り3秒
  //-     input(type="range" v-model.number="base.chess_clock.speed")
  //-     | スピード {{base.chess_clock.speed}}
  //-   b-message
  //-     p 1手毎に{{base.chess_clock.params.every_plus}}秒加算
  //-     p mouse_cursor_p: {{mouse_cursor_p}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "ChessClockModalApp",
  mixins: [
    support_child,
  ],
  data() {
    return {
    }
  },
  created() {
  },
  mounted() {
  },
  beforeDestroy() {
  },
  methods: {
    chess_clock_switch_handle(v) {
      this.sound_play("click")
      if (v) {
        this.toast_ok("置きました")
        this.base.cc_create()
      } else {
        this.toast_ok("捨てました")
        this.base.cc_destroy()
      }
      this.base.chess_clock_share()
    },

    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },

    play_handle() {
      this.__assert__(!this.base.chess_clock.running_p)
      this.sound_play("click")
      this.base.cc_params_apply()
      this.base.cc_play_handle()
      this.base.chess_clock_share()
      this.toast_ok("スタート！")
      // this.$emit("close")
    },
    stop_handle() {
      this.sound_play("click")
      if (this.base.chess_clock.running_p) {
        this.toast_ok("リセットしました")
        this.base.cc_stop_handle()
      this.base.chess_clock_share()
      } else {
        this.toast_ok("すでにリセットしています")
      }
    },
    pause_handle() {
      this.sound_play("click")
      this.base.cc_pause_handle()
      this.base.chess_clock_share()
      this.toast_ok("一時停止しました")
    },
    resume_handle() {
      this.sound_play("click")
      this.base.cc_resume_handle()
      this.base.chess_clock_share()
      this.toast_ok("再開しました")
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
    chess_clock_p: {
      get()  { return !!this.base.chess_clock },
      set(v) {},
    },
    human_status() {
      let v = null
      if (this.base.chess_clock) {
        if (this.base.chess_clock.running_p) {
          if (this.base.chess_clock.timer) {
            v = "動作中"
          } else {
            v = "一時停止中"
          }
        } else {
          v = "停止中"
        }
      }
      return v
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

  .fields
    +tablet
      .field
        align-items: center
        .field-label.is-small
          padding-top: 0
</style>
