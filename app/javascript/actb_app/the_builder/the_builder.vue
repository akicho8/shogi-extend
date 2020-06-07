<template lang="pug">
.the_builder
  the_builder_index(v-if="!question")

  .the_builder_new_and_edit(v-if="question")
    .primary_header
      b-icon.header_item.ljust(icon="arrow-left" @click.native="builder_index_handle")
      .header_center_title {{question_new_record_p ? '新規' : '編集'}}
      .header_item.rjust.has-text-weight-bold(@click="save_handle" :class="{disabled: !save_button_enabled}")
        | {{create_or_upate_name}}

    .secondary_header
      b-tabs.main_tabs(v-model="tab_index" expanded @change="tab_change_handle")
        b-tab-item(label="配置")

        b-tab-item
          template(slot="header")
            span
              | 正解
              b-tag(rounded) {{question.moves_answers.length}}

        b-tab-item(label="情報")

        b-tab-item
          template(slot="header")
            span
              | 検証
              b-tag(rounded) {{valid_count}}

    template(v-if="current_tab_info.key === 'haiti_mode'")
      the_builder_haiti

    template(v-if="current_tab_info.key === 'seikai_mode'")
      the_builder_play(ref="the_builder_play")

    template(v-if="current_tab_info.key === 'form_mode'")
      the_builder_form

    template(v-if="current_tab_info.key === 'exam_mode'")
      the_builder_kensho

    //- .save_container
    //-   .buttons.is-centered
    //-     b-button.has-text-weight-bold(@click="save_handle" :type="save_button_enabled") {{create_or_upate_name}}
    //-     //- b-button.has-text-weight-bold(@click="back_to_index_handle") 一覧に戻る
  debug_print(v-if="app.debug_mode_p" )
</template>

<script>
import MemoryRecord from 'js-memory-record'
import dayjs from "dayjs"
import { Question } from "../models/question.js"

class TabInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "haiti_mode",  name: "配置", },
      { key: "seikai_mode", name: "正解", },
      { key: "form_mode",   name: "情報", },
      { key: "exam_mode",   name: "検証", },
    ]
  }

  get handle_method_name() {
    return `${this.key}_handle`
  }
}

import { support } from "../support.js"
import the_builder_index from "./the_builder_index.vue"
import the_builder_haiti from "./the_builder_haiti.vue"
import the_builder_play from "./the_builder_play.vue"
import the_builder_form from "./the_builder_form.vue"
import the_builder_kensho from "./the_builder_kensho.vue"

export default {
  name: "the_builder",
  mixins: [
    support,
  ],
  components: {
    the_builder_index,
    the_builder_haiti,
    the_builder_play,
    the_builder_form,
    the_builder_kensho,
  },
  data() {
    return {
      //////////////////////////////////////////////////////////////////////////////// 一覧
      questions: null,          // 一覧で表示する配列
      // pagination 5点セット
      total:              null,
      page:               null,
      per:                null,
      sort_column:        null,
      sort_order:         null,
      sort_order_default: null,

      //////////////////////////////////////////////////////////////////////////////// 新規・編集
      tab_index:        null,
      question:         null,
      fixed_init_sfen:  null,   // 配置モードでの棋譜
      time_limit_clock: null,   // b-timepicker 用 (question.time_limit_sec から変換する)
      answer_tab_index: null,   // 表示している正解タブの位置

      //////////////////////////////////////////////////////////////////////////////// 正解モード
      answer_turn_offset:     null, // 正解モードでの手数
      mediator_snapshot_sfen: null, // 正解モードでの局面

      //////////////////////////////////////////////////////////////////////////////// 検証モード
      exam_run_count: null, // 検証モードで手を動かした数
      valid_count:    null, // 検証モードで正解した数
    }
  },

  created() {
    this.total              = this.app.info.total
    this.page               = this.app.info.page
    this.per                = this.app.info.per
    this.sort_column        = this.app.info.sort_column
    this.sort_order         = this.app.info.sort_order
    this.sort_order_default = this.app.info.sort_order_default

    this.app.lobby_unsubscribe()

    this.sound_play("click")

    this.mode_select("haiti_mode")
    this.tab_change_handle()

    if (this.app.info.debug_scene === "builder_haiti" || this.app.info.debug_scene === "builder_form") {
      this.builder_new_handle()
      return
    }

    this.builder_index_handle()
    // this.exam_mode_handle()

  },

  methods: {
    mode_select(tab_key) {
      this.tab_index = TabInfo.fetch(tab_key).code
    },

    tab_change_handle() {
      this.sound_play("click")
      this[this.current_tab_info.handle_method_name]()
    },

    ////////////////////////////////////////////////////////////////////////////////

    haiti_mode_handle() {
      this.mode_select("haiti_mode")
    },

    seikai_mode_handle() {
      this.mode_select("seikai_mode")
    },

    form_mode_handle() {
      this.mode_select("form_mode")
    },

    exam_mode_handle() {
      this.mode_select("exam_mode")
      this.exam_run_count = 0
    },

    ////////////////////////////////////////////////////////////////////////////////

    edit_mode_snapshot_sfen(sfen) {
      // console.log(this.question.init_sfen)
      // console.log(sfen)

      if (this.question.init_sfen !== sfen) {
        this.debug_alert(`初期配置取得 ${sfen}`)
        this.question.init_sfen = sfen

        // 合わせて正解も削除する
        if (this.question.moves_answers.length >= 1) {
          this.ok_notice("元の配置を変更したので正解を削除しました")
          this.moves_answers_clear()
        }

        // 検証してない状態にする
        this.valid_count = 0
      }
    },

    current_moves_str() {
      return this.$refs.the_builder_play.$refs.play_sp.moves_take_turn_offset.join(" ")
    },

    // 「この手順を正解とする」
    edit_stock_handle() {
      const moves_str = this.current_moves_str()

      if (moves_str === "") {
        this.warning_notice("1手以上動かしてください")
        return
      }

      if (this.question.moves_answers.some(e => e.moves_str === moves_str)) {
        this.warning_notice("すでに同じ正解があります")
        return
      }

      this.question.moves_answers.push({moves_str: moves_str, end_sfen: this.mediator_snapshot_sfen})
      this.$nextTick(() => this.answer_tab_index = this.question.moves_answers.length - 1)

      this.sound_play("click")
      this.ok_notice(`${this.question.moves_answers.length}つ目の正解を追加しました`)
    },

    moves_answer_delete_handle(index) {
      const new_ary = this.question.moves_answers.filter((e, i) => i !== index)
      this.$set(this.question, "moves_answers", new_ary)
      this.$nextTick(() => this.answer_tab_index = _.clamp(this.answer_tab_index, 0, this.question.moves_answers.length - 1))

      this.sound_play("click")
      this.ok_notice("削除しました")
    },

    full_sfen_build(moves_answer_attributes) {
      return [this.question.init_sfen, "moves", moves_answer_attributes.moves_str].join(" ")
    },

    ////////////////////////////////////////////////////////////////////////////////

    // clock = advance(seconds: sec)
    time_limit_clock_set() {
      this.time_limit_clock = this.base_clock.add(this.question.time_limit_sec, "second").toDate()
    },

    // 正解だけを削除
    moves_answers_clear() {
      this.$set(this.question, "moves_answers", [])
      this.answer_tab_index = 0
    },

    save_handle() {
      if (this.question.moves_answers.length === 0) {
        this.warning_notice("正解を作ってください")
        return
      }

      if (this.question_new_record_p) {
        if (this.valid_count === 0) {
          this.warning_notice("1回ぐらい検証してください")
          return
        }
      }

      // const moves_answers = this.answers.map(e => {
      //   return { moves_str: e.moves_str }
      // })

      // https://day.js.org/docs/en/durations/diffing
      const time_limit_sec = dayjs(this.time_limit_clock).diff(this.base_clock) / 1000
      const question_attributes = { ...this.question, time_limit_sec: time_limit_sec }

      const before_create_or_upate_name = this.create_or_upate_name
      this.remote_fetch("PUT", this.app.info.put_path, {remote_action: "save_handle", question: question_attributes}, e => {
        if (e.form_error_message) {
          this.warning_notice(e.form_error_message)
        }
        if (e.question) {
          this.question = e.question

          this.time_limit_clock_set()
          this.ok_notice(`${before_create_or_upate_name}しました`)
        }
      })
    },

    // 「新規作成」ボタン
    builder_new_handle() {
      this.question_edit_of(this.question_default)
    },

    question_edit_of(row) {
      this.sound_play("click")
      this.question = row

      // 更新した init_sfen が shogi-player の kifu_body に渡ると循環する副作用で駒箱が消えてしまうため別にする
      this.fixed_init_sfen = this.question.init_sfen
      // this.$set(this.question, "fixed_init_sfen", this.question.init_sfen)

      this.time_limit_clock_set()

      this.answer_tab_index = 0 // 解答リストの一番左指す
      this.answer_turn_offset = 0
      this.valid_count = 0

      if (this.app.info.debug_scene === "builder_haiti") {
        this.haiti_mode_handle()
        return
      }
      if (this.app.info.debug_scene === "builder_form") {
        this.form_mode_handle()
        return
      }

      if (this.question_new_record_p) {
        this.haiti_mode_handle()
      } else {
        this.exam_mode_handle()
      }
    },

    back_to_index_handle() {
      this.builder_index_handle()
    },

    page_change_handle(page) {
      this.page = page
      this.async_records_load()
    },

    sort_handle(column, order) {
      this.sort_column = column
      this.sort_order = order
      this.async_records_load()
    },

    async_records_load() {
      this.remote_get(this.app.info.put_path, {
        remote_action: "questions_fetch",
        page:               this.page,
        per:                this.per,
        sort_column:        this.sort_column,
        sort_order:         this.sort_order,
        sort_order_default: this.sort_order_default,
      }, e => {
        this.questions = e.questions.map(e => new Question(e))

        this.total              = e.total
        this.page               = e.page
        this.per                = e.per
        this.sort_column        = e.sort_column
        this.sort_order         = e.sort_order
        this.sort_order_default = e.sort_order_default
      })
    },

    play_mode_advanced_moves_set(moves) {
      if (this.question.moves_answers.length === 0) {
        if (this.exam_run_count === 0) {
          this.warning_notice("正解を作ってからやってください")
        }
      }
      if (this.question.moves_answers.some(e => e.moves_str === moves.join(" "))) {
        this.sound_play("o")
        this.ok_notice("正解")
        this.valid_count += 1
      }
      this.exam_run_count += 1
    },

    turn_offset_set(v) {
      this.answer_turn_offset = v
    },

    mediator_snapshot_sfen_set(sfen) {
      this.mediator_snapshot_sfen = sfen
    },

    builder_index_handle(event) {
      if (event) {
        this.sound_play("click")
      }
      this.question = null
      this.async_records_load()
    },
  },

  computed: {
    TabInfo() { return TabInfo },

    current_tab_info() {
      return TabInfo.fetch(this.tab_index)
    },

    create_or_upate_name() {
      if (this.question.id) {
        return "更新"
      } else {
        return "保存"
      }
    },

    start_level_max() {
      return 10
    },

    base_clock() {
      return dayjs("2000-01-01T00:00:00+09:00")
    },

    save_button_enabled() {
      return this.question.moves_answers.length >= 1
    },

    question_new_record_p() {
      this.__assert__(this.question, "this.question != null")
      return this.question.id == null
    },

    // 問題の初期値
    question_default() {
      return this.app.info.question_default
      // const question = {
      //   // init_sfen: "4k4/9/9/9/9/9/9/9/9 b 2r2b4g4s4n4l18p 1",
      //   // init_sfen: "4k4/9/4GG3/9/9/9/9/9/9 b 2r2b2g4s4n4l18p 1",
      //   init_sfen: "7gk/9/7GG/7N1/9/9/9/9/9 b 2r2bg4s3n4l18p 1",
      //   moves_answers: [],
      //   time_limit_sec: 3 * 60,
      //   difficulty_level: 1,
      //   title: "",
      // }
      // return question
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_builder
  .the_builder_new_and_edit
    @extend %padding_top_for_secondary_header
    .primary_header
      justify-content: space-between
</style>
