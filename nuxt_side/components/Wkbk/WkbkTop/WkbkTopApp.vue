<template lang="pug">
.WkbkTopApp
  DebugBox(v-if="development_p")
    p query: {{query}}
    p tag: {{tag}}

  FetchStateErrorMessage(:fetchState="$fetchState")

  WkbkTopSidebar(:base="base")
  WkbkTopNavbar(:base="base")

  MainSection.when_mobile_footer_scroll_problem_workaround
    .container.is-fluid
      WkbkTopTagList(:base="base")
      WkbkTopContent(:base="base")

  DebugPre(v-if="development_p") {{$fetchState}}
  DebugPre(v-if="development_p") {{$data}}
</template>

<script>
import { Book           } from "../models/book.js"
import { XpageInfo } from "../../models/xpage_info.js"

import { support_parent } from "./support_parent.js"
import { mod_table      } from "./mod_table.js"
import { mod_tabs       } from "./mod_tabs.js"
import { mod_storage    } from "./mod_storage.js"
import { mod_columns    } from "./mod_columns.js"
import { mod_sidebar    } from "./mod_sidebar.js"
import { mod_search     } from "./mod_search.js"

import _ from "lodash"

export default {
  name: "WkbkTopApp",
  mixins: [
    support_parent,
    mod_table,
    mod_tabs,
    mod_storage,
    mod_columns,
    mod_sidebar,
    mod_search,
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
    this.app_log("将棋ドリル")
  },

  // fetchOnServer: false,
  fetch() {
    // this.$GX.assert(this.scope, "this.scope")
    this.query       = this.$route.query.query
    // this.scope       = this.$route.query.scope ?? this.scope ?? "everyone" // 引数 -> localStorageの値 -> 初期値 の順で決定
    this.search_preset_key = this.$route.query.search_preset_key
    this.page        = this.$route.query.page
    this.per         = this.$route.query.per
    // this.sort_column = this.$route.query.sort_column ?? "updated_at"
    // this.sort_order  = this.$route.query.sort_order ?? "desc"
    this.tag         = this.$route.query.tag

    // this.url_params とは異なり最終的な初期値を設定する
    const params = {
      query:       this.query,
      search_preset_key:       this.search_preset_key,
  // scope:       this.scope,
      page:        this.page,
      per:         this.per,
      // sort_column: this.sort_column,
      // sort_order:  this.sort_order,
      tag:         this.tag,
    }
    return this.$axios.$get("/api/wkbk/tops/index.json", {params}).then(e => {
      this.meta = e.meta
      if (this.query || this.tag) {
        this.meta.title = _.compact([this.query, ...this.tags]).join(" ") + ` - ${this.meta.title}`
      }

      // this.tab_index   = this.IndexScopeInfo.fetch(this.scope).code
      this.books       = e.books.map(e => new Book(e))
      // this.total       = e.total
      this.xpage_info = new XpageInfo(e.xpage_info)
      // this.book_counts = e.book_counts
    })
  },

  methods: {
    router_push(params) {
      params = {...this.url_params, ...params}
      params = this.$GX.hash_compact_blank(params)
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
.WkbkTopApp
  .MainSection.section
    +mobile
      padding: 0.75rem
    +tablet
      padding: 1.5rem

.STAGE-development
  .WkbkTopApp
    .columns
      border: 1px dashed change_color($danger, $alpha: 0.5)
      .column
        border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
