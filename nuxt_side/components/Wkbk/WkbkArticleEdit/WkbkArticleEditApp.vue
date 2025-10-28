<template lang="pug">
client-only
  .WkbkArticleEditApp
    DebugBox(v-if="development_p")
      p answer_base_sfen: {{answer_base_sfen}}
      p answer_tab_index: {{answer_tab_index}}
      template(v-if="article")
        p article.book_keys: {{article.book_keys}}
        p article.user.id: {{article.user && article.user.id}}
        p g_current_user.id: {{g_current_user && g_current_user.id}}
        p owner_p: {{owner_p}}
        p editable_p: {{editable_p}}

    FetchStateErrorMessage(:fetchState="$fetchState")
    b-loading(:active="$fetchState.pending")

    WkbkArticleEditNavbar(:base="base")

    .MainContainer(v-if="!$fetchState.pending && !$fetchState.error")
      .container
        b-tabs.MainTabs(v-model="tab_index" expanded @input="edit_tab_change_handle" v-if="article")
          b-tab-item(label="配置")
          b-tab-item
            template(slot="header")
              span.is-inline-flex.is-align-items-center
                | 正解
                b-tag.ml-1(rounded v-if="article.moves_answers.length >= 1") {{article.moves_answers.length}}
          b-tab-item(label="情報")
          b-tab-item
            template(slot="header")
              span.is-inline-flex.is-align-items-center
                | 検証
                b-tag.ml-1(rounded v-if="valid_count >= 1" type="is-primary") OK

      keep-alive
        WkbkArticleEditPlacement(:base="base"  v-if="current_tab_info.key === 'placement'" ref="WkbkArticleEditPlacement")
        WkbkArticleEditAnswer(:base="base"     v-if="current_tab_info.key === 'answer'" ref="WkbkArticleEditAnswer")
        WkbkArticleEditForm(:base="base"       v-if="current_tab_info.key === 'form'")
        WkbkArticleEditValidation(:base="base" v-if="current_tab_info.key === 'validation'")

    DebugPre(v-if="development_p")
      | {{article}}
      | {{books}}
</template>

<script>
import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import dayjs from "dayjs"

import { support_parent        } from "./support_parent.js"
import { mod_placement         } from "./mod_placement.js"
import { mod_tabs              } from "./mod_tabs.js"
import { mod_answer            } from "./mod_answer.js"
import { mod_article           } from "./mod_article.js"
import { mod_storage           } from "./mod_storage.js"
import { mod_article_delete    } from "./mod_article_delete.js"
import { mod_kifu_copy_buttons } from "./mod_kifu_copy_buttons.js"

import { Article     } from "../models/article.js"
import { Book        } from "../models/book.js"
import { LineageInfo } from '../models/lineage_info.js'

export default {
  name: "WkbkArticleEditApp",
  mixins: [
    support_parent,
    mod_placement,
    mod_tabs,
    mod_answer,
    mod_article,
    mod_storage,
    mod_article_delete,
    mod_kifu_copy_buttons,
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

  mounted() {
    if (this.nuxt_login_required()) { return }
  },

  async fetch() {
    const params = {
      ...this.$route.params,
      ...this.$route.query,
    }
    const e = await this.$axios.$get("/api/wkbk/articles/edit.json", {params})

    this.meta        = e.meta
    this.LineageInfo = LineageInfo.memory_record_reset(e.LineageInfo)
    this.config      = e.config
    this.books       = e.books.map(e => new Book(e))
    this.article     = new Article(e.article)

    // 前回保存したときの値を初期値にする
    if (this.article.new_record_p) {
      if (!this.article.book_keys) {
        this.article.book_keys = this.default_book_keys
      }
      if (!this.article.lineage_key) {
        this.article.lineage_key = this.default_lineage_key
      }
      if (!this.article.folder_key) {
        this.article.folder_key = this.default_folder_key
      }
    }

    this.answer_tab_index = 0 // 解答リストの一番左指す
    this.answer_base_turn_offset = 0
    this.valid_count = 0

    // 引数で盤面が指定されたときは配置タブにする
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
        this.sfen_trim_modal_handle({
          default_sp_body: body,
          default_sp_turn: this.param_to_i("turn", -1),
          default_sp_viewpoint: this.$route.query.viewpoint ?? "black",
        })
        performed = true
      }
    }

    // 配置タブになっていないときは new_record_p で判断する
    if (!performed) {
      if (this.article.new_record_p) {
        this.placement_tab_handle()
      }
      if (this.article.persisted_p) {
        // this.form_tab_handle()
        this.answer_tab_handle()
      }
    }
  },

  computed: {
    base() { return this },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.STAGE-development
  .WkbkArticleEditApp
    .container
      border: 1px dashed change_color($danger, $alpha: 0.5)
    .columns
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .column
      border: 1px dashed change_color($success, $alpha: 0.5)

.WkbkArticleEditApp
  .MainTabs
    .tab-content
      display: none
</style>
