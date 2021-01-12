<template lang="pug">
.modal-card.ChessClockSettingModal
  header.modal-card-head
    p.modal-card-title
      | 対局時計
  section.modal-card-body
    //////////////////////////////////////////////////////////////////////////////// form
    //- template(v-if="!base.chess_clock.running_p")

    .fields
      //- b-field(custom-class="is-small" label="プリセット")
      //-   b-select(size="is-small" v-model="base.cc_rule_info_key" @input="cc_rule_info_key_input_handle")
      //-     template(v-for="e in base.CcRuleInfo.values")
      //-       option(:value="e.key") {{e.name}}
      b-field(label="持ち時間(分)" custom-class="is-small")
        b-numberinput(controls-position="compact" v-model="base.cc_params.initial_main_min"  :min="0" :max="60*6" :exponential="true")
      b-field(label="1手ごとに加算(秒)" custom-class="is-small")
        b-numberinput(controls-position="compact" v-model="base.cc_params.every_plus"        :min="0" :max="60*60" :exponential="true")
      b-field(label="秒読み" custom-class="is-small")
        b-numberinput(controls-position="compact" v-model="base.cc_params.initial_read_sec"  :min="0" :max="60*60" :exponential="true")
      b-field(label="猶予(秒)" custom-class="is-small")
        b-numberinput(controls-position="compact" v-model="base.cc_params.initial_extra_sec" :min="0" :max="60*60" :exponential="true")

  footer.modal-card-foot
    b-button(@click="close_handle") キャンセル
    b-dropdown(position="is-top-right" @active-change="e => base.cc_dropdown_active_change(e)")
      b-button(slot="trigger" icon-left="menu-up") プリセット
      //- .item(slot="trigger")
      //-   b-icon(icon="menu")
      template(v-for="e in base.CcRuleInfo.values")
        b-dropdown-item(@click="cc_rule_info_key_input_handle(e)") {{e.name}}
    b-button.submit_handle(@click="submit_handle" type="is-primary") 設定する

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
  name: "ChessClockSettingModalApp",
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
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
    submit_handle() {
      this.base.cc_play_handle()

      this.sound_play("click")
      this.$emit("close")
    },
    cc_rule_info_key_input_handle(v) {
      // this.sound_play("click")
      this.base.cc_rule_set3(v)
    },
  },
  computed: {
  },
}
</script>

<style lang="sass">
@import "support.sass"

.STAGE-development
  .ChessClockSettingModal
    .modal-card-body, .field
      border: 1px dashed change_color($primary, $alpha: 0.5)

.ChessClockSettingModal
  .modal-card-body
    padding-top: 0.5rem
  .modal-card-foot
    justify-content: space-between
    .button
      min-width: 8rem
      &.submit_handle
        font-weight: bold

  .field:not(:last-child)
    margin-bottom: 1.5rem

  .dropdown-menu
    z-index: 2
    // .dropdown-content

  .fields
    display: flex
    justify-content: center
    align-items: center
    flex-direction: column
</style>
