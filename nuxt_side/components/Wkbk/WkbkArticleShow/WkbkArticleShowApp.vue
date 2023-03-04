<template lang="pug">
client-only
  .WkbkArticleShowApp
    DebugBox(v-if="development_p")
      template(v-if="article")
        p article.book_keys: {{article.book_keys}}
        p article.user.id: {{article.user && article.user.id}}
        p g_current_user.id: {{g_current_user && g_current_user.id}}
        p owner_p: {{owner_p}}

    FetchStateErrorMessage(:fetchState="$fetchState")
    b-loading(:active="$fetchState.pending")

    WkbkArticleShowSidebar(:base="base")
    WkbkArticleShowNavbar(:base="base")

    .MainContainer(v-if="!$fetchState.pending && !$fetchState.error")
      .container
        b-tabs.MainTabs(v-model="tab_index" expanded @input="show_tab_change_handle" v-if="article")
          b-tab-item(label="配置")
          b-tab-item
            template(slot="header")
              span.is-inline-flex.is-align-items-center
                | 正解
                b-tag.ml-1(rounded v-if="article.moves_answers.length >= 1") {{article.moves_answers.length}}
          b-tab-item(label="情報")
          b-tab-item
            template(slot="header")
              span 検証

      keep-alive
        WkbkArticleShowPlacement(:base="base"  v-if="current_tab_info.key === 'placement'" ref="WkbkArticleShowPlacement")
        WkbkArticleShowAnswer(:base="base"     v-if="current_tab_info.key === 'answer'" ref="WkbkArticleShowAnswer")
        WkbkArticleShowForm(:base="base"       v-if="current_tab_info.key === 'form'")
        WkbkArticleShowValidation(:base="base" v-if="current_tab_info.key === 'validation'")

    DebugPre(v-if="development_p")
      | {{article}}
      //- | {{books}}
</template>

<script>
import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import dayjs from "dayjs"

import { support_parent } from "./support_parent.js"
import { mod_placement  } from "./mod_placement.js"
import { mod_tabs       } from "./mod_tabs.js"
import { mod_answer     } from "./mod_answer.js"
import { mod_article    } from "./mod_article.js"
import { mod_storage    } from "./mod_storage.js"
import { mod_sidebar    } from "./mod_sidebar.js"
import { mod_tweet    } from "./mod_tweet.js"
import { mod_support    } from "./mod_support.js"
import { mod_kifu_copy_buttons } from "./mod_kifu_copy_buttons.js"

import { Article     } from "../models/article.js"
import { Book        } from "../models/book.js"
// import { LineageInfo } from '../models/lineage_info.js'

export default {
  name: "WkbkArticleShowApp",
  mixins: [
    support_parent,
    mod_placement,
    mod_tabs,
    mod_answer,
    mod_article,
    mod_storage,
    mod_sidebar,
    mod_tweet,
    mod_support,
    mod_kifu_copy_buttons,
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
    const e = await this.$axios.$get("/api/wkbk/articles/show.json", {params})

    this.meta        = e.meta
    // this.LineageInfo = LineageInfo.memory_record_reset(e.LineageInfo)
    this.config      = e.config
    // this.books       = e.books.map(e => new Book(e))
    this.article     = new Article(e.article)

    // 前回保存したときの値を初期値にする
    // if (this.article.new_record_p) {
    //   if (!this.article.book_key) {
    //     this.article.book_key = this.default_book_keys
    //   }
    //   if (!this.article.lineage_key) {
    //     this.article.lineage_key = this.default_lineage_key
    //   }
    // }

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

    // if (process.client) {
    this.validation_tab_handle()
    // } else {
    //   this.form_tab_handle()
    // }
  },

  computed: {
    base()       { return this       },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.STAGE-development
  .WkbkArticleShowApp
    .container
      border: 1px dashed change_color($danger, $alpha: 0.5)
    .columns
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .column
      border: 1px dashed change_color($success, $alpha: 0.5)

.WkbkArticleShowApp
  .MainTabs
    .tab-content
      display: none
</style>
