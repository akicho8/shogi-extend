// import Vuex from "vuex"
// import builder from "the_builder/store.js"

import { LineageInfo } from '../models/lineage_info.js'
import { FolderInfo  } from '../models/folder_info.js'
import { Question    } from "../models/question.js"

export const builder = {
  namespaced: true,
  state() {
    return {
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
  },
}
