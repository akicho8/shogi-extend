<template lang="pug">
.ActbBuilderApp
  ActbBuilderIndex(:base="base" :bapp="bapp" v-if="!question")
  ActbBuilderEdit(:base="base" :bapp="bapp" v-if="question" ref="ActbBuilderEdit")
  DebugPrint(v-if="base.debug_read_p")
</template>

<script>
import MemoryRecord from 'js-memory-record'
import dayjs from "dayjs"

import { builder_support } from "./builder_support.js"

import { Question    } from "../models/question.js"
import { LineageInfo } from '../models/lineage_info.js'
import { FolderInfo  } from '../models/folder_info.js'

class TabInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "haiti_mode",  name: "配置", },
      { key: "seikai_mode", name: "正解", },
      { key: "form_mode",   name: "情報", },
      { key: "kensho_mode", name: "検証", },
    ]
  }

  get handle_method_name() {
    return `${this.key}_handle`
  }
}

export default {
  name: "ActbBuilderApp",
  mixins: [
    builder_support,
  ],

  data() {
    return {
      //////////////////////////////////////////////////////////////////////////////// 静的情報
      LineageInfo: null,        // 問題の種類
      FolderInfo: null,         // 問題の入れ場所

      //////////////////////////////////////////////////////////////////////////////// 一覧
      questions: null,          // 一覧で表示する配列
      question_counts: {},      // それぞれの箱中の問題数

      // pagination 5点セット
      page_info: {
        total:              null,
        page:               null,
        per:                null,
        sort_column:        null,
        sort_order:         null,
        sort_order_default: null,
        //
        folder_key:         null,
        tag:                null,
      },

      //////////////////////////////////////////////////////////////////////////////// 新規・編集
      tab_index:        null,
      question:         null,
      answer_tab_index: null,   // 表示している正解タブの位置

      //////////////////////////////////////////////////////////////////////////////// 正解モード
      answer_turn_offset:     null, // 正解モードでの手数
      mediator_snapshot_sfen: null, // 正解モードでの局面

      //////////////////////////////////////////////////////////////////////////////// 検証モード
      exam_run_count: null, // 検証モードで手を動かした数
      valid_count:    null, // 検証モードで正解した数
    }
  },

  async created() {
    this.base.lobby_unsubscribe()
    this.sound_play("click")

    // 一覧用のリソース
    await this.api_get("builder_form_resource_fetch", {}, e => {
      this.LineageInfo = LineageInfo.memory_record_reset(e.LineageInfo)
      this.FolderInfo  = FolderInfo.memory_record_reset(e.FolderInfo)
    })

    // 指定IDの編集が決まっている場合はそれだけの情報を取得して表示
    if (this.base.edit_question_id) {
      this.question_edit()
      return
    }

    if (this.base.info.warp_to === "builder_haiti" || this.base.info.warp_to === "builder_form") {
      this.builder_new_handle()
      return
    }

    this.builder_index_handle()
  },

  methods: {
    question_edit() {
      // 指定IDの編集が決まっている場合はそれだけの情報を取得して表示
      if (this.base.edit_question_id) {
        this.api_get("question_edit_fetch", {question_id: this.base.edit_question_id}, e => {
          this.base.edit_question_id = null
          this.question_edit_for(new Question(e.question))
        })
      }
    },

    mode_select(tab_key) {
      this.tab_index = TabInfo.fetch(tab_key).code
    },

    edit_tab_change_handle(v) {
      this.sound_play("click")
      if (false) {
        this.say(this.current_tab_info.name)
      }
      this[this.current_tab_info.handle_method_name]()
    },

    //////////////////////////////////////////////////////////////////////////////// 各タブ切り替えた直後の初期化処理

    haiti_mode_handle() {
      this.mode_select("haiti_mode")
    },

    seikai_mode_handle() {
      this.mode_select("seikai_mode")
    },

    form_mode_handle() {
      this.mode_select("form_mode")
    },

    kensho_mode_handle() {
      this.mode_select("kensho_mode")
      this.exam_run_count = 0
      this.say(this.question.direction_message)
    },

    ////////////////////////////////////////////////////////////////////////////////

    edit_mode_snapshot_sfen(sfen) {
      if (this.question.init_sfen !== sfen) {
        this.debug_alert(`配置取得 ${sfen}`)
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

    // FIXME: イベントで受けとる
    current_moves() {
      return this.$refs.ActbBuilderEdit.$refs.ActbBuilderEditSeikai.$refs.main_sp.sp_object().moves_take_turn_offset
    },

    // 「この手順を正解とする」
    edit_stock_handle() {
      const moves = this.current_moves()

      if (moves.length === 0) {
        this.warning_notice("1手以上動かしてください")
        return
      }

      {
        const limit = this.base.config.turm_max_limit
        if (limit && moves.length > limit) {
          this.warning_notice(`${this.base.config.turm_max_limit}手以内にしてください`)
          return
        }
      }

      if (this.question.moves_valid_p(moves)) {
        this.warning_notice("すでに同じ正解があります")
        return
      }

      this.question.moves_answers.push({moves_str: moves.join(" "), end_sfen: this.mediator_snapshot_sfen})
      this.$nextTick(() => this.answer_tab_index = this.question.moves_answers.length - 1)

      this.sound_play("click")
      this.ok_notice(`${this.question.moves_answers.length}つ目の正解を追加しました`, {onend: () => {
        if (this.question.moves_answers.length === 1) {
          this.ok_notice(`他の手順で正解がある場合は続けて追加してください`)
        }
      }})
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

    // 正解だけを削除
    moves_answers_clear() {
      this.$set(this.question, "moves_answers", [])
      this.answer_tab_index = 0
    },

    question_save_handle() {
      if (this.question.moves_answers.length === 0) {
        this.warning_notice("正解を作ってください")
        return
      }

      if (!this.question.title) {
        this.warning_notice("なんかしらのタイトルを捻り出してください")
        return
      }

      if (this.question_new_record_p) {
        if (this.valid_count === 0) {
          this.warning_notice("検証してください")
          return
        }
      }

      // const moves_answers = this.answers.map(e => {
      //   return { moves_str: e.moves_str }
      // })

      // https://day.js.org/docs/en/durations/diffing
      this.question.time_limit_clock_to_sec()
      const before_save_button_name = this.save_button_name
      this.api_put("question_save_handle", {question: this.question}, e => {
        if (e.form_error_message) {
          this.warning_notice(e.form_error_message)
        }
        if (e.question) {
          this.question = new Question(e.question)

          this.sound_play("click")
          this.ok_notice(`${before_save_button_name}しました`)

          if (this.base.config.save_and_back_to_index) {
            this.builder_index_handle()
          }
        }
      })
    },

    // 「新規作成」ボタン
    builder_new_handle() {
      const attributes = _.cloneDeep(this.base.info.question_default_attributes)
      const question = new Question(attributes)
      this.question_edit_for(question)
    },

    question_edit_for(row) {
      this.sound_play("click")
      // this.$ga.event("open", {event_category: "問題編集"})

      this.__assert__(row instanceof Question, `問題が Question でラップされてない ${Question.name}`)
      this.question = row

      this.answer_tab_index = 0 // 解答リストの一番左指す
      this.answer_turn_offset = 0
      this.valid_count = 0

      if (this.base.info.warp_to === "builder_haiti") {
        this.haiti_mode_handle()
        return
      }
      if (this.base.info.warp_to === "builder_form") {
        this.form_mode_handle()
        return
      }

      // 最初に開くタブの決定
      if (this.question_new_record_p) {
        this.haiti_mode_handle()
      } else {
        this.form_mode_handle()
      }
    },

    back_to_index_handle() {
      this.builder_index_handle()
    },

    tag_search_handle(tag) {
      this.sound_play("click")
      this.say(tag)
      this.page_info.tag = tag
      this.async_records_load()
    },

    page_change_handle(page) {
      this.page_info.page = page
      this.async_records_load()
    },

    sort_handle(column, order) {
      this.page_info.sort_column = column
      this.page_info.sort_order = order
      this.async_records_load()
    },

    folder_change_handle(folder_key) {
      this.page_info.folder_key = folder_key
      this.async_records_load()
    },

    async_records_load() {
      this.api_get("questions_fetch", this.page_info, e => {
        this.questions = e.questions.map(e => new Question(e))
        this.page_info = e.page_info
        this.question_counts = e.question_counts // 各フォルダごとの個数
      })
    },

    play_mode_advanced_moves_set(moves) {
      if (this.question.moves_answers.length === 0) {
        if (this.exam_run_count === 0) {
          this.warning_notice("正解を作ってからやってください")
        }
      }
      if (this.question.moves_valid_p(moves)) {
        this.sound_play("o")
        this.ok_notice("正解")
        this.valid_count += 1
      }
      this.exam_run_count += 1
    },

    turn_offset_set(v) {
      this.debug_alert(v)
      this.answer_turn_offset = v
    },

    mediator_snapshot_sfen_set(sfen) {
      this.mediator_snapshot_sfen = sfen
    },

    builder_index_handle(event = null) {
      if (event) {
        this.sound_play("click")
      }
      this.question = null
    },
  },

  computed: {
    bapp() { return this },

    TabInfo()     { return TabInfo     },

    current_tab_info() {
      return TabInfo.fetch(this.tab_index)
    },

    save_button_name() {
      if (this.question.id) {
        return "更新"
      } else {
        return "保存"
      }
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
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.ActbBuilderApp
  .ActbBuilderEdit
    @extend %padding_top_for_secondary_header
</style>
