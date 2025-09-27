<template lang="pug">
.StopwatchApp
  StopwatchSidebar(:base="base")
  StopwatchNavbar(:base="base")
  MainSection
    .container
      .columns
        .column.is-half
          .box.main_box.is_line_break_off.is-shadowless.has-background-white-bis
            .has-text-centered
              .lap_time
                span.quest_digit(@click="track_input_dialog")
                  | {{quest_name(new_quest)}}
                span.has-text-grey-lighter
                  |
                  | -
                span.current_digit(@click="lap_counter_input_dialog")
                  | {{time_format(lap_counter)}}
              .has-text-grey-light.total_time.mt-2
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
                  button.button.is-large.is-primary.is-outlined(@click="lap_handle('o')" ref="o_button_ref") ○
                  button.button.is-large.is-primary.is-outlined(@click="lap_handle('x')" ref="x_button_ref") ×

              template(v-if="mode !== 'playing'")
                button.button.is-large.other_button(@click="reset_handle" key="reset_key" v-if="total_with_lap_seconds !== 0") リセット

          template(v-if="mode === 'standby'")
            template(v-if="quest_list.length === 0 || true")
              .field
                label.label
                  | 問題番号
                  a.mx-1.is-link(@click.prevent="current_track = 1") (1に設定)
                .control
                  b-numberinput(v-model.number="current_track" :min="1" controls-position="compact" :expanded="true" :exponential="true")

          .field.mt-5(v-if="mode === 'standby'")
            .control
              textarea.textarea(v-model.trim="quest_text" rows="3" placeholder="スペース区切りで並べると問題を置き換える")
              a.mx-1.is-link.is-size-7(@click.prevent="quest_text_clear") クリア
              a.mx-1.is-link.is-size-7(@click.prevent="quest_text_sort") ソート
              a.mx-1.is-link.is-size-7(@click.prevent="quest_text_uniq") ユニーク
              a.mx-1.is-link.is-size-7(@click.prevent="quest_text_shuffle") シャッフル
              a.mx-1.is-link.is-size-7(@click.prevent="quest_text_reverse") 反転
              a.mx-1.is-link.is-size-7(@click.prevent="quest_generate") 生成

          .columns.mt-3(v-if="mode === 'standby'")
            .column
              b-field(label="1問毎のタイムアウト(秒)" expanded)
                b-numberinput(v-model.number="timeout_sec" :min="0" step="1" controls-position="compact" :expanded="true" :exponential="true")
            .column
              b-field(label="全体の制限時間(分)" expanded)
                b-numberinput(v-model.number="total_timeout_min" :min="0" step="1" controls-position="compact" :expanded="true" :exponential="true")

        .column
          b-tabs.result_body(expanded v-model="format_index" @input="sfx_play_click()")
            template(v-for="(value, key) in format_all")
              b-tab-item(:label="key")
                a.is-pulled-right.clipboard_copy(@click.stop.prevent="copy_handle(value)")
                  b-icon(icon="clipboard-plus-outline")
                | {{value}}

          template(v-if="rows.length >= 1")
            .has-text-centered
              TweetButton(:body="tweet_body" @after_click="sfx_play_click()")

  .section(v-if="development_p")
    .container.is-fluid
      StopwatchDebugPanels(:base="base")
</template>

<script>
const HYPHEN_SEP = " "
const TITLE_DEFAULT = "詰将棋用ストップウォッチ"

import _ from "lodash"
import dayjs from "dayjs"

import mod_storage_legacy from './mod_storage_legacy.js'
import mod_memento_list from './mod_memento_list.js'
import { support_parent } from './support_parent.js'
import { mod_keyboard } from './mod_keyboard.js'
import { mod_sidebar } from './mod_sidebar.js'
import { IntervalRunner } from '@/components/models/interval_runner.js'

import PermalinkModal from './PermalinkModal.vue'
import HistoryModal   from './HistoryModal.vue'
import KeyboardModal  from './KeyboardModal.vue'

import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

class AnswerInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "o", char_name: "o", name: "正解",   },
      { key: "x", char_name: "x", name: "不正解", },
    ]
  }
}

export default {
  name: "StopwatchApp",
  mixins: [
    mod_storage_legacy,
    mod_memento_list,
    support_parent,
    mod_keyboard,
    mod_sidebar,
  ],
  data() {
    return {
      current_track: null,
      lap_counter: null,
      rows: null,
      quest_text: null,
      mode: "standby",
      interval_runner: new IntervalRunner(this.step_next),
      format_index: 0,
      drop_seconds: null,
      generate_max: null,
      book_title: null,
      timeout_sec: null,
      total_timeout_min: null,
    }
  },

  created() {
    this.data_restore_from_url_or_storage()
  },

  beforeDestroy() {
    this.interval_runner.stop()
  },

  methods: {
    copy_handle(text) {
      this.sfx_play_click()
      this.clipboard_copy(text)
    },

    parmalink_modal_show() {
      this.sidebar_p = false
      this.sfx_play_click()
      this.modal_card_open({
        component: PermalinkModal,
        props: { base: this },
      })
    },

    history_modal_show() {
      this.sidebar_p = false
      this.sfx_play_click()
      this.modal_card_open({
        component: HistoryModal,
        props: { base: this },
      })
    },

    keyboard_modal_show() {
      this.sidebar_p = false
      this.sfx_play_click()
      this.modal_card_open({
        component: KeyboardModal,
        props: { base: this },
      })
    },

    quest_text_clear() {
      this.sfx_play_click()
      this.quest_text = ""
    },

    quest_text_sort() {
      this.sfx_play_click()
      this.quest_text = _.sortBy(this.quest_list, [e => parseInt(e)]).join(" ")
    },

    quest_text_uniq() {
      this.sfx_play_click()
      this.quest_text = _.uniq(this.quest_list).join(" ")
    },

    quest_text_shuffle() {
      this.sfx_play_click()
      this.quest_text = _.shuffle(this.quest_list).join(" ")
    },

    quest_text_reverse() {
      this.sfx_play_click()
      this.quest_text = _.reverse(this.quest_list.slice()).join(" ")
    },

    quest_generate() {
      this.sfx_play_click()
      this.$buefy.dialog.prompt({
        title: "連番生成",
        message: "何問ありますか？",
        confirmText: "生成",
        cancelText: "キャンセル",
        inputAttrs: { type: 'number', value: this.generate_max, min: 0 },
        onCancel: () => this.sfx_play_click(),
        onConfirm: (value) => {
          this.sfx_play_click()
          this.generate_max = parseInt(value, 10)
          this.quest_text = [...Array(this.generate_max).keys()].map(i => 1 + i).join(" ")
        },
      })
    },

    book_title_input_dialog() {
      this.sfx_play_click()
      this.$buefy.dialog.prompt({
        title: "タイトル",
        confirmText: "更新",
        cancelText: "キャンセル",
        inputAttrs: { type: 'text', value: this.book_title, required: false },
        onCancel: () => this.sfx_play_click(),
        onConfirm: value => {
          this.book_title = _.trim(value) || TITLE_DEFAULT
          this.sfx_play_click()
        },
      })
    },

    track_input_dialog() {
      this.sfx_play_click()
      this.$buefy.dialog.prompt({
        title: "問題番号",
        confirmText: "更新",
        cancelText: "キャンセル",
        inputAttrs: { type: 'number', value: this.current_track, min: 1 },
        onCancel: () => this.sfx_play_click(),
        onConfirm: (value) => {
          this.sfx_play_click()
          this.current_track = parseInt(value, 10)
        },
      })
    },

    lap_counter_input_dialog() {
      this.sfx_play_click()
      this.$buefy.dialog.prompt({
        title: "分",
        confirmText: "更新",
        cancelText: "キャンセル",
        inputAttrs: { type: 'text', value: (this.lap_counter / 60) + "" },
        onCancel: () => this.sfx_play_click(),
        onConfirm: (value) => {
          this.sfx_play_click()
          this.lap_counter = parseFloat(value) * 60
        },
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

      this.app_log(`詰将棋用ストップウォッチ●`)
      this.mode = "playing"
      this.interval_runner.start()
      this.sfx_play("start")
      this.track_next()
      this.memento_create("start")
    },

    button_focus(o_or_x) {
      this.$nextTick(() => this.$refs[`${o_or_x}_button_ref`].focus())
    },

    stop_handle() {
      this.sfx_play_click()
      this.mode = "standby"
      this.interval_runner.stop()
      this.memento_create("stop")
    },

    reset_handle() {
      this.sfx_play_click()
      this.reset()
    },

    reset() {
      this.rows = []
      this.lap_counter = 0
    },

    toggle_handle() {
      this.sidebar_p = false
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
      this.talk(message)
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
      const min = seconds / 60
      const sec = seconds % 60
      if (min >= 60) {
        if (false) {
          // 秒を切り上げして分+1
          if (sec > 0) {
            seconds += 60
          }
          format = "h時間m分"
        } else {
          format = "h時間m分s秒"
        }
      } else if (min >= 1) {
        format = "m分s秒"
      } else {
        format = "s秒"
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
        this.lap_counter = 0
        this.sfx_play(o_or_x)

        this.track_next()
      }
    },

    track_next() {
      if (this.last_quest_exist_p) {
        this.talk(this.quest_name(this.new_quest))
      } else {
        this.stop_handle()
        this.notice(`おわりました`)
      }
    },

    revert_handle() {
      this.sidebar_p = false
      this.sfx_play_click()
      if (this.rows.length >= 1) {
        this.rows.pop()
        this.current_track -= 1
        this.lap_counter = 0
        this.notice(`1つ前に戻しました`)
      }
    },

    rap_reset() {
      this.sidebar_p = false
      this.sfx_play_click()
      this.lap_counter = 0
      this.notice(`最後のタイムだけリセットしました`)
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
      this.current_track     = hash.current_track || 1
      this.lap_counter       = hash.lap_counter || 0
      this.rows              = hash.rows || []
      this.quest_text        = hash.quest_text || ""
      this.format_index      = (hash.format_index != null) ? hash.format_index : 0,
      this.generate_max      = hash.generate_max || 200
      this.drop_seconds      = hash.drop_seconds || 60
      this.book_title        = hash.book_title || TITLE_DEFAULT,
      this.timeout_sec       = hash.timeout_sec || 0
      this.total_timeout_min = hash.total_timeout_min || 0
    },

    data_restore_from_url_or_storage_after_hook() {
      if (location.hash || this.$route.query.restore_code) {
        console.log(`ハッシュ付きのURLから復元したので綺麗なURL ${this.location_url_without_hash()} に移動する`)
        location.href = this.location_url_without_search_and_hash()
      }
    },

    reset_by_x() {
      this.sidebar_p = false
      this.sfx_play_click()
      this.reset_by_x_with_drop(null)
    },

    reset_by_x_with_drop(drop_seconds) {
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
        this.reset()
      }
    },

    reset_by_x_with_n_seconds() {
      this.sidebar_p = false
      this.sfx_play_click()
      this.$buefy.dialog.prompt({
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
  },

  watch: {
    generate_max()      { this.data_save_to_local_storage() },
    current_track()     { this.data_save_to_local_storage() },
    quest_text()        { this.data_save_to_local_storage() },
    format_index()      { this.data_save_to_local_storage() },
    drop_seconds()      { this.data_save_to_local_storage() },
    book_title()        { this.data_save_to_local_storage() },
    timeout_sec()       { this.data_save_to_local_storage() },
    total_timeout_min() { this.data_save_to_local_storage() },
    rows:               { deep: true, handler() { this.data_save_to_local_storage() }, },

    current_min(v) {
      if (this.mode === "playing") {
        if (v >= 1) {
          if (this.timeout_p || this.total_timeout_p) {
            // タイムアウトのブザーと重なる場合は「?分経過」の発声をしない
          } else {
            this.talk(`${v}分経過`)
          }
        }
      }
    },

    lap_counter(v) {
      if (this.total_timeout_p) {
        const message = `${this.total_timeout_min}分たったので終了です`
        this.talk(message)
        this.$buefy.dialog.alert({title: "おわり", message: message, trapFocus: true})
        this.stop_handle()
      }
      if (this.timeout_p) {
        this.lap_handle('x')
      }
    },

    // current_sec(v) {
    //   if (v >= 1) {
    //     this.talk(`${v}秒経過`, {rate: 1.0})
    //   }
    // },
  },

  mounted() {
    this.app_log("詰将棋用ストップウォッチ")
  },

  computed: {
    base() { return this },

    standby() { return this.mode === "standby" },
    playing() { return this.mode === "playing" },

    timeout_p() {
      if (this.mode === "playing") {
        if (this.timeout_sec >= 1) {
          if (this.timeout_sec <= this.lap_counter) {
            return true
          }
        }
      }
    },

    total_timeout_p() {
      if (this.mode === "playing") {
        if (this.total_timeout_min >= 1) {
          if ((this.total_timeout_min * 60) <= this.total_with_lap_seconds) {
            return true
          }
        }
      }
    },

    last_quest_exist_p() {
      return this.quest_name_get(this.new_quest)
    },

    new_quest() {
      return {
        index: this.rows.length,
        track: this.current_track,
        lap_counter: this.lap_counter,
      }
    },

    // tweet_url() {
    //   return this.tweet_intent_url(this.tweet_body)
    // },

    tweet_body() {
      // return _.concat(this.rows, this.new_quest).map(e => `${this.quest_name(e)} - ${this.time_format(e.lap_counter)}`).join("\n")
      const values = Object.values(this.format_all)
      const i = this.format_index % values.length
      return values[i]
    },

    quest_list() {
      if (this.quest_text === "") {
        return []
      }

      return this.quest_text.split(/[\s,]+/)
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
      } else {
        return this.quest_name_get(this.new_quest) + "〜" + "?"
      }
    },

    rate() {
      if (this.rows.length >= 1) {
        return this.count_of("o") / this.rows.length
      }
    },

    human_rate() {
      if (this.rows.length >= 1) {
        const v = this.$gs.floatx100_percentage(this.rate, 2)
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
        // 10秒未満なら小数付き
        if (this.avg < 10) {
          v = Math.round(this.avg * 100) / 100
          v = `${v}秒`
        } else {
          let format = "m分s秒"
          if (this.avg < 60) {
            format = "s秒"
          }
          v = dayjs().startOf("year").set("seconds", this.avg).format(format)
        }
        return `平均${v}`
      }
    },

    $_ls_hash() {
      return {
        current_track:     this.current_track,
        lap_counter:       this.lap_counter,
        rows:              this.rows,
        quest_text:        this.quest_text,
        format_index:      this.format_index,
        book_title:        this.book_title,
        timeout_sec:       this.timeout_sec,
        total_timeout_min: this.total_timeout_min,
      }
    },

    format_all() {
      const hash = {}

      hash["問題毎"] = this.format_type_b
      hash["サマリー"] = this.format_type_c

      if (this.development_p) {
        hash["ox"] = this.format_type_a
        hash["分毎"] = this.format_type_d
      }

      return hash
    },

    summary() {
      let out = ""

      if (this.book_title === TITLE_DEFAULT) {
      } else {
        out += this.book_title + "\n"
      }

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

    format_type_c() {
      let out = ""
      out += this.summary
      out += "\n"
      _.forIn(this.o_group_by_min, (rows, key) => {
        if (key === 0 && false) {
          out += "※" + this.human_minute(key) + "は省略\n"
        } else {
          out += this.human_minute(key) + " "
          out += rows.map(e => this.quest_name(e)).join(" ")
          out += "\n"
        }
      })

      if ('x' in this.ox_group) {
        out += "不正解" + " "
        out += this.ox_group['x'].map(e => this.quest_name(e)).join(" ")
        out += "\n"
      }

      return out
    },

    format_type_b() {
      return [
        this.summary + "\n",
        this.rows.map(e => this.quest_name(e) + " " + this.time_format(e.lap_counter) + this.o_or_x_to_s(e, "", " " + AnswerInfo.fetch("x").char_name) + "\n").join(""),
      ].join("")
    },

    format_type_a() {
      return [
        this.summary + "\n",
        this.rows.map(e => this.o_or_x_to_s(e, AnswerInfo.fetch("o").char_name, AnswerInfo.fetch("x").char_name) + " " + this.quest_name(e) + HYPHEN_SEP + this.time_format(e.lap_counter) + "\n").join(""),
      ].join("")
    },

    format_type_d() {
      let out = ""
      out += this.summary
      _.forIn(this.o_group_by_min, (rows, key) => {
        if (key === 0) {
          out += "\n※" + this.human_minute(key) + "は省略\n"
        } else {
          out += "\n"
          out += this.human_minute(key) + "\n"
          out += rows.map(e => this.quest_name(e) + HYPHEN_SEP + this.time_format(e.lap_counter) + "\n").join("")
        }
      })
      if ("x" in this.ox_group) {
        out += "\n"
        out += "不正解\n"
        out += this.ox_group['x'].map(e => this.quest_name(e) + HYPHEN_SEP + this.time_format(e.lap_counter) + "\n").join("")
      }
      return out
    },

  },
}
</script>

<style lang="sass">
@import url("https://fonts.googleapis.com/css?family=Roboto+Mono&display=swap")

.StopwatchApp
  .MainSection.section
    +tablet
      padding: 1rem

  touch-action: manipulation

  .page_title
    cursor: pointer
    font-weight: bold

  .main_box
    margin-top: 0.6rem

    position: relative
    .options_doropdown
      position: absolute
      top: 0.5rem
      left: 0.5rem

    .lap_time
      margin-top: 1.2rem
      font-size: 4rem
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
      line-height: 1.25
      font-size: $size-7

.STAGE-development
  .StopwatchApp
    .columns
      border: 1px dashed change_color($danger, $alpha: 0.5)
    .column
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
