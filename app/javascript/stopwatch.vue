<template lang="pug">
.stopwatch
  .columns
    .column.is-half
      .has-text-centered.page_title
        | 詰将棋タイムアタック用ストップウォッチ
      .box.main_box.has-text-centered.nowrap.is-shadowless
        b-dropdown.is-pulled-left
          button.button(slot="trigger")
            b-icon(icon="menu-down")
          b-dropdown-item(@click="rap_reset") 最後のタイムだけリセット
          b-dropdown-item(@click="revert_handle") 1つ前に戻す
          b-dropdown-item(@click="reset_by_x") 不正解だけ再テスト
          b-dropdown-item(@click="reset_by_x_with_n_seconds") 不正解と指定秒以上だった問の再テスト

        .lap_time
          span.number_span(@click="track_input_dialog")
            | {{quest_name(new_quest)}}
          |
          | -
          | {{time_format(lap_counter)}}
        .has-text-grey-light.total_time
          b-tooltip(label="トータル" position="is-right")
            | {{ja_time_format(total_with_lap_seconds)}}
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
          button.button.is-large.other_button(@click="reset_handle" key="reset_key" :disabled="total_with_lap_seconds === 0 && false") リセット

      template(v-if="quest_list.length === 0 || true")
        .field
          label.label
            | 問題番号
            | &nbsp;
            a.is-link(@click.prevent="current_track = 1")
              | (1に設定)
          .control
            b-numberinput(v-model.number="current_track" :min="1" controls-position="compact" :expanded="true" size="is-large")

      .field
        .control
          textarea.textarea(v-model.trim="quest_text" rows="1" placeholder="スペース区切りで並べると問題を置き換える")
          a.is-link.is-size-7(@click.prevent="quest_text_clear") クリア
          | &nbsp;
          a.is-link.is-size-7(@click.prevent="quest_text_sort") ソート
          | &nbsp;
          b-tooltip(label="重複をなくします" position="is-bottom")
            a.is-link.is-size-7(@click.prevent="quest_text_uniq") ユニーク
          | &nbsp;
          a.is-link.is-size-7(@click.prevent="quest_text_shuffle") シャッフル

    .column
      b-tabs.result_body(expanded v-model="format_index")
        template(v-for="(value, key) in format_all")
          b-tab-item(:label="key")
            a.is-pulled-right.clipboard_copy(@click.stop.prevent="clipboard_copy({text: value})")
              b-tooltip(label="クリップボードにコピー" position="is-left")
                b-icon(icon="clipboard-outline" size="is-small")
            | {{value}}

      template(v-if="rows.length >= 1 || true")
        .has-text-centered
          a.button.is-info.is-rounded(:href="twitter_url" target="_blank")
            | &nbsp;
            b-icon(icon="twitter" size="is-small")
            | &nbsp;
            | ツイート

      template(v-if="memento_list.length >= 1")
        .box.memento_box
          .is-size-7
            b-tooltip(label="クリックでそのとき時点に戻れる (ストップしたときに反映)")
              b ログ
          ul
            template(v-for="row in memento_list")
              li.is-size-7
                a.has-text-grey(@click.prevent="memento_restore(row)")
                  | {{row.time}}
                  | &nbsp;
                  | {{row.summary}}
  .columns
    //- .column
    //-   article.message.is-primary.is-size-7
    //-     .message-header
    //-       | 使い方
    //-     .message-body.has-text-left
    //-       .content
    //-         ol
    //-           li 文章

    .column.is-hidden-touch
      .box.content.has-text-grey.is-size-7
        h6 ショートカット
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
            th z Backspace
            td 1つ前に戻す
          tr
            th r
            td 最後のタイムだけリセット
</template>

<script>
import dayjs from "dayjs"
import { Howl, Howler } from 'howler'

import mp3_o     from "oto_logic/Quiz-Correct_Answer02-1.mp3"
import mp3_x     from "oto_logic/Quiz-Wrong_Buzzer02-1.mp3"
import mp3_start from "oto_logic/Quiz-Question03-1.mp3"

import stopwatch_data_retention from './stopwatch_data_retention.js'

const SOUND_VOLUME = 0.2
const X_MARK = "x"
const O_MARK = "o"

export default {
  name: "stopwatch",
  mixins: [stopwatch_data_retention],
  data() {
    return {
      current_track: null,
      lap_counter: null,
      rows: null,
      quest_text: null,
      mode: "standby",
      interval_id: null,
      format_index: 0,
      sound_objects: {},
      drop_seconds: 60,
      memento_list: [],
    }
  },

  created() {
    this.shortcut_key_assign()
  },

  beforeDestroy() {
    this.clear_interval_safe()
  },

  methods: {
    shortcut_key_assign() {
      document.addEventListener("keydown", e => {
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
        if (e.key === "z" || e.code === "Backspace") {
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
        if (processed) {
          e.preventDefault()
        }
      }, false)
    },

    input_focus_p() {
      const dom = document.activeElement
      return dom.tagName === "TEXTAREA" || dom.tagName === "INPUT"
    },

    quest_text_clear() {
      this.quest_text = ""
    },

    quest_text_sort() {
      this.quest_text = _.sortBy(this.quest_list, [e => parseInt(e)]).join(" ")
    },

    quest_text_uniq() {
      this.quest_text = _.uniq(this.quest_list).join(" ")
    },

    quest_text_shuffle() {
      this.quest_text = _.shuffle(this.quest_list).join(" ")
    },

    track_input_dialog() {
      this.$dialog.prompt({
        message: "問題番号",
        confirmText: "更新",
        cancelText: "キャンセル",
        inputAttrs: { type: 'number', value: this.current_track, min: 1 },
        onConfirm: (value) => this.current_track = value,
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

      // this.talk("スタート")
      this.mode = "playing"
      this.clear_interval_safe()
      this.interval_id = setInterval(this.step_next, 1000)
      this.sound_play(mp3_start)
      this.track_next()
    },

    button_focus(o_or_x) {
      this.$nextTick(() => this.$refs[`${o_or_x}_button_ref`].focus())
    },

    stop_handle() {
      // this.talk("ストップ")
      this.mode = "standby"
      this.clear_interval_safe()
      this.memento_create()
    },

    stop_if_playing() {
      if (this.mode === "playing") {
        this.stop_handle()
      }
    },

    reset_handle() {
      this.rows = []
      this.lap_counter = 0
    },

    time_format(seconds) {
      let format = null
      if ((seconds / 60) >= 60) {
        format = "hh:mm:ss"
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
        // format = "hh:mm"
        format = "h時間m分s秒"
      } else {
        format = "mm:ss"
        // format = "m分s秒"
      }
      return dayjs().startOf("year").set("seconds", seconds).format(format)
    },

    lap_handle(o_or_x) {
      if (this.mode === "playing") {
        this.button_focus(o_or_x)
        this.rows.push({...this.new_quest, o_or_x: o_or_x})

        this.current_track += 1
        this.lap_counter = 0
        this.sound_play(this.sound_src(o_or_x))

        this.track_next()
      }
    },

    track_next() {
      if (this.last_quest_exist_p) {
        this.talk(this.quest_name(this.new_quest))
      } else {
        this.stop_handle()
        this.talk("おわりました")
      }
    },

    sound_src(o_or_x) {
      let src = null
      if (o_or_x === "o") {
        src = mp3_o
      } else {
        src = mp3_x
      }
      return src
    },

    revert_handle() {
      if (this.rows.length >= 1) {
        this.rows.pop()
        this.current_track -= 1
        this.lap_counter = 0
      }
    },

    rap_reset() {
      this.lap_counter = 0
    },

    sound_play(src, volume = SOUND_VOLUME) {
      if (false) {
        (new Audio(src)).play()
      }

      if (false) {
        new Howl({src: src, autoplay: true, volume: SOUND_VOLUME})
      }

      if (true) {
        if (!this.sound_objects[src]) {
          this.$set(this.sound_objects, src, new Howl({src: src, autoplay: true, volume: volume}))
        }
        const obj = this.sound_objects[src]
        obj.stop()
        obj.seek(0)
        obj.play()
      }
    },

    clear_interval_safe() {
      if (this.interval_id) {
        clearInterval(this.interval_id)
        this.interval_id = null
      }
    },

    step_next() {
      this.lap_counter += 1
    },

    quest_name(row) {
      const v = this.quest_name_get(row)
      if (v === undefined) {
        return "?"
      }
      return v
    },

    quest_name_get(row) {
      if (this.quest_list.length >= 1) {
        return this.quest_list[row.index]
      }
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
      this.lap_counter    = hash.lap_counter || 0
      this.rows           = hash.rows || []
      this.quest_text     = hash.quest_text || ""
      this.format_index   = hash.format_index || 0
    },

    reset_by_x() {
      reset_by_x_with_drop(null)
    },

    reset_by_x_with_drop(drop_seconds) {
      this.stop_if_playing()

      let list = []

      list = _.concat(list, this.x_list)

      if (drop_seconds) {
        _.each(this.rows, e => {
          if (e.lap_counter >= drop_seconds) {
            list.push(this.quest_name(e))
          }
        })
      }

      if (list.length >= 1) {
        this.quest_text = list.join(" ")

        this.quest_text_uniq()
        this.quest_text_sort()

        this.current_track = 1
        this.reset_handle()
      }
    },

    reset_by_x_with_n_seconds() {
      this.$dialog.prompt({
        message: "秒",
        confirmText: "OK",
        cancelText: "キャンセル",
        inputAttrs: { type: 'number', value: this.drop_seconds, },
        onConfirm: (value) => {
          this.drop_seconds = value
          this.reset_by_x_with_drop(value)
        },
      })
    },

    memento_create() {
      this.memento_list.push({
        time: dayjs().format("YYYY-MM-DD hh:mm:ss"),
        summary: this.summary,
        enc_base64: this.enc_base64,
      })
      this.memento_list = _.takeRight(this.memento_list, 10)
    },

    memento_restore(row) {
      this.data_restore_from_base64(row.enc_base64)
    },
  },

  watch: {
    current_track() { this.data_save() },
    quest_text()    { this.data_save() },
    rows()          { this.data_save() },
    format_index()  { this.data_save() },
    drop_seconds()  { this.data_save() },

    current_min(v) {
      if (v >= 1) {
        this.talk(`${v}分経過`)
      }
    },
  },

  mounted() {
  },

  computed: {
    last_quest_exist_p() {
      return this.quest_name_get(this.new_quest)
    },

    local_storage_key() {
      return "stopwatch"
    },

    new_quest() {
      return {
        index: this.rows.length,
        track: this.current_track,
        lap_counter: this.lap_counter,
      }
    },

    twitter_url() {
      return `https://twitter.com/intent/tweet?text=${encodeURIComponent(this.tweet_body)}`
    },

    tweet_body() {
      // return _.concat(this.rows, this.new_quest).map(e => `${this.quest_name(e)} - ${this.time_format(e.lap_counter)}`).join("\n")
      return Object.values(this.format_all)[this.format_index]
    },

    quest_list() {
      if (this.quest_text !== "") {
        return this.quest_text.split(/[\s,]+/)
      } else {
        return []
      }
    },

    ox_group() {
      return _.groupBy(this.rows, e => e.o_or_x)
    },

    // 正解のみ分グループ
    o_group_by_min() {
      return _.groupBy(this.ox_group["o"], e => Math.floor(e.lap_counter / 60))
    },

    current_min() {
      return Math.floor(this.lap_counter / 60)
    },

    current_sec() {
      return this.lap_counter % 60
    },

    // 間違った問題リスト
    x_list() {
      return (this.ox_group['x'] || []).map(e => this.quest_name(e))
    },

    total_seconds() {
      return _.sumBy(this.rows, e => e.lap_counter)
    },

    total_with_lap_seconds() {
      return this.total_seconds + this.lap_counter
    },

    quest_lables() {
      return this.rows.map(e => this.quest_name(e))
    },

    quest_values() {
      return this.rows.map(e => e.lap_counter)
    },

    quest_range() {
      if (this.rows.length >= 1) {
        if (this.quest_list.length === 0) {
          return [this.quest_name(this.rows[0]), this.quest_name(_.last(this.rows))].join("〜")
        }
      }
    },

    rate() {
      if (this.rows.length >= 1) {
        return this.count_of("o") / this.rows.length
      }
    },

    human_rate() {
      if (this.rows.length >= 1) {
        const v = Math.floor(this.rate * 100.0)
        return `正解率${v}%`
      }
    },

    avg() {
      if (this.rows.length >= 1) {
        return this.total_seconds / this.rows.length
      }
    },

    human_avg() {
      if (this.rows.length >= 1) {
        let v = null
        if (this.avg < 60) {
          // v = Math.floor(this.avg * 100) / 100
          // v = `${v}秒`
          v = Math.ceil(this.avg)
          v = `${v}秒`
        } else {
          v = dayjs().startOf("year").set("seconds", this.avg).format("m分s秒")
        }
        return `平均${v}`
      }
    },

    save_hash() {
      return {
        current_track:  this.current_track,
        lap_counter:    this.lap_counter,
        rows:           this.rows,
        quest_text:     this.quest_text,
        format_index:   this.format_index,
      }
    },

    format_all() {
      return {
        "OX":       this.format_type3,
        "Oは省略":  this.format_type2,
        "時間なし": this.format_type1,
        "分毎":     this.format_type4,
      }
    },

    summary() {
      let out = ""
      if (this.quest_range) {
        out += this.quest_range + " "
      }
      out += `計${this.rows.length}問`
      if (this.quest_list.length >= 1) {
        out += `/全${this.quest_list.length}問`
      }
      if (this.human_rate) {
        out += " "
        out += this.human_rate
      }
      out += " "
      out += this.ja_time_format(this.total_seconds)
      if (this.human_avg) {
        out += " "
        out += this.human_avg
      }
      out += "\n"
      return out
    },

    format_type1() {
      let out = ""
      out += this.summary

      _.forIn(this.o_group_by_min, (rows, key) => {
        out += "\n"
        out += this.human_minute(key) + "\n"
        out += rows.map(e => this.quest_name(e)).join(" ")
        out += "\n"
      })

      if ('x' in this.ox_group) {
        out += "\n"
        out += "不正解\n"
        out += this.ox_group['x'].map(e => this.quest_name(e)).join(" ")
        out += "\n"
      }

      return out
    },

    format_type2() {
      return [
        this.summary + "\n",
        this.rows.map(e => this.quest_name(e) + " " + this.time_format(e.lap_counter) + this.o_or_x_to_s(e, "", " " + X_MARK) + "\n").join(""),
      ].join("")
    },

    format_type3() {
      return [
        this.summary + "\n",
        this.rows.map(e => this.o_or_x_to_s(e, O_MARK, X_MARK) + " " + this.quest_name(e) + " - " + this.time_format(e.lap_counter) + "\n").join(""),
      ].join("")
    },

    format_type4() {
      let out = ""
      out += this.summary
      _.forIn(this.o_group_by_min, (rows, key) => {
        out += "\n"
        out += this.human_minute(key) + "\n"
        out += rows.map(e => this.quest_name(e) + " - " + this.time_format(e.lap_counter) + "\n").join("")
      })
      if ("x" in this.ox_group) {
        out += "\n"
        out += "不正解\n"
        out += this.ox_group['x'].map(e => this.quest_name(e) + " - " + this.time_format(e.lap_counter) + "\n").join("")
      }
      return out
    },

  },
}
</script>

<style lang="sass">
.stopwatch
  touch-action: manipulation

  .page_title
    font-weight: bold

  .main_box
    margin-top: 0.6rem
    background-color: hsl(0, 0%, 98%)

    position: relative
    .dropdown
      position: absolute
      top: 0.5rem
      left: 0.5rem

    .lap_time
      margin-top: 1.2rem
      font-size: 5rem
      line-height: 100%
      .number_span
        cursor: pointer

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

  .memento_box
    margin-top: 1.5rem
    a
      &:hover
        text-decoration: underline
</style>
