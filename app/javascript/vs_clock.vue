<template lang="pug">
.vs_clock
  .columns
    .column
      .has-text-centered.page_title
        | 時計
      .box.main_box.has-text-centered.line_break_off.is-shadowless
        .lap_time
          span.current_digit(@click="use_seconds_input_dialog(0)")
            | {{time_format2(0)}}
          span.has-text-grey-lighter
            |
            | -
          span.current_digit(@click="use_seconds_input_dialog(1)")
            | {{time_format2(1)}}
        .buttons.is-centered.start_or_stop
          template(v-if="mode === 'standby'")
            button.button.is-large.is-primary.other_button(@click="start_handle")
              b-icon(icon="play" size="is-large")

          template(v-if="mode !== 'standby'")
            button.button.is-large.is-danger.other_button(@click="stop_handle")
              b-icon(icon="stop" size="is-large")

        template(v-if="mode === 'playing'")
          .buttons.is-centered.ox_buttons
            button.button.is-large.is-primary.is-outlined.ox_button(@click="lap_handle('o')" ref="o_button_ref") ○
            button.button.is-large.is-primary.is-outlined.ox_button(@click="lap_handle('x')" ref="x_button_ref") ×

        template(v-if="mode !== 'playing'")
          button.button.is-large.other_button(@click="reset_handle" key="reset_key" v-if="total_with_lap_seconds !== 0") リセット

  .columns
    .column
      .box.content.has-text-grey.is-size-7
        b-field(label="ショートカット" custom-class="is-small")
          table.table.is-narrow
            tr
              th p k Space
              td 開始 / 停止
            tr
              th o Enter
              td 正解
            tr
              th x
              td 不正解
            tr
              th z
              td 1つ前に戻す
            tr
              th r
              td 最後のタイムだけリセット
            tr
              th t
              td 最後の解答の正誤を反転する

</template>

<script>
const HYPHEN_SEP = " "

import dayjs from "dayjs"

import stopwatch_data_retention from './stopwatch_data_retention.js'
import vs_clock_memento_list from './vs_clock_memento_list.js'
import vs_clock_browser_setting from './vs_clock_browser_setting.js'

import MemoryRecord from 'js-memory-record'

class AnswerInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "o", char_name: "o", name: "正解",   },
      { key: "x", char_name: "x", name: "不正解", },
    ]
  }
}

export default {
  name: "vs_clock",
  mixins: [
    stopwatch_data_retention,
    vs_clock_memento_list,
    vs_clock_browser_setting,
  ],
  data() {
    return {
      current_track: null,
      rows: null,
      mode: "standby",
      interval_id: null,
      format_index: 0,
      drop_seconds: null,
      generate_max: null,
      book_title: null,
      log_modal: null,
      timeout_sec: null,
      total_timeout_min: null,
      users: null,
    }
  },

  created() {
    this.users = [0, 1].map(() => {
      return {
        use_seconds: 0,
      }
    })
    
    
    this.shortcut_key_assign()
  },

  beforeDestroy() {
    this.clear_interval_safe()
  },

  methods: {
    shortcut_key_assign() {
      document.addEventListener("keydown", e => {
        if (e.metaKey || e.altKey || e.ctrlKey || e.shiftKey) {
          return
        }
        if (this.input_focus_p()) {
          return
        }

        let processed = false
        if (e.key === "x") {
          this.lap_handle('x')
          processed = true
        }
        if (e.key === "o" || e.code === "Enter") {
          this.lap_handle('o')
          processed = true
        }
        if (e.key === "z") {
          this.revert_handle()
          processed = true
        }
        if (e.key === "r") {
          this.rap_reset()
          processed = true
        }
        if (e.key === "p" || e.key === "k" || e.code === "Space") {
          this.pause_handle()
          processed = true
        }
        if (e.key === "t") {
          this.toggle_handle()
          processed = true
        }
        if (processed) {
          e.preventDefault()
        }
      }, false)
    },

    input_focus_p() {
      const dom = document.activeElement
      return dom.tagName === "TEXTAREA" || dom.tagName === "INPUT"
    },

    use_seconds_input_dialog(location) {
      this.$buefy.dialog.prompt({
        message: "分",
        confirmText: "更新",
        cancelText: "キャンセル",
        inputAttrs: { type: 'text', value: (this.users[location].use_seconds / 60) + "" },
        onConfirm: (value) => this.users[location].use_seconds = parseFloat(value) * 60,
      })
    },

    pause_handle() {
      if (this.mode === "standby") {
        this.start_handle()
      } else {
        this.stop_handle()
      }
    },

    start_handle() {
      if (!this.last_quest_exist_p) {
        return
      }

      // this.safe_talk("スタート")
      this.mode = "playing"
      this.clear_interval_safe()
      this.interval_id = setInterval(this.step_next, 1000)
      this.sound_play("start")
      this.track_next()
      this.memento_create("start")
      this.alive_notice()
    },

    button_focus(o_or_x) {
      this.$nextTick(() => this.$refs[`${o_or_x}_button_ref`].focus())
    },

    stop_handle() {
      // this.safe_talk("ストップ")
      this.mode = "standby"
      this.clear_interval_safe()
      this.memento_create("stop")
      this.alive_notice()
    },

    alive_notice() {
      this.$http.post(this.$root.$options.post_path, {
        mode: this.mode,
        summary: this.summary,
        book_title: this.book_title,
      }).then(response => {
      }).catch(error => {
      })
    },

    stop_if_playing() {
      if (this.mode === "playing") {
        this.stop_handle()
      }
    },

    reset_handle() {
      this.rows = []
      this.use_seconds = 0
    },

    toggle_handle() {
      const last = _.last(this.rows)
      if (last) {
        if (last.o_or_x === "x") {
          last.o_or_x = "o"
        } else {
          last.o_or_x = "x"
        }
        const answer_info = AnswerInfo.fetch(last.o_or_x)
        this.notice(`最後の解答を${answer_info.name}に変更しました`)
      }
    },

    notice(message) {
      this.$buefy.toast.open({message: message, position: "is-bottom"})
      this.safe_talk(message)
    },

    warning_notice(message) {
      this.$buefy.toast.open({message: message, position: "is-top", type: "is-danger"})
      this.talk(message)
    },

    ox_char_to_human_ox(ox) {
      if (ox === "x") {
        last.o_or_x = "o"
      } else {
        last.o_or_x = "x"
      }
    },

    time_format2(location) {
      let format = null
      if ((seconds / 60) >= 60) {
        format = "HH:mm:ss"
      } else {
        format = "m:ss"
      }
      return dayjs().startOf("year").set("seconds", seconds).format(format)
    },
    
    time_format(seconds) {
      let format = null
      if ((seconds / 60) >= 60) {
        format = "HH:mm:ss"
      } else {
        format = "m:ss"
      }
      return dayjs().startOf("year").set("seconds", seconds).format(format)
    },

    ja_time_format(seconds) {
      let format = null
      if ((seconds / 60) >= 60) {
        // if (seconds % 60 > 0) {
        //   seconds += 60         // 秒を切り上げして分+1
        // }
        // format = "HH:mm"
        format = "h時間m分s秒"
      } else {
        // format = "mm:ss"
        format = "m分s秒"
      }
      return dayjs().startOf("year").set("seconds", seconds).format(format)
    },

    log_time_format(str) {
      return dayjs(str).format("YYYY-MM-DD")
    },

    lap_handle(o_or_x) {
      if (this.mode === "playing") {
        this.button_focus(o_or_x)
        this.rows.push({...this.new_quest, o_or_x: o_or_x})

        this.current_track += 1
        this.use_seconds = 0
        this.sound_play(o_or_x)

        this.track_next()
      }
    },

    track_next() {
      if (this.last_quest_exist_p) {
        this.safe_talk(this.quest_name(this.new_quest))
      } else {
        this.stop_handle()
        this.notice(`おわりました`)
      }
    },

    revert_handle() {
      if (this.rows.length >= 1) {
        this.rows.pop()
        this.current_track -= 1
        this.use_seconds = 0
        this.notice(`1つ前に戻しました`)
      }
    },

    rap_reset() {
      this.use_seconds = 0
      this.notice(`最後のタイムだけリセットしました`)
    },

    clear_interval_safe() {
      if (this.interval_id) {
        clearInterval(this.interval_id)
        this.interval_id = null
      }
    },

    step_next() {
      this.use_seconds += 1
    },

    quest_name(row) {
      const v = this.quest_name_get(row)
      if (v === undefined) {
        return "?"
      }
      return v
    },

    quest_name_get(row) {
      return row.track
    },

    human_minute(key) {
      let s = null
      if (key === '0') {
        s = `1分未満`
      } else {
        s = `${key}分以上`
      }
      return s
    },

    o_or_x_to_s(row, o, x) {
      let s = null
      if (row.o_or_x === 'o') {
        s = o
      } else {
        s = x
      }
      return s
    },

    count_of(key) {
      let count = 0
      if (key in this.ox_group) {
        count = this.ox_group[key].length
      }
      return count
    },

    data_restore_from_hash(hash) {
      this.current_track  = hash.current_track || 1
      this.use_seconds    = hash.use_seconds || 0
      this.rows           = hash.rows || []
      this.format_index   = (hash.format_index != null) ? hash.format_index : 0,
      this.generate_max   = hash.generate_max || 200
      this.drop_seconds   = hash.drop_seconds || 60
      this.book_title     = hash.book_title || "詰将棋用ストップウォッチ"
      this.timeout_sec = hash.timeout_sec || 0
      this.total_timeout_min = hash.total_timeout_min || 0
    },

    data_restore_from_url_or_storage_after_hook() {
      if (location.hash || this.$route.query.restore_code) {
        console.log(`ハッシュ付きのURLから復元したので綺麗なURL ${this.location_url_without_hash()} に移動する`)
        location.href = this.location_url_without_search_and_hash()
      }
    },

    safe_talk(message, options = {}) {
      if (this.browser_setting.sound_silent_p) {
        return
      }
      this.talk(message, options)
    },
  },

  watch: {
    // current_track() { this.data_save_to_local_storage() },
  },

  mounted() {
  },

  computed: {
    local_storage_key() {
      return "vs_clock"
    },

    ox_group() {
      return _.groupBy(this.rows, e => e.o_or_x)
    },

    // 正解のみ分グループ
    o_group_by_min() {
      return _.groupBy(this.ox_group["o"], e => Math.floor(e.use_seconds / 60))
    },

    current_min() {
      return Math.floor(this.use_seconds / 60)
    },

    current_sec() {
      return this.use_seconds % 60
    },

    save_hash() {
      return {
        current_track:  this.current_track,
        use_seconds:    this.use_seconds,
        rows:           this.rows,
        format_index:   this.format_index,
        book_title:     this.book_title,
        timeout_sec:    this.timeout_sec,
        total_timeout_min:    this.total_timeout_min,
      }
    },
  },
}
</script>

<style lang="sass">
@import url("https://fonts.googleapis.com/css?family=Roboto+Mono&display=swap")

.vs_clock
  touch-action: manipulation

  .page_title
    cursor: pointer
    font-weight: bold

  .main_box
    margin-top: 0.6rem
    background-color: hsl(0, 0%, 98%)

    position: relative
    .options_doropdown
      position: absolute
      top: 0.5rem
      left: 0.5rem
    .helper_button
      position: absolute
      top: 0.5rem
      right: 0.5rem

    .lap_time
      margin-top: 1.2rem
      font-size: 5rem
      line-height: 100%
      .quest_digit
        cursor: pointer
      .current_digit
        cursor: pointer
        margin-left: 1rem
      .quest_digit, .current_digit
        font-family: 'Roboto mono', monospace

    .total_time
      font-size: 1rem

    .start_or_stop
      margin-top: 0.9rem

    .other_button
      width: 8rem !important

    .ox_buttons
      margin-top: 1.5rem
      margin-bottom: 0.5rem
      width: 100%
      .button
        width: 45%

  .compact
    line-height: 100%

  .result_body
    .tab-item
      font-family: Osaka-mono, "Osaka-等幅", "ＭＳ ゴシック", "Courier New", Consolas, monospace
      white-space: pre-wrap
      line-height: 105%
      font-size: 0.8rem

  .log_button_container
    margin-top: 1.2em

.vs_clock_log_dialog
  table
    tbody
      tr
        &:hover
          cursor: pointer
</style>
