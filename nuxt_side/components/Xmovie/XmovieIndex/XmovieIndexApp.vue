<template lang="pug">
.XmovieIndexApp
  DebugBox(v-if="development_p")
    p query: {{query}}
    p tag: {{tag}}
    p search_p: {{search_p}}

  p(v-if="$fetchState.error" v-text="$fetchState.error.message")

  .MainContainer
    XmovieIndexSidebar(:base="base")
    XmovieIndexNavbar(:base="base")
    MainSection
      .container
        XmovieIndexSearchAppear(:base="base")
        XmovieIndexCardListTag(:base="base")
        XmovieIndexCardList(:base="base")

  DebugPre(v-if="development_p") {{$fetchState}}
  DebugPre(v-if="development_p") {{$data}}
</template>

<script>
import { XmovieRecord           } from "../models/xmovie_record.js"

import { support_parent } from "./support_parent.js"
import { app_table      } from "./app_table.js"
import { app_tabs       } from "./app_tabs.js"
import { app_storage    } from "./app_storage.js"
import { app_columns    } from "./app_columns.js"
import { app_sidebar    } from "./app_sidebar.js"
import { app_search     } from "./app_search.js"

import _ from "lodash"

export default {
  name: "XmovieIndexApp",
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
    this.ga_click("インスタント将棋動画集")
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
    return this.$axios.$get("/api/xmovie/tops/index.json", {params}).then(e => {
      this.meta = e.meta
      if (this.query || this.tag) {
        this.meta.title = _.compact([this.query, ...this.tags]).join(" ") + ` - ${this.meta.title}`
      }

      // this.tab_index   = this.IndexScopeInfo.fetch(this.scope).code
      this.xmovie_records       = e.xmovie_records.map(e => new XmovieRecord(e))
      this.total       = e.total
      // this.xmovie_record_counts = e.xmovie_record_counts
    })
  },

  methods: {
    router_push(params) {
      params = {...this.url_params, ...params}
      params = this.hash_compact_if_blank(params)
      this.$router.push({name: "video", query: params})
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

.XmovieIndexApp
  .MainSection.section
    +mobile
      padding: 0.75rem
    +tablet
      padding: 1.5rem
</style>
