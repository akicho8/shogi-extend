<template lang="pug">
.WbookEditApp
  b-loading(:active="$fetchState.pending")
  .MainContainer(v-if="!$fetchState.pending")
    MainNavbar(:spaced="false")
      template(slot="brand")
        b-navbar-item(@click.native="exit_handle")
          b-icon(icon="chevron-left")
        //- b-navbar-item.has-text-weight-bold(@click="title_edit")
        //-   | {{current_title}}
          //- span.mx-1(v-if="sp_run_mode === 'play_mode' && turn_offset >= 1") \#{{turn_offset}}
      //- template(slot="end")
      //-   //- b-navbar-item.is-unselectable(tag="div" v-if="ac_room")
      //-   //-   b-icon(icon="account")
      //-   //-   b-tag.has-text-weight-bold(rounded)
      //-   //-     .has-text-primary {{member_infos.length}}
      //-
      //-   b-navbar-item.has-text-weight-bold(@click="tweet_handle" v-if="sp_run_mode === 'play_mode' && !share_p")
      //-     b-icon(icon="twitter" type="is-white")
      //-   b-navbar-item.has-text-weight-bold(@click="mode_toggle_handle" v-if="sp_run_mode === 'edit_mode'")
      //-     | 編集完了
      //-   b-navbar-item.sidebar_toggle_navbar_item(@click="sidebar_toggle" v-if="sp_run_mode === 'play_mode'")
      //-     b-icon(icon="menu")

    .container
      b-tabs.MainTabs(v-model="base.tab_index" expanded @input="base.edit_tab_change_handle")
        b-tab-item(label="配置")
        b-tab-item
          template(slot="header")
            span
              | 正解
              b-tag(rounded v-if="base.question.moves_answers.length >= 1") {{base.question.moves_answers.length}}
        b-tab-item(label="情報")
        b-tab-item
          template(slot="header")
            span
              | 検証
              b-tag(rounded v-if="base.valid_count >= 1" type="is-primary") OK

    MainSection.is_mobile_padding_zero
      .container
        //- .columns.is-gapless.is-centered.is-gapless
        //-   .MainColumn.column
        WbookEditHaiti(:base="base"  v-if="base.current_tab_info.key === 'haiti_mode'")
        WbookEditSeikai(:base="base" v-if="base.current_tab_info.key === 'seikai_mode'" ref="WbookEditSeikai")
        WbookEditForm(:base="base"   v-if="base.current_tab_info.key === 'form_mode'")
        WbookEditKensho(:base="base" v-if="base.current_tab_info.key === 'kensho_mode'")
</template>

<script>
import MemoryRecord from 'js-memory-record'
import dayjs from "dayjs"

import { support_child } from "./support_child.js"

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
  name: "WbookBuilderApp",
  mixins: [
    support_child,
  ],

  data() {
    return {
      //////////////////////////////////////////////////////////////////////////////// 静的情報
      LineageInfo: null,        // 問題の種類
      FolderInfo: null,         // 問題の入れ場所

      //////////////////////////////////////////////////////////////////////////////// 一覧
      questions: null,          // 一覧で表示する配列
      question_counts: {},      // それぞれの箱中の問題数

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

  fetch() {
    this.$axios.$get("/api/wbook.json", {params: {remote_action: "question_edit_fetch", ...this.$route.query}}).then(e => {
      this.LineageInfo = LineageInfo.memory_record_reset(e.LineageInfo)
      this.FolderInfo  = FolderInfo.memory_record_reset(e.FolderInfo)
      this.config = e.config
      let question = null
      if (e.question) {
        question = new Question(e.question)
      }
      if (e.question_default_attributes) {
        const attributes = _.cloneDeep(e.question_default_attributes)
        question = new Question(attributes)
      }
      this.question_edit_for(question)
    })
  },

  created() {
    // this.sound_play("click")
    //
    // // 一覧用のリソース
    // await this.api_get("builder_form_resource_fetch", {}, e => {
    //   this.LineageInfo = LineageInfo.memory_record_reset(e.LineageInfo)
    //   this.FolderInfo  = FolderInfo.memory_record_reset(e.FolderInfo)
    // })
    //
    // // // 指定IDの編集が決まっている場合はそれだけの情報を取得して表示
    // // if (this.base.edit_question_id) {
    // //   this.question_edit()
    // //   return
    // // }
    //
    // this.builder_new_handle()
  },

  methods: {
    // question_edit() {
    //   // 指定IDの編集が決まっている場合はそれだけの情報を取得して表示
    //   if (this.base.edit_question_id) {
    //     this.api_get("question_edit_fetch", {question_id: this.base.edit_question_id}, e => {
    //       this.base.edit_question_id = null
    //       this.question_edit_for(new Question(e.question))
    //     })
    //   }
    // },

    mode_select(tab_key) {
      this.tab_index = TabInfo.fetch(tab_key).code
    },

    edit_tab_change_handle(v) {
      this.sound_play("click")
      if (false) {
        this.talk(this.current_tab_info.name)
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
      this.talk(this.question.direction_message)
    },

    ////////////////////////////////////////////////////////////////////////////////

    edit_mode_snapshot_sfen(sfen) {
      if (this.question.init_sfen !== sfen) {
        this.debug_alert(`配置取得 ${sfen}`)
        this.question.init_sfen = sfen

        // 合わせて正解も削除する
        if (this.question.moves_answers.length >= 1) {
          this.toast_ok("元の配置を変更したので正解を削除しました")
          this.moves_answers_clear()
        }

        // 検証してない状態にする
        this.valid_count = 0
      }
    },

    // FIXME: イベントで受けとる
    current_moves() {
      return this.$refs.WbookEdit.$refs.WbookEditSeikai.$refs.main_sp.sp_object().moves_take_turn_offset
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
      this.toast_ok(`${this.question.moves_answers.length}つ目の正解を追加しました`, {onend: () => {
        if (this.question.moves_answers.length === 1) {
          this.toast_ok(`他の手順で正解がある場合は続けて追加してください`)
        }
      }})
    },

    moves_answer_delete_handle(index) {
      const new_ary = this.question.moves_answers.filter((e, i) => i !== index)
      this.$set(this.question, "moves_answers", new_ary)
      this.$nextTick(() => this.answer_tab_index = _.clamp(this.answer_tab_index, 0, this.question.moves_answers.length - 1))

      this.sound_play("click")
      this.toast_ok("削除しました")
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
        this.warning_notice("なんかしらのタイトルを捻り出して入力してください")
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
          this.toast_ok(`${before_save_button_name}しました`)

          if (this.base.config.save_and_back_to_index) {
            this.builder_index_handle()
          }
        }
      })
    },

    // // 「新規作成」ボタン
    // builder_new_handle() {
    //   const attributes = _.cloneDeep(this.base.info.question_default_attributes)
    //   const question = new Question(attributes)
    //   this.question_edit_for(question)
    // },

    question_edit_for(row) {
      this.sound_play("click")

      this.__assert__(row instanceof Question, `問題が Question でラップされてない ${Question.name}`)
      this.question = row

      this.answer_tab_index = 0 // 解答リストの一番左指す
      this.answer_turn_offset = 0
      this.valid_count = 0

      // if (this.base.info.warp_to === "builder_haiti") {
      //   this.haiti_mode_handle()
      //   return
      // }
      // if (this.base.info.warp_to === "builder_form") {
      //   this.form_mode_handle()
      //   return
      // }

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

    play_mode_advanced_moves_set(moves) {
      if (this.question.moves_answers.length === 0) {
        if (this.exam_run_count === 0) {
          this.warning_notice("正解を作ってからやってください")
        }
      }
      if (this.question.moves_valid_p(moves)) {
        this.sound_play("o")
        this.toast_ok("正解")
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
    base() { return this },

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
@import "./support.sass"
.STAGE-development
  .WbookEditApp
    .container
      border: 1px dashed change_color($danger, $alpha: 0.5)
    .columns.is-gapless
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .column
      border: 1px dashed change_color($success, $alpha: 0.5)

.WbookEditApp
  .MainSection.section
    padding: 0

  .MainTabs
    .tab-content
      display: none
</style>
