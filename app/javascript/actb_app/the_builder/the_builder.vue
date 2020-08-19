<template lang="pug">
.the_builder(v-if="builder_form_resource_fetched_p")
  the_builder_index(v-if="!question")

  .the_builder_new_and_edit(v-if="question")
    ////////////////////////////////////////////////////////////////////////////////
    .primary_header
      b-icon.header_item.with_icon.ljust(icon="arrow-left" @click.native="builder_index_handle(true)")
      .header_center_title
        template(v-if="question.title")
          | {{question.title}}
        template(v-else)
          | {{question_new_record_p ? '新規' : '編集'}}
      .header_item.with_text.rjust.has-text-weight-bold(@click="question_save_handle" :class="{disabled: !save_button_enabled}")
        | {{save_button_name}}

    ////////////////////////////////////////////////////////////////////////////////
    .secondary_header
      b-tabs.tabs_in_secondary(v-model="$store.state.builder.tab_index" expanded @change="edit_tab_change_handle")
        b-tab-item(label="配置")

        b-tab-item
          template(slot="header")
            span
              | 正解
              b-tag(rounded v-if="question.moves_answers.length >= 1") {{question.moves_answers.length}}

        b-tab-item(label="情報")

        b-tab-item
          template(slot="header")
            span
              | 検証
              b-tag(rounded v-if="valid_count >= 1" type="is-primary") OK

    ////////////////////////////////////////////////////////////////////////////////
    the_builder_edit_haiti(  v-if="current_tab_info.key === 'haiti_mode'")
    the_builder_edit_seikai( v-if="current_tab_info.key === 'seikai_mode'" ref="the_builder_edit_seikai")
    the_builder_edit_form(   v-if="current_tab_info.key === 'form_mode'")
    the_builder_edit_kensho( v-if="current_tab_info.key === 'kensho_mode'")

  debug_print(v-if="app.debug_read_p")
</template>

<script>
import MemoryRecord from 'js-memory-record'
import dayjs from "dayjs"

import { support } from "./support.js"
import the_builder_index  from "./the_builder_index.vue"
import the_builder_edit_haiti  from "./the_builder_edit_haiti.vue"
import the_builder_edit_seikai from "./the_builder_edit_seikai.vue"
import the_builder_edit_form   from "./the_builder_edit_form.vue"
import the_builder_edit_kensho from "./the_builder_edit_kensho.vue"

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

import { mapState, mapGetters, mapMutations, mapActions } from "vuex"

export default {
  name: "the_builder",
  mixins: [
    support,
  ],
  components: {
    the_builder_index,
    the_builder_edit_haiti,
    the_builder_edit_seikai,
    the_builder_edit_form,
    the_builder_edit_kensho,
  },
  async created() {
    this.app.lobby_unsubscribe()
    this.sound_play("click")

    await this.resource_fetch()

    // 指定IDの編集が決まっている場合はそれだけの情報を取得して表示
    if (this.app.edit_question_id) {
      this.question_edit()
      return
    }

    if (this.app.info.warp_to === "builder_haiti" || this.app.info.warp_to === "builder_form") {
      this.builder_new_handle()
      return
    }

    this.builder_index_handle()
  },

  methods: {
    question_edit() {
      // 指定IDの編集が決まっている場合はそれだけの情報を取得して表示
      if (this.app.edit_question_id) {
        this.api_get("question_edit_fetch", {question_id: this.app.edit_question_id}, e => {
          this.app.edit_question_id = null
          this.question_edit_for(new Question(e.question))
        })
      }
    },

    mode_select(tab_key) {
      this.$store.state.builder.tab_index = TabInfo.fetch(tab_key).code
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
      this.$store.state.builder.exam_run_count = 0
      this.say(this.question.direction_message)
    },

    ////////////////////////////////////////////////////////////////////////////////

    edit_mode_snapshot_sfen(sfen) {
      if (this.question.init_sfen !== sfen) {
        this.debug_alert(`配置取得 ${sfen}`)
        this.$store.state.builder.question.init_sfen = sfen

        // 合わせて正解も削除する
        if (this.question.moves_answers.length >= 1) {
          this.ok_notice("元の配置を変更したので正解を削除しました")
          this.moves_answers_clear()
        }

        // 検証してない状態にする
        this.$store.state.builder.valid_count = 0
      }
    },

    current_moves() {
      return this.$refs.the_builder_edit_seikai.$refs.play_sp.moves_take_turn_offset
    },

    // 「この手順を正解とする」
    edit_stock_handle() {
      const moves = this.current_moves()

      if (moves.length === 0) {
        this.warning_notice("1手以上動かしてください")
        return
      }

      {
        const limit = this.app.config.turm_max_limit
        if (limit && moves.length > limit) {
          this.warning_notice(`${this.app.config.turm_max_limit}手以内にしてください`)
          return
        }
      }

      if (this.question.moves_valid_p(moves)) {
        this.warning_notice("すでに同じ正解があります")
        return
      }

      this.question.moves_answers.push({moves_str: moves.join(" "), end_sfen: this.mediator_snapshot_sfen})
      this.$nextTick(() => this.$store.state.builder.answer_tab_index = this.question.moves_answers.length - 1)

      this.sound_play("click")
      this.ok_notice(`${this.question.moves_answers.length}つ目の正解を追加しました`, {onend: () => {
        if (this.question.moves_answers.length === 1) {
          this.ok_notice(`他の手順で正解がある場合は続けて追加してください`)
        }
      }})
    },

    moves_answer_delete_handle(index) {
      const new_ary = this.question.moves_answers.filter((e, i) => i !== index)
      this.$set(this.$store.state.builder.question, "moves_answers", new_ary)
      this.$nextTick(() => this.$store.state.builder.answer_tab_index = _.clamp(this.answer_tab_index, 0, this.question.moves_answers.length - 1))

      this.sound_play("click")
      this.ok_notice("削除しました")
    },

    full_sfen_build(moves_answer_attributes) {
      return [this.question.init_sfen, "moves", moves_answer_attributes.moves_str].join(" ")
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 正解だけを削除
    moves_answers_clear() {
      this.$set(this.$store.state.builder.question, "moves_answers", [])
      this.$store.state.builder.answer_tab_index = 0
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
          this.$store.state.builder.question = new Question(e.question)

          this.sound_play("click")
          this.ok_notice(`${before_save_button_name}しました`)

          if (this.app.config.save_and_back_to_index) {
            this.builder_index_handle()
          }
        }
      })
    },

    // 「新規作成」ボタン
    builder_new_handle() {
      const attributes = _.cloneDeep(this.app.info.question_default_attributes)
      const question = new Question(attributes)
      this.question_edit_for(question)
    },

    question_edit_for(row) {
      this.sound_play("click")
      this.$gtag.event("open", {event_category: "問題編集"})

      this.__assert__(row instanceof Question, `問題が Question でラップされてない ${Question.name}`)
      this.$store.state.builder.question = row

      this.$store.state.builder.answer_tab_index = 0 // 解答リストの一番左指す
      this.$store.state.builder.answer_turn_offset = 0
      this.$store.state.builder.valid_count = 0

      if (this.app.info.warp_to === "builder_haiti") {
        this.haiti_mode_handle()
        return
      }
      if (this.app.info.warp_to === "builder_form") {
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

    page_change_handle(page) {
      this.$store.state.builder.page_info.page = page
      this.records_fetch()
    },

    sort_handle(column, order) {
      this.$store.state.builder.page_info.sort_column = column
      this.$store.state.builder.page_info.sort_order = order
      this.records_fetch()
    },

    folder_change_handle(folder_key) {
      this.$store.state.builder.page_info.folder_key = folder_key
      this.records_fetch()
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
        this.$store.state.builder.valid_count += 1
      }
      this.$store.state.builder.exam_run_count += 1
    },
  },

  computed: {
    TabInfo() { return TabInfo },

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
.the_builder
  .the_builder_new_and_edit
    @extend %padding_top_for_secondary_header
</style>
