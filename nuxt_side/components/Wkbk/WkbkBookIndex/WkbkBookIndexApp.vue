<template lang="pug">
.WkbkBookIndexApp
  client-only
    DebugBox(v-if="development_p")
      p visible_hash: {{visible_hash}}
      p scope: {{scope}}({{tab_index}})
      p page: {{page}}

    FetchStateErrorMessage(:fetchState="$fetchState")

    .MainContainer
      WkbkBookIndexSidebar(:base="base")
      WkbkBookIndexNavbar(:base="base")

      .left_and_right
        .left_block.is-hidden-touch
          b-sidebar(position="static" open type="is-white")
            WkbkBookIndexSidebarBody(:base="base")
        .right_block
          //- WkbkBookIndexTab(:base="base")
          WkbkBookIndexTable(:base="base")

    DebugPre(v-if="development_p") {{$fetchState}}
    DebugPre(v-if="development_p") {{$data}}

    //- .box
    //-   template(v-if="$fetchState.pending")
    //-     | pending
    //-   template(v-else-if="$fetchState.error")
    //-     | error
    //-   template(v-else)
    //-     | htlm
    //-
    //- WkbkBookIndexSidebar(:base="base")
    //- WkbkBookIndexNavbar(:base="base")
    //- .container
    //-   WkbkBookIndexTab(:base="base")
    //-   WkbkBookIndexTable(:base="base")

</template>

<script>
import { Book        } from "../models/book.js"

import { support_parent } from "./support_parent.js"
import { mod_table      } from "./mod_table.js"
import { mod_tabs       } from "./mod_tabs.js"
import { mod_storage    } from "./mod_storage.js"
import { mod_columns    } from "./mod_columns.js"
import { mod_sidebar    } from "./mod_sidebar.js"

export default {
  name: "WkbkBookIndexApp",
  mixins: [
    support_parent,
    mod_table,
    mod_tabs,
    mod_storage,
    mod_columns,
    mod_sidebar,
  ],

  data() {
    // console.log("[data]")
    return {
      meta: null,
    }
  },

  watch: {
    "$route.query": "$fetch",
  },

  mounted() {
    // console.log("[mounted]")
    this.app_log("問題集一覧")
  },

  // fetchOnServer: false,
  fetch() {
    // console.log("[fetch]")
    // this.$GX.assert(this.scope, "this.scope")

    // this.scope       = this.$route.query.scope ?? this.scope ?? "everyone" // 引数 -> localStorageの値 -> 初期値 の順で決定
    this.page        = this.$route.query.page
    this.per         = this.$route.query.per || this.WkbkConfig.value_of("per_page")
    this.sort_column = this.$route.query.sort_column ?? "updated_at"
    this.sort_order  = this.$route.query.sort_order ?? "desc"
    this.tag         = this.$route.query.tag

    // this.url_params とは異なり最終的な初期値を設定する
    const params = {
      // scope:       this.scope,
      page:        this.page,
      per:         this.per,
      sort_column: this.sort_column,
      sort_order:  this.sort_order,
      tag:         this.tag,
    }

    return this.$axios.$get("/api/wkbk/books/index.json", {params}).then(e => {
      this.meta        = e.meta
      // this.tab_index   = this.IndexScopeInfo.fetch(this.scope).code
      this.books       = e.books.map(e => new Book(e))
      this.total       = e.total
      // this.book_counts = e.book_counts
    })
  },

  methods: {
    router_push(params) {
      params = {...this.url_params, ...params}
      params = this.$GX.hash_compact(params)
      this.$router.push({name: "rack-books", query: params})
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
  .WkbkBookIndexApp
    .container
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .left_and_right, .left_block, .right_block
      border: 1px dashed change_color($primary, $alpha: 0.5)

.WkbkBookIndexApp
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
