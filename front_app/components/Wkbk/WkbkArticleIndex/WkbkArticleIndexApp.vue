<template lang="pug">
.WkbkArticleIndexApp
  b-loading(:active="$fetchState.pending")
  .MainContainer(v-if="!$fetchState.pending")
    WkbkArticleIndexSidebar(:base="base")
    WkbkArticleIndexNavbar(:base="base")
    WkbkArticleIndexTab(:base="base")
    WkbkArticleIndexTag(:base="base")
    WkbkArticleIndexTable(:base="base")
</template>

<script>
import MemoryRecord from 'js-memory-record'
import dayjs from "dayjs"

import { support_parent   } from "./support_parent.js"
import { ls_support_mixin } from "@/components/models/ls_support_mixin.js"

import { Article                } from "../models/article.js"
import { LineageInfo             } from "../models/lineage_info.js"
import { FolderInfo              } from "../models/folder_info.js"
import { ArticleIndexColumnInfo } from "../models/article_index_column_info.js"
import { IndexTabInfo            } from "../models/index_tab_info.js"

export default {
  name: "WkbkArticleIndexApp",
  mixins: [
    support_parent,
    ls_support_mixin,
  ],

  data() {
    return {
      sidebar_p: false,
      tab_index:        null,
      visible_hash: null, //  { xxx: true, yyy: false } 形式
      detailed_ids: [],

      //////////////////////////////////////////////////////////////////////////////// 静的情報
      LineageInfo: null,        // 問題の種類
      FolderInfo: null,         // 問題の入れ場所

      //////////////////////////////////////////////////////////////////////////////// 一覧
      articles: null,          // 一覧で表示する配列
      article_counts: {},      // それぞれの箱中の問題数

      // pagination 5点セット
      page_info: {
        total:              null,
        page:               this.$route.query.page,
        per:                this.$route.query.per,
        sort_column:        null,
        sort_order:         null,
        sort_order_default: null,
        //
        folder_key:         null,
        tag:                null,
      },
    }
  },

  fetch() {
    // 有効にすると localStorage をクリアする
    if (false) {
      this.$_ls_reset()
    }

    this.ls_setup()

    this.tab_set("active")
    this.page_info.folder_key = "active"
    return this.async_records_load()
  },

  methods: {
    sidebar_toggle() {
      this.sound_play('click')
      this.sidebar_p = !this.sidebar_p
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
      const params = {
        remote_action: "articles_index_fetch",
        ...this.page_info,
      }
      return this.$axios.$get("/api/wkbk.json", {params}).then(e => {
        this.articles = e.articles.map(e => new Article(e))
        this.page_info = e.page_info
        this.article_counts = e.article_counts // 各フォルダごとの個数
      })
    },

    // 「公開」選択
    folder_active_handle() {
      this.tab_set("active")
      this.folder_change_handle("active")
    },

    // 指定のタブを選択
    tab_set(tab_key) {
      this.tab_index = this.IndexTabInfo.fetch(tab_key).code
    },

    // タブが変更されたとき
    tab_change_handle() {
      this.sound_play("click")
      this.talk(this.current_tab.name)
      this.folder_change_handle(this.current_tab.key)
    },

    // このタブは表示するか？
    // ゴミ箱など常に0なので0のときは表示しない
    // article_tab_available_p(tab_info) {
    //   if (tab_info.hidden_if_empty) {
    //     if (this.article_count_in_tab(tab_info) === 0) {
    //       return false
    //     }
    //   }
    //   return true
    // },

    // このタブのレコード件数
    article_count_in_tab(tab_info) {
      return this.article_counts[tab_info.key] || 0
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
        this.detailed_ids = this.articles.map(e => e.id)
      } else {
        this.detailed_ids = []
      }
    },
  },

  computed: {
    base()                    { return this                                    },
    IndexTabInfo()            { return IndexTabInfo                            },
    ArticleIndexColumnInfo() { return ArticleIndexColumnInfo                 },
    current_tab()             { return this.IndexTabInfo.fetch(this.tab_index) },

    //////////////////////////////////////////////////////////////////////////////// ls_support_mixin

    ls_default() {
      return {
        visible_hash: this.as_visible_hash(ArticleIndexColumnInfo.values),
      }
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkArticleIndexApp
</style>
