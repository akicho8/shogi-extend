<template lang="pug">
.WkbkBookIndexApp
  b-loading(:active="$fetchState.pending")
  .MainContainer(v-if="!$fetchState.pending")
    WkbkBookIndexSidebar(:base="base")
    WkbkBookIndexNavbar(:base="base")
    WkbkBookIndexTab(:base="base")
    WkbkBookIndexTable(:base="base")
</template>

<script>
import MemoryRecord from 'js-memory-record'
import dayjs from "dayjs"

import { support_parent   } from "./support_parent.js"
import { ls_support_mixin } from "@/components/models/ls_support_mixin.js"

import { Book                } from "../models/book.js"
import { LineageInfo             } from "../models/lineage_info.js"
import { FolderInfo              } from "../models/folder_info.js"
import { BookIndexColumnInfo } from "../models/book_index_column_info.js"
import { IndexTabInfo            } from "../models/index_tab_info.js"

export default {
  name: "WkbkBookIndexApp",
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
      books: null,          // 一覧で表示する配列
      book_counts: {},      // それぞれの箱中の問題数

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
    }
  },

  fetch() {
    // 有効にすると localStorage をクリアする
    if (false) {
      this.$_ls_reset()
    }

    this.ls_setup()

    this.tab_set("public")
    this.page_info.folder_key = "public"
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
      return this.api_get("books_index_fetch", this.page_info, e => {
        this.books = e.books.map(e => new Book(e))
        this.page_info = e.page_info
        this.book_counts = e.book_counts // 各フォルダごとの個数
      })
    },

    // 「公開」選択
    folder_active_handle() {
      this.tab_set("public")
      this.folder_change_handle("public")
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
    book_tab_available_p(tab_info) {
      if (tab_info.hidden_if_empty) {
        if (this.book_count_in_tab(tab_info) === 0) {
          return false
        }
      }
      return true
    },

    // このタブのレコード件数
    book_count_in_tab(tab_info) {
      return this.book_counts[tab_info.key] || 0
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
        this.detailed_ids = this.books.map(e => e.id)
      } else {
        this.detailed_ids = []
      }
    },
  },

  computed: {
    base()                    { return this                                    },
    IndexTabInfo()            { return IndexTabInfo                            },
    BookIndexColumnInfo() { return BookIndexColumnInfo                 },
    current_tab()             { return this.IndexTabInfo.fetch(this.tab_index) },

    //////////////////////////////////////////////////////////////////////////////// ls_support_mixin

    ls_default() {
      return {
        visible_hash: this.as_visible_hash(BookIndexColumnInfo.values),
      }
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkBookIndexApp
</style>
