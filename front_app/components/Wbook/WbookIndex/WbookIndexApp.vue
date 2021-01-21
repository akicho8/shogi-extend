<template lang="pug">
.WbookIndexApp
  b-loading(:active="$fetchState.pending")
  .MainContainer(v-if="!$fetchState.pending")
    WbookIndexSidebar(:base="base")

    MainNavbar(:spaced="false")
      template(slot="brand")
        NavbarItemHome
        b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'wbook-questions'}") 問題一覧
        template(v-if="page_info.tag")
          b-tag(attached closable @close="tag_search_handle(null)" rounded type="is-dark")
            | {{page_info.tag}}

      template(slot="end")
        NavbarItemLogin
        NavbarItemProfileLink

        //- https://buefy.org/documentation/navbar
        b-navbar-dropdown(arrowless v-if="development_p")
          //- https://pictogrammers.github.io/@mdi/font/5.4.55/
          b-icon(icon="table-row" slot="label")
          template(v-for="e in QuestionIndexColumnInfo.values")
            b-navbar-item.px-4(@click.native.stop="cb_toggle_handle(e)" :key="e.key")
              .has-text-weight-bold(v-if="visible_hash[e.key]")
                | {{e.name}}
              .has-text-grey(v-else)
                | {{e.name}}

        b-navbar-item.has-text-weight-bold.px-5(tag="nuxt-link" :to="{name: 'wbook-questions-new'}" @click.native="sound_play('click')")
          b-icon(icon="plus")

        b-navbar-item(@click="sidebar_toggle")
          b-icon(icon="menu")

    ////////////////////////////////////////////////////////////////////////////////
    b-tabs.mb-0(v-model="tab_index" expanded @input="tab_change_handle")
      template(v-for="e in TabInfo.values")
        b-tab-item(v-if="question_tab_available_p(e)")
          template(slot="header")
            span
              | {{e.name}}
              b-tag(rounded)
                | {{question_count_in_tab(e)}}

    //////////////////////////////////////////////////////////////////////////////// シンプル横並び
    b-field.visible_toggle_checkboxes(grouped group-multiline v-if="false")
      template(v-for="e in QuestionIndexColumnInfo.values")
        .control
          b-checkbox(v-model="visible_hash[e.key]" size="is-small" @input="bool => cb_input_handle(e, bool)")
            | {{e.name}}
    WbookIndexTable(:base="base")
</template>

<script>
import MemoryRecord from 'js-memory-record'
import dayjs from "dayjs"

import { support_parent } from "./support_parent.js"

import { Question    } from "../models/question.js"
import { LineageInfo } from '../models/lineage_info.js'
import { FolderInfo  } from '../models/folder_info.js'

import ls_support_mixin from "@/components/models/ls_support_mixin.js"

import { QuestionIndexColumnInfo } from "../models/question_index_column_info.js"

// 「全体」があったりして構造が異なるのでサーバー側で定義したものを利用していない
class TabInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "all",    name: "全体",   hidden_if_empty: false, },
      { key: "active", name: "公開",   hidden_if_empty: false, },
      { key: "draft",  name: "下書き", hidden_if_empty: true,  },
      { key: "trash",  name: "ゴミ箱", hidden_if_empty: true,  },
    ]
  }

  get handle_method_name() {
    return `${this.key}_handle`
  }
}

export default {
  name: "WbookIndexApp",
  mixins: [
    support_parent,
    ls_support_mixin,
  ],

  data() {
    return {
      sidebar_p: false,
      visible_hash: null, //  { xxx: true, yyy: false } 形式
      detailed_ids: [],

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

      //////////////////////////////////////////////////////////////////////////////// 正解モード
      mediator_snapshot_sfen: null, // 正解モードでの局面

      //////////////////////////////////////////////////////////////////////////////// 検証モード
      exam_run_count: null, // 検証モードで手を動かした数
      valid_count:    null, // 検証モードで正解した数
    }
  },

  fetch() {
    this.ls_setup()
    this.folder_active_handle()
    return this.async_records_load()

    // this.$axios.$get("/api/wbook.json", {params: {remote_action: "question_index_fetch", ...this.$route.query}}).then(e => {
    //   // this.LineageInfo = LineageInfo.memory_record_reset(e.LineageInfo)
    //   // this.FolderInfo  = FolderInfo.memory_record_reset(e.FolderInfo)
    //   // this.config = e.config
    //   // let question = null
    //   // if (e.question) {
    //   //   question = new Question(e.question)
    //   // }
    //   // if (e.question_default_attributes) {
    //   //   const attributes = _.cloneDeep(e.question_default_attributes)
    //   //   question = new Question(attributes)
    //   // }
    //   // this.question_edit_for(question)
    // })
  },

  created() {
    // this.sound_play("click")

    // async asyncData({ $axios, query }) {
    //   const info = await $axios.$get("/api/wbook.json", {params: query})
    //   console.log(info)
    //   return { info }
    // },

    // 一覧用のリソース
    // await this.api_get("builder_form_resource_fetch", {}, e => {
    //   this.LineageInfo = LineageInfo.memory_record_reset(e.LineageInfo)
    //   this.FolderInfo  = FolderInfo.memory_record_reset(e.FolderInfo)
    // })

    // // 指定IDの編集が決まっている場合はそれだけの情報を取得して表示
    // if (this.edit_question_id) {
    //   this.question_edit()
    //   return
    // }
    //
    // if (this.info.warp_to === "builder_haiti" || this.info.warp_to === "builder_form") {
    //   this.builder_new_handle()
    //   return
    // }

    // this.$ga.event("open", {event_category: "問題一覧"})
    // this.folder_active_handle()
    // this.ls_setup()
  },

  mounted() {
    // 有効にすると localStorage をクリアする
    if (false) {
      this.$_ls_reset()
    }
  },

  methods: {
    sidebar_toggle() {
      this.sound_play('click')
      this.sidebar_p = !this.sidebar_p
    },

    ov_question_info_set(id) {
    },

    ////////////////////////////////////////////////////////////////////////////////

    tag_search_handle(tag) {
      this.sound_play("click")
      this.talk(tag)
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
      return this.api_get("questions_index_fetch", this.page_info, e => {
        this.questions = e.questions.map(e => new Question(e))
        this.page_info = e.page_info
        this.question_counts = e.question_counts // 各フォルダごとの個数
      })
    },

    // 「公開」選択
    folder_active_handle() {
      this.question_mode_select("active")
      this.folder_change_handle("active")
    },

    // 指定のタブを選択
    question_mode_select(tab_key) {
      this.tab_index = this.TabInfo.fetch(tab_key).code
    },

    // タブが変更されたとき
    tab_change_handle() {
      this.sound_play("click")
      this.talk(this.tab_info.name)
      this.folder_change_handle(this.tab_info.key)
    },

    // このタブは表示するか？
    // ゴミ箱など常に0なので0のときは表示しない
    question_tab_available_p(tab_info) {
      if (tab_info.hidden_if_empty) {
        if (this.question_count_in_tab(tab_info) === 0) {
          return false
        }
      }
      return true
    },
    // このタブのレコード件数
    question_count_in_tab(tab_info) {
      return this.question_counts[tab_info.key] || 0
    },

    // チェックボックスが変更されたとき
    cb_input_handle(column, bool) {
      this.sound_play('click')
      if (bool) {
        this.talk(column.name)
      }
    },

    // チェックボックスをトグルする
    cb_toggle_handle(column) {
      this.sound_play('click')
      this.$set(this.visible_hash, column.key, !this.visible_hash[column.key])
      if (this.visible_hash[column.key]) {
        this.talk(column.name)
      }
    },

    //////////////////////////////////////////////////////////////////////////////// details
    detail_set(enabled) {
      this.sound_play('click')
      if (enabled) {
        this.detailed_ids = this.questions.map(e => e.id)
      } else {
        this.detailed_ids = []
      }
    },
  },

  computed: {
    base()                    { return this                               },
    TabInfo()                 { return TabInfo                            },
    QuestionIndexColumnInfo() { return QuestionIndexColumnInfo            },
    tab_info()                { return this.TabInfo.fetch(this.tab_index) },

    //////////////////////////////////////////////////////////////////////////////// ls_support_mixin

    ls_default() {
      return {
        visible_hash: this.as_visible_hash(QuestionIndexColumnInfo.values),
      }
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.WbookIndexApp
  .dropdown-menu
    min-width: 0
    a:focus
      outline: none

  .visible_toggle_checkboxes
    margin-top: 1.5rem
    justify-content: center

  .b-tabs
    .tab-content
      display: none
</style>
