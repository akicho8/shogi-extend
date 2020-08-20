// import Vuex from "vuex"
// import builder from "the_builder/store.js"

import { LineageInfo } from '../models/lineage_info.js'
import { FolderInfo  } from '../models/folder_info.js'
import { Question    } from "../models/question.js"
import Vue from 'vue'

export const builder = {
  namespaced: true,
  state() {
    return {
      builder_app: null,

      // //////////////////////////////////////////////////////////////////////////////// 静的情報
      LineageInfo: null,        // 問題の種類
      FolderInfo: null,         // 問題の入れ場所
      builder_form_resource_fetched_p: false, // ↑これらを読み込み終わったか？

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
      answer_tab_index: null,   // 表示している正解タブの位置

      //////////////////////////////////////////////////////////////////////////////// 正解モード
      answer_turn_offset:     null, // 正解モードでの手数
      mediator_snapshot_sfen: null, // 正解モードでの局面

      //////////////////////////////////////////////////////////////////////////////// 検証モード
      exam_run_count: null, // 検証モードで手を動かした数
      valid_count:    null, // 検証モードで正解した数

      gvar2: null,
      question: null,
    }
  },
  getters: {
    current_gvar2(state, getters, rootState, rootGetter) {
      return state.gvar2
    },
    current_gvar2_variant(state, getters) {
      return `(${getters.current_gvar2})`
    },
  },

  // 同期更新
  mutations: {
    // this.$store.commit("resource_set", "foo")
    resource_set(state, e) {
      state.LineageInfo = LineageInfo.memory_record_reset(e.LineageInfo)
      state.FolderInfo  = FolderInfo.memory_record_reset(e.FolderInfo)
      state.builder_form_resource_fetched_p = true
    },

    records_set(state, e) {
      state.questions       = e.questions.map(e => new Question(e))
      state.page_info       = e.page_info
      state.question_counts = e.question_counts // 各フォルダごとの個数
    },

    turn_offset_set(state, turn) {
      state.answer_turn_offset = turn
    },

    mediator_snapshot_sfen_set(state, sfen) {
      state.mediator_snapshot_sfen = sfen
    },

  },

  actions: {
    // this.$store.dispatch('resource_set', 'foo')
    async resource_fetch({state, rootState, dispatch, commit, getters, rootGetters}, payload) {
      // debugger
      // console.log(state)
      // console.log(rootState)
      // console.log(getters["app"])
      // console.log(rootGetters["app"])

      // 一覧用のリソース
      return rootState.app.api_get("builder_form_resource_fetch", {}, e => {
        commit('resource_set', e)
        // rootState.app.ok_notice("ok")
      })
    },

    async records_fetch({state, rootState, dispatch, commit, getters, rootGetters}) {
      return rootState.app.api_get("questions_fetch", state.page_info, e => {
        commit('records_set', e)
      })
    },

    builder_index_handle({state, rootState, dispatch, commit, getters, rootGetters}, event = null) {
      if (event) {
        rootState.app.sound_play("click")
      }
      state.question = null
    },

    async tag_search_handle({state, rootState, dispatch, commit, getters, rootGetters}, tag) {
      rootState.app.sound_play("click")
      rootState.app.say(tag)
      state.page_info.tag = tag
      return dispatch("records_fetch")
    },

    edit_mode_snapshot_sfen_set({state, rootState, dispatch, commit, getters, rootGetters}, sfen) {
      if (state.question.init_sfen !== sfen) {
        rootState.app.debug_alert(`配置取得 ${sfen}`)
        state.question.init_sfen = sfen

        // 合わせて正解も削除する
        if (state.question.moves_answers.length >= 1) {
          rootState.app.ok_notice("元の配置を変更したので正解を削除しました")
          dispatch("moves_answers_clear")
        }

        // 検証してない状態にする
        state.valid_count = 0
      }
    },

    // 正解だけを削除
    moves_answers_clear({state, rootState, dispatch, commit, getters, rootGetters}, payload) {
      Vue.set(state.question, "moves_answers", [])
      state.answer_tab_index = 0
    },

    play_mode_advanced_moves_set({state, rootState, dispatch, commit, getters, rootGetters}, moves) {
      if (state.question.moves_answers.length === 0) {
        if (state.exam_run_count === 0) {
          rootState.app.warning_notice("正解を作ってからやってください")
        }
      }
      if (state.question.moves_valid_p(moves)) {
        rootState.app.sound_play("o")
        rootState.app.ok_notice("正解")
        state.valid_count += 1
      }
      state.exam_run_count += 1
    },

    // 「この手順を正解とする」
    edit_stock_handle({state, rootState, dispatch, commit, getters, rootGetters}, payload) {
      const moves = payload.moves
      const app = rootState.app

      if (moves.length === 0) {
        app.warning_notice("1手以上動かしてください")
        return
      }

      {
        const limit = app.app.config.turm_max_limit
        if (limit && moves.length > limit) {
          app.warning_notice(`${app.app.config.turm_max_limit}手以内にしてください`)
          return
        }
      }

      if (state.question.moves_valid_p(moves)) {
        app.warning_notice("すでに同じ正解があります")
        return
      }

      state.question.moves_answers.push({moves_str: moves.join(" "), end_sfen: state.mediator_snapshot_sfen})
      Vue.nextTick(() => state.answer_tab_index = state.question.moves_answers.length - 1)

      app.sound_play("click")
      app.ok_notice(`${state.question.moves_answers.length}つ目の正解を追加しました`, {onend: () => {
        if (state.question.moves_answers.length === 1) {
          app.ok_notice(`他の手順で正解がある場合は続けて追加してください`)
        }
      }})
    },

    // 「新規作成」ボタン
    builder_new_handle({state, rootState, dispatch, commit, getters, rootGetters}) {
      const attributes = _.cloneDeep(rootState.app.info.question_default_attributes)
      const question = new Question(attributes)
      dispatch("question_edit_for", question)
    },

    question_edit_for({state, rootState, dispatch, commit, getters, rootGetters}, row) {
      const app = rootState.app

      app.sound_play("click")
      app.__assert__(row instanceof Question, `問題が Question でラップされてない ${Question.name}`)
      state.question = row

      state.answer_tab_index   = 0 // 解答リストの一番左指す
      state.answer_turn_offset = 0
      state.valid_count        = 0

      if (app.info.warp_to === "builder_haiti") {
        dispatch("haiti_mode_handle")
        return
      }
      if (app.info.warp_to === "builder_form") {
        dispatch("form_mode_handle")
        return
      }

      // 最初に開くタブの決定
      if (app.question_new_record_p) {
        dispatch("haiti_mode_handle")
      } else {
        dispatch("form_mode_handle")
      }
    },

    question_edit({state, rootState, dispatch, commit, getters, rootGetters}) {
      // 指定IDの編集が決まっている場合はそれだけの情報を取得して表示
      if (rootState.app.edit_question_id) {
        rootState.app.api_get("question_edit_fetch", {question_id: rootState.app.edit_question_id}, e => {
          rootState.app.edit_question_id = null
          this.question_edit_for(new Question(e.question))
        })
      }
    },

    mode_select({state, rootState, dispatch, commit, getters, rootGetters}, tab_key) {
      state.tab_index = TabInfo.fetch(tab_key).code
    },

    edit_tab_change_handle({state, rootState, dispatch, commit, getters, rootGetters}, v) {
      rootState.app.sound_play("click")
      if (false) {
        rootState.app.say(this.current_tab_info.name)
      }
      this[this.current_tab_info.handle_method_name]()
    },

    //////////////////////////////////////////////////////////////////////////////// 各タブ切り替えた直後の初期化処理

    haiti_mode_handle({state, rootState, dispatch, commit, getters, rootGetters}) {
      this.mode_select("haiti_mode")
    },

    seikai_mode_handle({state, rootState, dispatch, commit, getters, rootGetters}) {
      this.mode_select("seikai_mode")
    },

    form_mode_handle({state, rootState, dispatch, commit, getters, rootGetters}) {
      this.mode_select("form_mode")
    },

    kensho_mode_handle({state, rootState, dispatch, commit, getters, rootGetters}) {
      this.mode_select("kensho_mode")
      state.exam_run_count = 0
      rootState.app.say(this.question.direction_message)
    },

    ////////////////////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////////////////////

    question_save_handle({state, rootState, dispatch, commit, getters, rootGetters}) {
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
          state.question = new Question(e.question)

          this.sound_play("click")
          this.ok_notice(`${before_save_button_name}しました`)

          if (rootState.app.config.save_and_back_to_index) {
            dispatch("builder_index_handle")
          }
        }
      })
    },

    back_to_index_handle({state, rootState, dispatch, commit, getters, rootGetters}) {
      dispatch("builder_index_handle")
    },

    page_change_handle({state, rootState, dispatch, commit, getters, rootGetters}, page) {
      state.page_info.page = page
      dispatch("records_fetch")
    },

    sort_handle({state, rootState, dispatch, commit, getters, rootGetters}, {column, order}) {
      state.page_info.sort_column = column
      state.page_info.sort_order = order
      dispatch("records_fetch")
    },

    folder_change_handle({state, rootState, dispatch, commit, getters, rootGetters}, folder_key) {
      state.page_info.folder_key = folder_key
      dispatch("records_fetch")
    },
  },
}
