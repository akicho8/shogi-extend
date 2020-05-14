<template lang="pug">
.the_builder
  //- a.delete.is-large(@click="$parent.lobby_handle")
  .columns.is-centered
    .column
      .buttons.is-centered
        b-button.has-text-weight-bold(@click="builder_index_handle" :type="{'is-primary': !question}") 問題一覧
        b-button.has-text-weight-bold(@click="builder_new_handle" :type="{'is-primary': (question && question_new_record_p)}") 新規作成

      template(v-if="!question")
        the_builder_index

      template(v-if="question")
        //- b-field.switch_grouped_container(grouped position="is-centered")
        //-   .control
        //-     b-switch(v-model="sp_run_mode" true-value="edit_mode" false-value="play_mode") 編集

        //- template(v-for="(e, i) in question.moves_answers")
        //-   b-tag
        //-     | {{i + 1}}

        //- b-field(position="is-centered" grouped)
        //-   p.control
        //-     b-button(@click="edit_mode_handle" type="{'is-primary': sp_run_mode === 'edit_mode'") 配置
        //-   p.control
        //-     b-button(@click="play_mode_handle" type="{'is-primary': sp_run_mode === 'edit_mode'") 正解
        //-   p.control
        //-     b-button(@click="edit_mode_handle" type="{'is-primary': sp_run_mode === 'edit_mode'") 情報
        //-   b-button(@click="edit_mode_handle" type="{'is-primary': sp_run_mode === 'edit_mode'") 情報

        //- b-field(position="is-centered")
        //-   b-radio-button(v-model="sp_run_mode" native-value="edit_mode" @click.native="edit_mode_handle") 配置
        //-   b-radio-button(v-model="sp_run_mode" native-value="play_mode" @click.native="play_mode_handle") 正解

        b-tabs.main_tabs(v-model="edit_tab_index" expanded @change="tab_change_handle")
          b-tab-item(label="配置")
            shogi_player(
              :run_mode="'edit_mode'"
              :kifu_body="position_sfen_add(question.fixed_init_sfen)"
              :start_turn="-1"
              :key_event_capture="false"
              :slider_show="true"
              :controller_show="true"
              :theme="'simple'"
              :size="'default'"
              :sound_effect="false"
              :volume="0.5"
              @update:edit_mode_snapshot_sfen="edit_mode_snapshot_sfen"
              )
          b-tab-item
            template(slot="header")
              span
                | 正解
                b-tag(rounded) {{question.moves_answers.length}}
            the_builder_play(ref="the_builder_play")

          b-tab-item(label="情報")
            the_builder_form

          b-tab-item
            template(slot="header")
              span
                | 検証
                b-tag(rounded) {{valid_count}}

            shogi_player(
              :run_mode="'play_mode'"
              :kifu_body="`position sfen ${question.init_sfen}`"
              :start_turn="0"
              :key_event_capture="false"
              :slider_show="true"
              :controller_show="true"
              :theme="'simple'"
              :size="'default'"
              :sound_effect="true"
              :volume="0.5"
              @update:play_mode_advanced_moves="play_mode_advanced_moves_set"
              )

        hr
        .save_container
          .buttons.is-centered
            b-button.has-text-weight-bold(@click="save_handle" :type="save_button_type") {{crete_or_upate_name}}
            //- b-button.has-text-weight-bold(@click="back_to_index_handle") 一覧に戻る

  .columns(v-if="development_p")
    .column
      debug_print
</template>

<script>
import consumer from "channels/consumer"
import MemoryRecord from 'js-memory-record'
import dayjs from "dayjs"

class EditTabInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "edit_mode", name: "配置", },
      { key: "play_mode", name: "正解", },
      { key: "form_mode", name: "情報", },
      { key: "exam_mode", name: "検証", },
    ]
  }

  get handle_method_name() {
    return `${this.key}_handle`
  }
}

import support from "./support.js"
import the_builder_index from "./the_builder_index"
import the_builder_play from "./the_builder_play"
import the_builder_form from "./the_builder_form"

export default {
  name: "the_builder",
  mixins: [
    support,
  ],
  components: {
    the_builder_index,
    the_builder_play,
    the_builder_form,
  },
  props: {
    info: { required: true },
  },
  data() {
    return {
      // editモード index
      questions: null,

      // editモード edit
      sp_run_mode: null,
      edit_tab_index: null,
      question: null,
      time_limit_clock: null,   // b-timepicker 用 (question.time_limit_sec から変換する)
      answer_tab_index: null,   // 表示している正解タブの位置

      // pagination 5点セット
      total:              this.info.total,
      page:               this.info.page,
      per:                this.info.per,
      sort_column:        this.info.sort_column,
      sort_order:         this.info.sort_order,
      sort_order_default: this.info.sort_order_default,

      answer_turn_offset:     null, // 正解モードでの手数
      mediator_snapshot_sfen: null, // 正解モードでの局面
      $exam_run_count:        null, // 検証モードで手を動かした数
      valid_count:           null, // 検証モードで正解した数
    }
  },

  created() {
    this.app.lobby_close()

    this.sound_play("click")
    this.builder_index_handle()
    // this.exam_mode_handle()
  },

  watch: {
  },

  methods: {
    edit_mode_snapshot_sfen(sfen) {
      if (this.sp_run_mode === "edit_mode") {
        sfen = this.position_sfen_remove(sfen)

        // console.log(this.question.init_sfen)
        // console.log(sfen)

        if (this.question.init_sfen !== sfen) {
          this.debug_alert(`初期配置取得 ${sfen}`)
          this.$set(this.question, "init_sfen", sfen)

          // 合わせて正解も削除する
          if (this.question.moves_answers.length >= 1) {
            this.ok_notice("元の配置を変更したので正解を削除しました")
            this.moves_answers_clear()
          }

          // 検証してない状態にする
          this.valid_count = 0
        }
      }
    },

    current_moves_str() {
      return this.$refs.the_builder_play.$refs.play_sp.moves_take_turn_offset.join(" ")
    },

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

    kotae_delete_handle(index) {
      const new_ary = this.question.moves_answers.filter((e, i) => i !== index)
      this.$set(this.question, "moves_answers", new_ary)
      this.$nextTick(() => this.answer_tab_index = _.clamp(this.answer_tab_index, 0, this.question.moves_answers.length - 1))
      this.ok_notice("削除しました")
    },

    full_sfen_build(moves_answer_attributes) {
      return ["position", "sfen", this.question.init_sfen, "moves", moves_answer_attributes.moves_str].join(" ")
    },

    ////////////////////////////////////////////////////////////////////////////////

    edit_mode_handle() {
      this.sp_run_mode = "edit_mode"
      this.edit_tab_index = EditTabInfo.fetch("edit_mode").code
    },

    play_mode_handle() {
      this.sp_run_mode = "play_mode"
      this.edit_tab_index = EditTabInfo.fetch("play_mode").code

      // この方法でも取得できる
      // if (this.$refs.play_sp) {
      //   this.$set(this.question, "init_sfen", this.$refs.play_sp.mediator.sfen_serializer.to_s)
      // }

      // this.$nextTick(() => {
      //   if (this.question.init_sfen == null) {
      //     const init_sfen = this.$refs.play_sp.init_sfen.replace(/position sfen /, "")
      //     this.debug_alert(`初期配置取得 ${init_sfen}`)
      //     this.$set(this.question, "init_sfen", init_sfen)
      //   }
      // })
    },

    form_mode_handle() {
      this.edit_tab_index = EditTabInfo.fetch("form_mode").code
    },

    exam_mode_handle() {
      this.edit_tab_index = EditTabInfo.fetch("exam_mode").code
      this.$exam_run_count = 0
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

    tab_change_handle() {
      this[this.edit_tab_info.handle_method_name]()
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

      const params = {question: { ...this.question, time_limit_sec: time_limit_sec }}

      // .add(this.question.time_limit_sec, "second").toDate()

      // params.set("question.description", this.question.description)
      // params.set("init_sfen", this.init_sfen)
      // params.set("answers", this.answers)

      const before_crete_or_upate_name = this.crete_or_upate_name
      this.http_command("PUT", this.info.put_path, params, e => {
        if (e.error_message) {
          this.warning_notice(e.error_message)
        }
        if (e.question) {
          // 別に更新する必要はないけどサーバー側から他の情報が追加されているかもしれない
          this.question = e.question

          // alert(this.time_limit_clock)
          // dayjs("2000-01-01T00:03:00+09:00").toDate()
          // this.time_limit_clock = dayjs(this.time_limit_clock).toDate()
          // console.log(this.time_limit_clock)
          this.time_limit_clock_set()
          this.ok_notice(`${before_crete_or_upate_name}しました`)
        }
      })
    },

    // 「新規作成」ボタン
    builder_new_handle() {
      this.question_edit_of(this.question_default())
    },

    // 問題の初期値
    question_default() {
      return this.info.question_default
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

    question_edit_of(row) {
      this.sound_play("click")
      this.question = row

      // 更新した init_sfen が shogi-player の kifu_body に渡ると循環する副作用で駒箱が消えてしまうため別にする
      this.$set(this.question, "fixed_init_sfen", this.question.init_sfen)

      this.time_limit_clock_set()

      this.answer_tab_index = 0 // 解答リストの一番左指す
      this.answer_turn_offset = 0
      this.valid_count = 0

      if (this.question_new_record_p) {
        this.edit_mode_handle()
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
      this.http_get_command(this.info.put_path, {
        questions_fetch: true,
        page:               this.page,
        per:                this.per,
        sort_column:        this.sort_column,
        sort_order:         this.sort_order,
        sort_order_default: this.sort_order_default,
      }, e => {
        if (e.error_message) {
          this.warning_notice(e.error_message)
        }
        if (e.questions) {
          this.questions   = e.questions

          this.total              = e.total
          this.page               = e.page
          this.per                = e.per
          this.sort_column        = e.sort_column
          this.sort_order         = e.sort_order
          this.sort_order_default = e.sort_order_default
        }
      })
    },

    play_mode_advanced_moves_set(moves) {
      if (this.question.moves_answers.length === 0) {
        if (this.$exam_run_count === 0) {
          this.warning_notice("正解を作ってからやってください")
        }
      }
      if (this.question.moves_answers.some(e => e.moves_str === moves.join(" "))) {
        this.sound_play("o")
        this.ok_notice("正解")
        this.valid_count += 1
      }
      this.$exam_run_count += 1
    },

    turn_offset_set(v) {
      this.answer_turn_offset = v
    },

    mediator_snapshot_sfen_set(sfen) {
      this.mediator_snapshot_sfen = this.position_sfen_remove(sfen)
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
    edit_tab_info() {
      return EditTabInfo.fetch(this.edit_tab_index)
    },

    crete_or_upate_name() {
      if (this.question.id) {
        return "更新"
      } else {
        return "作成"
      }
    },

    start_level_max() {
      return 5
    },

    base_clock() {
      return dayjs("2000-01-01T00:00:00+09:00")
    },

    save_button_type() {
      if (this.question.moves_answers.length >= 1) {
        return "is-primary"
      }
    },

    question_new_record_p() {
      if (this.question) {
        return this.question.id == null
      }
    },

    // candidate_columns() {
    //   return [
    //     { field: "順位",       label: "順位",       sortable: true, numeric: true, },
    //     { field: "候補手",     label: "候補手",                                    },
    //     { field: "読み筋",     label: "読み筋",                                    },
    //     { field: "▲形勢",     label: "▲形勢",     sortable: true, numeric: true, },
    //     { field: "評価局面数", label: "評価局面数", sortable: true, numeric: true, },
    //     { field: "処理時間",   label: "処理時間",   sortable: true, numeric: true, },
    //   ]
    // },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_builder
  //////////////////////////////////////////////////////////////////////////////// 編集

  // position: relative
  // .delete
  //   position: absolute
  //   top: 0rem
  //   right: 0rem
  //   z-index: 1

  // .switch_grouped_container
  //   margin-top: 0.5rem
  .main_tabs
    .tab-content
      padding: 0
      padding-top: 0.75rem
    .tag
      margin-left: 0.5rem

  // この手順を正解にする
  .konotejunsiikai
    margin-top: 0.3rem

  // 正解のタブ
  .answer_tabs
    margin-top: 0.8rem
    .tab-content
      padding: 0.8rem 0
      position: relative
      .delete_button
        position: absolute
        top: 0.5rem
        right: 0.5rem

  ////////////////////////////////////////////////////////////////////////////////
  .save_container

  //////////////////////////////////////////////////////////////////////////////// 共通
</style>
