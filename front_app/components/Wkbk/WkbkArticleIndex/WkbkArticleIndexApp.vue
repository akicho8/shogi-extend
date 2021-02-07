<template lang="pug">
client-only
  .WkbkArticleIndexApp
    DebugBox
      p visible_hash: {{visible_hash}}
      p scope: {{scope}}({{tab_index}})
      p page: {{page}}

    p(v-if="$fetchState.error" v-text="$fetchState.error.message")

    .MainContainer
      WkbkArticleIndexSidebar(:base="base")
      WkbkArticleIndexNavbar(:base="base")

      .left_and_right
        .left_block.is-hidden-touch
          b-sidebar(position="static" open type="is-white")
            WkbkArticleIndexSidebarBody(:base="base")
        .right_block
          //- WkbkArticleIndexTab(:base="base")
          WkbkArticleIndexTag(:base="base")
          WkbkArticleIndexTable(:base="base")

      //- MainSection
      //- .container.is-fluid
      //- .columns.is-gapless
      //-   .column.is-2
      //-     b-sidebar(left position="static" open fullheight reduce)
      //-       WkbkArticleIndexSidebarBody(:base="base")
      //-   .column
      //-     .right_block
      //-       //- WkbkArticleIndexTab(:base="base")
      //-       WkbkArticleIndexTag(:base="base")
      //-       WkbkArticleIndexTable(:base="base")

    DebugPre {{$data}}
    DebugPre {{$fetchState.pending}}
</template>

<script>
import { Article     } from "../models/article.js"

import { support_parent } from "./support_parent.js"
import { app_table      } from "./app_table.js"
import { app_tabs       } from "./app_tabs.js"
import { app_storage    } from "./app_storage.js"
import { app_columns    } from "./app_columns.js"
import { app_sidebar    } from "./app_sidebar.js"

export default {
  name: "WkbkArticleIndexApp",
  mixins: [
    support_parent,
    app_table,
    app_tabs,
    app_storage,
    app_columns,
    app_sidebar,
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
    this.ga_click("問題リスト")
  },

  fetch() {
    this.scope       = this.$route.query.scope ?? this.scope ?? "everyone" // 引数 -> localStorageの値 -> 初期値 の順で決定。SSRのとき scope は null なのでさらにデフォルト値を設定する必要あり
    this.page        = this.$route.query.page
    this.per         = this.$route.query.per
    this.sort_column = this.$route.query.sort_column ?? "updated_at"
    this.sort_order  = this.$route.query.sort_order ?? "desc"
    this.tag         = this.$route.query.tag

    // this.url_params とは異なり最終的な初期値を設定する
    const params = {
      scope:       this.scope,
      page:        this.page,
      per:         this.per,
      sort_column: this.sort_column,
      sort_order:  this.sort_order,
      tag:         this.tag,
    }

    // this.clog("process.client", process.client)
    // this.clog("process.server", process.server)

    // if (process.client) {
    //   this.play_start()
    // }

    return this.$axios.$get("/api/wkbk/articles/index.json", {params}).catch(e => {
      this.$nuxt.error(e.response.data)
      return
    }).then(e => {
      // if (e.error) {
      //   this.$nuxt.error(e.error)
      //   return
      // }
      this.meta           = e.meta
      // this.tab_index      = this.IndexScopeInfo.fetch(this.scope).code
      this.articles       = e.articles.map(e => new Article(e))
      this.total          = e.total
      // this.article_counts = e.article_counts
    })
  },

  // async fetch() {
  //   this.scope       = this.$route.query.scope ?? this.scope ?? "everyone" // 引数 -> localStorageの値 -> 初期値 の順で決定。SSRのとき scope は null なのでさらにデフォルト値を設定する必要あり
  //   this.page        = this.$route.query.page
  //   this.per         = this.$route.query.per
  //   this.sort_column = this.$route.query.sort_column ?? "updated_at"
  //   this.sort_order  = this.$route.query.sort_order ?? "desc"
  //   this.tag         = this.$route.query.tag
  //
  //   // this.url_params とは異なり最終的な初期値を設定する
  //   const params = {
  //     scope:       this.scope,
  //     page:        this.page,
  //     per:         this.per,
  //     sort_column: this.sort_column,
  //     sort_order:  this.sort_order,
  //     tag:         this.tag,
  //   }
  //
  //   const e = await this.$axios.$get("/api/wkbk/articles/index.json", {params})
  //   if (e.error) {
  //     this.$nuxt.error(e.error)
  //     return
  //   }
  //   this.meta           = e.meta
  //   this.tab_index      = this.IndexScopeInfo.fetch(this.scope).code
  //   this.articles       = e.articles.map(e => new Article(e))
  //   this.total          = e.total
  //   this.article_counts = e.article_counts
  // },

  methods: {
    router_replace(params) {
      params = {...this.url_params, ...params}
      params = this.hash_compact(params)
      this.$router.replace({name: "rack-articles", query: params})
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
  .WkbkArticleIndexApp
    .container
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .left_and_right, .left_block, .right_block
      border: 1px dashed change_color($primary, $alpha: 0.5)

.WkbkArticleIndexApp
  .left_and_right
    display: flex
    .left_block
      .sidebar-content
        box-shadow: unset
    .right_block
      width: 100%
      +mobile
        padding: 0.75rem 0.5rem
      +tablet
        padding: 1rem
</style>
