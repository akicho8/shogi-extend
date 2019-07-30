<template lang="pug">
.stopwatch
  .columns
    .column.is-half
      .has-text-centered
        b 詰将棋タイムアタック用ストップウォッチ
      .box.has-text-centered.nowrap
        .lap_time
          | {{quest_name(new_record)}}
          | -
          | {{time_format(lap_counter)}}
        .has-text-grey-light.total_time
          | {{ja_time_format(total_seconds2)}}
        .buttons.is-centered.start_or_stop
          template(v-if="mode === 'standby'")
            button.button.is-fullwidth.is-primary(@click="start_run") スタート

          template(v-if="mode !== 'standby'")
            button.button.is-danger(@click="stop_run") ストップ

        template(v-if="mode === 'playing'")
          .buttons.is-centered
            .ox_buttons
              button.button.is-large.is-success.is-outlined.ox_button(@click="lap_handle('o')" ref="o_button_ref") ○
              button.button.is-large.is-success.is-outlined.ox_button(@click="lap_handle('x')" ref="x_button_ref") ×

        template(v-if="mode !== 'playing'")
          template(v-if="total_seconds2 >= 1")
            .buttons.is-paddingless
              button.button.is-fullwidth(@click="reset_handle" key="reset_key") リセット

      template(v-if="quest_list.length === 0 || true")
        .field
          label.label
            | 問題番号
            | &nbsp;
            a.is-link(@click.prevent="current_track = 1")
              | (1に設定)
          .control
            b-numberinput(v-model="current_track" min="1" controls-position="compact" :expanded="true")

      .field
        .control
          textarea.textarea(v-model.trim="quest_list_str" rows="1" placeholder="スペース区切りで記述すると問題を置き換える")
          a.is-link.is-size-7(@click.prevent="quest_list_str = ''") クリア

      br
      .buttons.is-centered
        a.button.is-small(@click.prevent="rap_reset") 最後のタイムだけリセット
        a.button.is-small(@click.prevent="revert") 1つ前に戻す
        a.button.is-small(@click.prevent="reset_by_x_numbers") 不正解だけ再テスト

      br
      .buttons
        template(v-if="rows.length >= 1 || true")
          a.button.is-info.is-small(:href="twitter_url" target="_blank") ツイート

    .column.is-3
      article.message.is-primary.is-size-7
        .message-body
          | {{case1}}

    .column.nowrap
      article.message.is-primary.is-size-7.compact
        .message-body
          template(v-for="(row, i) in rows")
            div
              | {{quest_name(row)}}
              | {{time_format(row.lap_counter)}}
              | {{o_or_x_to_s(row, "", "×")}}

    .column.nowrap
      article.message.is-primary.is-size-7.compact
        .message-body
          template(v-for="(rows, key) in o_group_by_min")
            div.has-text-weight-bold
              | {{human_minute(key, rows)}}
            div
              template(v-for="row in rows")
                div
                  | {{quest_name(row)}}
                  | -
                  | {{time_format(row.lap_counter)}}
            br
          template(v-if="'x' in ox_group")
            div.has-text-weight-bold
              | 不正解
            div
              template(v-for="row in ox_group['x']")
                div
                  | {{quest_name(row)}}
                  | -
                  | {{time_format(row.lap_counter)}}

    .column.nowrap
      article.message.is-primary.is-size-7.compact
        .message-body
          template(v-for="(row, i) in rows")
            div
              | {{o_or_x_to_s(row, "○", "×")}}
              | {{quest_name(row)}}
              | -
              | {{time_format(row.lap_counter)}}
  .columns
    .column
      .box.content.has-text-grey.is-size-7
        h6 PC用ショートカット
        table.table.is-narrow
          tr
            th p or k
            td 開始/停止
          tr
            th o
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

</template>

<script>
import dayjs from "dayjs"
import { Howl, Howler } from 'howler'

import o_mp3 from "oto_logic/Quiz-Correct_Answer02-1.mp3"
import x_mp3 from "oto_logic/Quiz-Wrong_Buzzer02-1.mp3"

export default {
  name: "stopwatch",
  data() {
    return {
      current_track: null,
      lap_counter: null,
      rows: null,
      quest_list_str: null,
      mode: "standby",
      interval_id: null,
    }
  },

  created() {
    let data = null
    if (location.hash) {
      data = decodeURIComponent(location.hash.replace(/^#/, ""))
    } else {
      data = localStorage.getItem("stopwatch") || "{}"
    }
    data = JSON.parse(data)
    this.restore_data(data)

    document.addEventListener("keypress", e => {
      if (e.key === "x") {
        this.lap_handle('x')
      }
      if (e.key === "o") {
        this.lap_handle('o')
      }
      if (e.key === "z") {
        this.revert()
      }
      if (e.key === "r") {
        this.rap_reset()
      }
      if (e.key === "p" || e.key === "k") {
        this.pause()
      }
    }, false)
  },

  beforeDestroy() {
    this.clear_interval_safe()
  },

  methods: {
    pause() {
      if (this.mode === "standby") {
        this.start_run()
      } else {
        this.stop_run()
      }
    },

    start_run() {
      this.mode = "playing"
      this.clear_interval_safe()
      this.interval_id = setInterval(this.step_next, 1000)
      this.focus_to_button()
    },

    focus_to_button() {
      this.$nextTick(() => {
        if (this.$refs.x_button_ref) {
          this.$refs.x_button_ref.blur()
        }
        if (this.$refs.o_button_ref) {
          this.$refs.o_button_ref.focus()
        }
      })
    },

    stop_run() {
      this.mode = "standby"
      this.clear_interval_safe()
    },

    reset_handle() {
      this.rows = []
      this.lap_counter = 0
    },

    time_format(seconds) {
      let format = null
      if ((seconds / 60) >= 60) {
        format = "h:m:ss"
      } else {
        format = "m:ss"
      }
      return dayjs().startOf("year").set("seconds", seconds).format(format)
    },

    ja_time_format(seconds) {
      let format = null
      if ((seconds / 60) >= 60) {
        if (seconds % 60 > 0) {
          seconds += 60
        }
        // format = "h時間m分"
        format = "hh:mm"
      } else {
        // format = "m分s秒"
        format = "mm:ss"
      }
      return dayjs().startOf("year").set("seconds", seconds).format(format)
    },

    lap_handle(o_or_x) {
      if (this.mode === "playing") {
        this.rows.push({...this.new_record, o_or_x: o_or_x})

        this.current_track += 1
        this.lap_counter = 0
        this.focus_to_button()
        this.sound_play(this.sound_src(o_or_x))
      }
    },

    sound_src(o_or_x) {
      let sound_src = null
      if (o_or_x === "o") {
        sound_src = o_mp3
      } else {
        sound_src = x_mp3
      }
      return sound_src
    },

    revert() {
      if (this.rows.length >= 1) {
        const record = this.rows.pop()

        this.current_track -= 1
        this.lap_counter = 0
        this.focus_to_button()
      }
    },

    rap_reset() {
      this.lap_counter = 0
      this.focus_to_button()
    },

    sound_play(src) {
      if (false) {
        const audio = new Audio(src)
        audio.play()
      } else {
        new Howl({src: src, autoplay: true, volume: 1.0})
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
      if (this.quest_list.length >= 1) {
        return this.quest_list[row.index] || "?"
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
      return `${s}`
      // return `${s} - ${rows.length}`
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

    restore_data(value) {
      this.current_track  = value.current_track || 1
      this.lap_counter    = value.lap_counter || 0
      this.rows           = value.rows || []
      this.quest_list_str = value.quest_list_str || ""
    },

    save_process() {
      // URLに保存するとブラウザが重くなるのでやめる
      this.permalink_to_url()

      // 開き直したおきに復元できるようにするため
      localStorage.setItem("stopwatch", this.snapshot_json)
    },

    permalink_to_url() {
      location.hash = this.encoded_snapshot_json
    },

    reset_by_x_numbers() {
      if (this.count_of('o') >= 1) {
        this.current_track = 1
        this.quest_list_str = this.matigai_list.join(" ")
        this.reset_handle()
        this.focus_to_button()
      }
    },
  },

  watch: {
    current_track()  { this.save_process() },
    quest_list_str() { this.save_process() },
    rows()           { this.save_process() },
  },

  mounted() {
  },

  computed: {
    permalink() {
      return `${window.location.href}#${this.encoded_snapshot_json}`
    },

    snapshot_json() {
      return JSON.stringify(this.save_data)
    },

    encoded_snapshot_json() {
      return encodeURIComponent(this.snapshot_json)
    },

    new_record() {
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
      return _.concat(this.rows, this.new_record).map(e => `${this.quest_name(e)} - ${this.time_format(e.lap_counter)}`).join("\n")
    },

    quest_list() {
      if (this.quest_list_str !== "") {
        return this.quest_list_str.split(/[\s+,]/)
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

    // 間違った問題リスト
    matigai_list() {
      return (this.ox_group['x'] || []).map(e => this.quest_name(e))
    },

    total_seconds() {
      return _.sumBy(this.rows, e => e.lap_counter)
    },

    total_seconds2() {
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

    save_data() {
      return {
        current_track:  this.current_track,
        lap_counter:    this.lap_counter,
        rows:           this.rows,
        quest_list_str: this.quest_list_str,
      }
    },

    case1() {
      let out = ""
      out += this.quest_range + "\n"
      out += `計${this.rows.length}問\n`
      if (this.quest_list.length >= 1) {
        out += `/全${this.rows.length}問`
        out += this.human_rate
        out += this.ja_time_format(this.total_seconds)
        out += this.human_avg
        for ([rows, key] in this.o_group_by_min) {
          out += this.human_minute(key, rows)
          for (row in this.rows) {
            out += this.quest_name(row)
          }
          if ('x' in this.ox_group) {
            out += "不正解"
            for (row in this.ox_group['x']) {
              out += this.quest_name(row)
            }
          }
        }
      }
      return out
    }
  },
}
</script>

<style lang="sass">
.stopwatch
  touch-action: manipulation

  .is-size-1
    font-size: 4rem !important

  .compact
    line-height: 100%

  .lap_time
    margin-top: 0.8rem
    font-size: 4rem
    line-height: 100%

  .total_time
    font-size: 1rem

  .ox_buttons
    width: 100%
    .button
      width: 45%

  .start_or_stop
    margin-top: 0.9rem

  article
    font-family: Osaka-mono, "Osaka-等幅", "ＭＳ ゴシック", "Courier New", Consolas, monospace
</style>
