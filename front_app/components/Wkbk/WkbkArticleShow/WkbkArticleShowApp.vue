<template lang="pug">
client-only
  .WkbkArticleShowApp
    DebugBox
      template(v-if="article")
        p article.book_id: {{article.book_id}}
        p article.user.id: {{article.user && article.user.id}}
        p g_current_user.id: {{g_current_user && g_current_user.id}}
        p owner_p: {{owner_p}}
        p editable_p: {{editable_p}}

    p(v-if="$fetchState.error" v-text="$fetchState.error.message")
    b-loading(:active="$fetchState.pending")

    WkbkArticleShowSidebar(:base="base")
    WkbkArticleShowNavbar(:base="base")

    .MainContainer(v-if="!$fetchState.pending && !$fetchState.error")
      .container
        b-tabs.MainTabs(v-model="tab_index" expanded @input="show_tab_change_handle" v-if="article")
          b-tab-item(label="配置")
          b-tab-item
            template(slot="header")
              span
                | 正解
                b-tag.ml-1(rounded v-if="article.moves_answers.length >= 1") {{article.moves_answers.length}}
          b-tab-item(label="情報")
          b-tab-item
            template(slot="header")
              span 検証

        MainSection.is_mobile_padding_zero
         .container
           keep-alive
             WkbkArticleShowPlacement(:base="base"  v-if="current_tab_info.key === 'placement'" ref="WkbkArticleShowPlacement")
             WkbkArticleShowAnswer(:base="base"     v-if="current_tab_info.key === 'answer'" ref="WkbkArticleShowAnswer")
             WkbkArticleShowForm(:base="base"       v-if="current_tab_info.key === 'form'")
             WkbkArticleShowValidation(:base="base" v-if="current_tab_info.key === 'validation'")

    DebugPre
      | {{article}}
      //- | {{books}}
</template>

<script>
import MemoryRecord from 'js-memory-record'
import dayjs from "dayjs"

import { support_parent } from "./support_parent.js"
import { app_placement  } from "./app_placement.js"
import { app_tabs       } from "./app_tabs.js"
import { app_answer     } from "./app_answer.js"
import { app_article    } from "./app_article.js"
import { app_storage    } from "./app_storage.js"
import { app_sidebar    } from "./app_sidebar.js"

import { Article     } from "../models/article.js"
import { Book        } from "../models/book.js"
// import { LineageInfo } from '../models/lineage_info.js'
import { FolderInfo  } from '../models/folder_info.js'

export default {
  name: "WkbkArticleShowApp",
  mixins: [
    support_parent,
    app_placement,
    app_tabs,
    app_answer,
    app_article,
    app_storage,
    app_sidebar,
  ],

  data() {
    return {
      //////////////////////////////////////////////////////////////////////////////// 静的情報
      // LineageInfo: null,        // 問題の種類
      config: null,
      // books: [],
      meta: null,
    }
  },

  async fetch() {
    const params = {
      ...this.$route.params,
      ...this.$route.query,
    }
    const e = await this.$axios.$get("/api/wkbk/articles/show.json", {params}).catch(e => {
      this.$nuxt.error(e.response.data)
      return
    })

    this.meta        = e.meta
    // this.LineageInfo = LineageInfo.memory_record_reset(e.LineageInfo)
    this.config      = e.config
    // this.books       = e.books.map(e => new Book(e))
    this.article     = new Article(e.article)

    // 前回保存したときの値を初期値にする
    if (this.article.new_record_p) {
      if (!this.article.book_id) {
        this.article.book_id = this.default_book_id
      }
      if (!this.article.lineage_key) {
        this.article.lineage_key = this.default_lineage_key
      }
    }

    this.answer_tab_index = 0 // 解答リストの一番左指す
    // this.answer_turn_offset = 0
    // this.valid_count = 0

    // if (!performed) {
    //   // 最初に開くタブの決定
    //   if (this.article.new_record_p) {
    //     this.placement_tab_handle()
    //   }
    //   if (this.article.persisted_p) {
    //     this.form_tab_handle()
    //   }
    // }
    this.validation_tab_handle()
  },

  computed: {
    base()       { return this       },
    FolderInfo() { return FolderInfo },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.STAGE-development
  .WkbkArticleShowApp
    .container
      border: 1px dashed change_color($danger, $alpha: 0.5)
    .columns.is-gapless
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .column
      border: 1px dashed change_color($success, $alpha: 0.5)

.WkbkArticleShowApp
  .MainSection.section
    padding: 0

  .MainTabs
    .tab-content
      display: none
</style>
