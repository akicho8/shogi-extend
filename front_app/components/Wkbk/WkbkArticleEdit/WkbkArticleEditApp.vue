<template lang="pug">
client-only
  .WkbkArticleEditApp
    DebugBox
      template(v-if="article")
        p article.book_key: {{article.book_key}}
        p article.user.id: {{article.user && article.user.id}}
        p g_current_user.id: {{g_current_user && g_current_user.id}}
        p owner_p: {{owner_p}}
        p editable_p: {{editable_p}}

    p(v-if="$fetchState.error" v-text="$fetchState.error.message")
    b-loading(:active="$fetchState.pending")

    WkbkArticleEditNavbar(:base="base")

    .MainContainer(v-if="!$fetchState.pending && !$fetchState.error")
      .container
        b-tabs.MainTabs(v-model="tab_index" expanded @input="edit_tab_change_handle" v-if="article")
          b-tab-item(label="配置")
          b-tab-item
            template(slot="header")
              span
                | 正解
                b-tag.ml-1(rounded v-if="article.moves_answers.length >= 1") {{article.moves_answers.length}}
          b-tab-item(label="情報")
          b-tab-item
            template(slot="header")
              span
                | 検証
                b-tag.ml-1(rounded v-if="valid_count >= 1" type="is-primary") OK

      MainSection.is_mobile_padding_zero
       .container
         keep-alive
           WkbkArticleEditPlacement(:base="base"  v-if="current_tab_info.key === 'placement'" ref="WkbkArticleEditPlacement")
           WkbkArticleEditAnswer(:base="base"     v-if="current_tab_info.key === 'answer'" ref="WkbkArticleEditAnswer")
           WkbkArticleEditForm(:base="base"       v-if="current_tab_info.key === 'form'")
           WkbkArticleEditValidation(:base="base" v-if="current_tab_info.key === 'validation'")

    DebugPre
      | {{article}}
      | {{books}}
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

import { Article     } from "../models/article.js"
import { Book        } from "../models/book.js"
import { LineageInfo } from '../models/lineage_info.js'
import { FolderInfo  } from '../models/folder_info.js'

export default {
  name: "WkbkArticleEditApp",
  mixins: [
    support_parent,
    app_placement,
    app_tabs,
    app_answer,
    app_article,
    app_storage,
  ],

  data() {
    return {
      //////////////////////////////////////////////////////////////////////////////// 静的情報
      LineageInfo: null,        // 問題の種類
      config: null,
      books: [],
      meta: null,

      //////////////////////////////////////////////////////////////////////////////// 検証モード
      exam_run_count: null, // 検証モードで手を動かした数
      valid_count:    null, // 検証モードで正解した数
    }
  },

  async fetch() {
    const params = {
      ...this.$route.params,
      ...this.$route.query,
    }
    const e = await this.$axios.$get("/api/wkbk/articles/edit.json", {params}).catch(e => {
      this.$nuxt.error(e.response.data)
      return
    })

    this.meta        = e.meta
    this.LineageInfo = LineageInfo.memory_record_reset(e.LineageInfo)
    this.config      = e.config
    this.books       = e.books.map(e => new Book(e))
    this.article     = new Article(e.article)

    // 前回保存したときの値を初期値にする
    if (this.article.new_record_p) {
      if (!this.article.book_key) {
        this.article.book_key = this.default_book_key
      }
      if (!this.article.lineage_key) {
        this.article.lineage_key = this.default_lineage_key
      }
    }

    this.answer_tab_index = 0 // 解答リストの一番左指す
    this.answer_turn_offset = 0
    this.valid_count = 0

    let performed = false
    if (this.article.new_record_p) {
      if (this.development_p && false) {
        this.$route.query.body = "position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 8c8d 7g7f"
        this.$route.query.viewpoint = "white"
        this.$route.query.turn = 1
      }
      const body = this.$route.query.body
      if (body) {
        this.placement_tab_handle()
        this.extract_confirm({
          default_sp_body: body,
          default_sp_turn: parseInt(this.$route.query.turn ?? -1),
          default_sp_viewpoint: this.$route.query.viewpoint ?? "black",
        })
        performed = true
      }
    }

    if (!performed) {
      // 最初に開くタブの決定
      if (this.article.new_record_p) {
        this.placement_tab_handle()
      }
      if (this.article.persisted_p) {
        this.form_tab_handle()
      }
    }
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
