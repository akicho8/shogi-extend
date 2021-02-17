<template lang="pug">
.WkbkTopApp
  DebugBox
    p query: {{query}}
    p tag: {{tag}}
    p search_p: {{search_p}}

  p(v-if="$fetchState.error" v-text="$fetchState.error.message")

  .MainContainer
    WkbkTopSidebar(:base="base")
    WkbkTopNavbar(:base="base")
    MainSection
      .container
        WkbkTopSearchAppear(:base="base")
        WkbkTopCardListTag(:base="base")
        WkbkTopCardList(:base="base")
        //- WkbkTopTab(:base="base")
        //- WkbkTopTable(:base="base")

  DebugPre {{$fetchState}}
  DebugPre {{$data}}

  //- .box
  //-   template(v-if="$fetchState.pending")
  //-     | pending
  //-   template(v-else-if="$fetchState.error")
  //-     | error
  //-   template(v-else)
  //-     | htlm
  //-
  //- WkbkTopSidebar(:base="base")
  //- WkbkTopNavbar(:base="base")
  //- .container
  //-   WkbkTopTab(:base="base")
  //-   WkbkTopTable(:base="base")

</template>

<script>
import { Book           } from "../models/book.js"

import { support_parent } from "./support_parent.js"
import { app_table      } from "./app_table.js"
import { app_tabs       } from "./app_tabs.js"
import { app_storage    } from "./app_storage.js"
import { app_columns    } from "./app_columns.js"
import { app_sidebar    } from "./app_sidebar.js"
import { app_search     } from "./app_search.js"

import _ from "lodash"

export default {
  name: "WkbkTopApp",
  mixins: [
    support_parent,
    app_table,
    app_tabs,
    app_storage,
    app_columns,
    app_sidebar,
    app_search,
  ],

  data() {
    return {
      meta: null,
    }
  },

  watch: {
    "$route.query": "$fetch",
  },

  mounted() {
    this.ga_click("インスタント将棋問題集")
  },

  // fetchOnServer: false,
  fetch() {
    // this.__assert__(this.scope, "this.scope")
    this.query       = this.$route.query.query
    // this.scope       = this.$route.query.scope ?? this.scope ?? "everyone" // 引数 -> localStorageの値 -> 初期値 の順で決定
    this.page        = this.$route.query.page
    this.per         = this.$route.query.per
    // this.sort_column = this.$route.query.sort_column ?? "updated_at"
    // this.sort_order  = this.$route.query.sort_order ?? "desc"
    this.tag         = this.$route.query.tag

    // this.url_params とは異なり最終的な初期値を設定する
    const params = {
      query:       this.query,
      // scope:       this.scope,
      page:        this.page,
      per:         this.per,
      // sort_column: this.sort_column,
      // sort_order:  this.sort_order,
      tag:         this.tag,
    }
    return this.$axios.$get("/api/wkbk/tops/index.json", {params}).catch(e => {
      this.$nuxt.error(e.response.data)
      return
    }).then(e => {
      // if (e.error) {
      //   this.$nuxt.error(e.error)
      //   return
      // }
      this.meta = e.meta
      if (this.query || this.tag) {
        this.meta.title = _.compact([this.query, ...this.tags]).join(" ") + ` - ${this.meta.title}`
      }

      // this.tab_index   = this.IndexScopeInfo.fetch(this.scope).code
      this.books       = e.books.map(e => new Book(e))
      this.total       = e.total
      // this.book_counts = e.book_counts
    })
  },

  methods: {
    router_push(params) {
      params = {...this.url_params, ...params}
      params = this.hash_compact_if_blank(params)
      this.$router.push({name: "rack", query: params})
    },
  },

  computed: {
    base() { return this },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.STAGE-development
  .columns
    border: 1px dashed change_color($danger, $alpha: 0.5)
    .column
      border: 1px dashed change_color($primary, $alpha: 0.5)

.WkbkTopApp
  .MainSection.section
    padding: 1.5rem 1.0rem
</style>
