<template lang="pug">
.WkbkArticleEditApp
  DebugBox
    template(v-if="article")
      p article.user.id: {{article.user && article.user.id}}
      p g_current_user.id: {{g_current_user && g_current_user.id}}
      p owner_p: {{owner_p}}
      p editable_p: {{editable_p}}
  b-loading(:active="$fetchState.pending")
  .MainContainer(v-if="!$fetchState.pending")
    WkbkArticleEditNavbar(:base="base")
    .container
      b-tabs.MainTabs(v-model="tab_index" expanded @input="edit_tab_change_handle")
        b-tab-item(label="配置")
        b-tab-item
          template(slot="header")
            span
              | 正解
              b-tag(rounded v-if="article.moves_answers.length >= 1") {{article.moves_answers.length}}
        b-tab-item(label="情報")
        b-tab-item
          template(slot="header")
            span
              | 検証
              b-tag(rounded v-if="valid_count >= 1" type="is-primary") OK

    MainSection.is_mobile_padding_zero
      .container
        keep-alive
          WkbkArticleEditPlacement(:base="base"  v-if="current_tab_info.key === 'placement_mode'")
          WkbkArticleEditAnswerCreate(:base="base" v-if="current_tab_info.key === 'answer_create_mode'" ref="WkbkArticleEditAnswerCreate")
          WkbkArticleEditForm(:base="base"   v-if="current_tab_info.key === 'form_mode'")
          WkbkArticleEditValidation(:base="base" v-if="current_tab_info.key === 'validation_mode'")
</template>

<script>
import MemoryRecord from 'js-memory-record'
import dayjs from "dayjs"

import { support_parent } from "./support_parent.js"

import { Article    } from "../models/article.js"
import { LineageInfo } from '../models/lineage_info.js'
import { FolderInfo  } from '../models/folder_info.js'
import { EditTabInfo  } from '../models/edit_tab_info.js'

export default {
  name: "WkbkArticleIndexApp",
  mixins: [
    support_parent,
  ],

  data() {
    return {
      //////////////////////////////////////////////////////////////////////////////// 静的情報
      LineageInfo: null,        // 問題の種類
      FolderInfo: null,         // 問題の入れ場所

      //////////////////////////////////////////////////////////////////////////////// 新規・編集
      tab_index:        null,
      article:         null,
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
    return this.$axios.$get("/api/wkbk.json", {params: {remote_action: "article_edit_fetch", ...this.$route.params, ...this.$route.query}}).then(e => {
      this.LineageInfo = LineageInfo.memory_record_reset(e.LineageInfo)
      this.FolderInfo  = FolderInfo.memory_record_reset(e.FolderInfo)
      this.config = e.config
      if (e.article) {
        this.article = new Article(e.article)
      }
      if (e.article_default_attributes) {
        const attributes = _.cloneDeep(e.article_default_attributes)
        this.article = new Article(attributes)
      }
      this.__assert__(this.article, "this.article")
      this.__assert__(this.article instanceof Article, "this.article instanceof Article")

      // this.sound_play("click")

      this.answer_tab_index = 0 // 解答リストの一番左指す
      this.answer_turn_offset = 0
      this.valid_count = 0

      // 最初に開くタブの決定
      if (this.article.new_record_p) {
        this.placement_mode_handle()
      }
      if (this.article.persisted_p) {
        this.form_mode_handle()
      }
    })
  },

  methods: {
    tab_set(tab_key) {
      this.tab_index = EditTabInfo.fetch(tab_key).code
    },

    edit_tab_change_handle(v) {
      this.sound_play("click")
      if (false) {
        this.talk(this.current_tab_info.name)
      }
      this[this.current_tab_info.handle_method_name]()
    },

    //////////////////////////////////////////////////////////////////////////////// 各タブ切り替えた直後の初期化処理

    placement_mode_handle() {
      this.tab_set("placement_mode")
    },

    answer_create_mode_handle() {
      this.tab_set("answer_create_mode")
    },

    form_mode_handle() {
      this.tab_set("form_mode")
    },

    validation_mode_handle() {
      this.tab_set("validation_mode")
      this.exam_run_count = 0
      this.talk(this.article.direction_message)
    },

    ////////////////////////////////////////////////////////////////////////////////

    edit_mode_snapshot_sfen(sfen) {
      if (this.article.init_sfen !== sfen) {
        this.debug_alert(`配置取得 ${sfen}`)
        this.article.init_sfen = sfen

        // 合わせて正解も削除する
        if (this.article.moves_answers.length >= 1) {
          this.toast_ok("元の配置を変更したので正解を削除しました")
          this.moves_answers_clear()
        }

        // 検証してない状態にする
        this.valid_count = 0
      }
    },

    // FIXME: イベントで受けとる
    current_moves() {
      return this.$refs.WkbkArticleEditAnswerCreate.$refs.main_sp.sp_object().moves_take_turn_offset
    },

    // 「この手順を正解とする」
    edit_stock_handle() {
      const moves = this.current_moves()

      if (moves.length === 0) {
        this.toast_warn("1手以上動かしてください")
        return
      }

      {
        const limit = this.config.turm_max_limit
        if (limit && moves.length > limit) {
          this.toast_warn(`${this.config.turm_max_limit}手以内にしてください`)
          return
        }
      }

      if (this.article.moves_valid_p(moves)) {
        this.toast_warn("すでに同じ正解があります")
        return
      }

      this.article.moves_answers.push({moves_str: moves.join(" "), end_sfen: this.mediator_snapshot_sfen})
      this.$nextTick(() => this.answer_tab_index = this.article.moves_answers.length - 1)

      this.sound_play("click")
      this.toast_ok(`${this.article.moves_answers.length}つ目の正解を追加しました`, {onend: () => {
        if (this.article.moves_answers.length === 1) {
          this.toast_ok(`他の手順で正解がある場合は続けて追加してください`)
        }
      }})
    },

    moves_answer_delete_handle(index) {
      const new_ary = this.article.moves_answers.filter((e, i) => i !== index)
      this.$set(this.article, "moves_answers", new_ary)
      this.$nextTick(() => this.answer_tab_index = _.clamp(this.answer_tab_index, 0, this.article.moves_answers.length - 1))

      this.sound_play("click")
      this.toast_ok("削除しました")
    },

    full_sfen_build(moves_answer_attributes) {
      return [this.article.init_sfen, "moves", moves_answer_attributes.moves_str].join(" ")
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 正解だけを削除
    moves_answers_clear() {
      this.$set(this.article, "moves_answers", [])
      this.answer_tab_index = 0
    },

    article_save_handle() {
      this.sound_play("click")

      if (this.sns_login_required()) {
        return
      }

      if (!this.editable_p) {
        this.toast_ng("所有者でないため更新できません")
        return
      }

      if (this.article.moves_answers.length === 0) {
        this.toast_warn("正解を作ってください")
        return
      }

      if (!this.article.title) {
        this.toast_warn("なんかしらのタイトルを捻り出して入力してください")
        return
      }

      if (this.article.new_record_p) {
        if (this.valid_count === 0) {
          this.toast_warn("検証してください")
          return
        }
      }

      // const moves_answers = this.answers.map(e => {
      //   return { moves_str: e.moves_str }
      // })

      // https://day.js.org/docs/en/durations/diffing
      this.article.time_limit_clock_to_sec()
      const before_save_button_name = this.save_button_name
      this.api_put("article_save_handle", {article: this.article}, e => {
        if (e.form_error_message) {
          this.toast_warn(e.form_error_message)
        }
        if (e.article) {
          this.article = new Article(e.article)

          this.toast_ok(`${before_save_button_name}しました`)

          this.$router.push({name: "wkbk-articles"})
        }
      })
    },

    play_mode_advanced_moves_set(moves) {
      if (this.article.moves_answers.length === 0) {
        if (this.exam_run_count === 0) {
          this.toast_warn("正解を作ってからやってください")
        }
      }
      if (this.article.moves_valid_p(moves)) {
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
  },

  computed: {
    base()                { return this                                         },
    EditTabInfo()         { return EditTabInfo                                  },
    current_tab_info()    { return EditTabInfo.fetch(this.tab_index)            },
    save_button_name()    { return this.article.new_record_p ? "保存" : "更新" },
    save_button_enabled() { return this.article.moves_answers.length >= 1      },

    //////////////////////////////////////////////////////////////////////////////// 編集権限
    owner_p()    { return this.article.owner_p(this.g_current_user) },
    editable_p() { return this.owner_p                               },
    disabled_p() { return !this.editable_p                           },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.STAGE-development
  .WkbkArticleEditApp
    .container
      border: 1px dashed change_color($danger, $alpha: 0.5)
    .columns.is-gapless
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .column
      border: 1px dashed change_color($success, $alpha: 0.5)

.WkbkArticleEditApp
  .MainSection.section
    padding: 0

  .MainTabs
    .tab-content
      display: none
</style>
