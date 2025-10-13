<template lang="pug">
.KiwiTopApp
  DebugBox(v-if="development_p")
    p query: {{query}}
    p tag: {{tag}}

  FetchStateErrorMessage(:fetchState="$fetchState")

  KiwiTopSidebar(:base="base")
  KiwiTopNavbar(:base="base")
  //- (v-if="!$fetchState.pending && !$fetchState.error")
  MainSection.when_mobile_footer_scroll_problem_workaround
    .container.is-fluid
      KiwiTopContent(:base="base")

  KiwiTopDebugPanels(:base="base" v-if="development_p")
</template>

<script>
import { Banana      } from "../models/banana.js"
import { XpageInfo } from "../../models/xpage_info.js"

import { support_parent } from "./support_parent.js"
import { mod_table      } from "./mod_table.js"
import { mod_tabs       } from "./mod_tabs.js"
import { mod_storage    } from "./mod_storage.js"
import { mod_sidebar    } from "./mod_sidebar.js"
import { mod_search     } from "./mod_search.js"

import _ from "lodash"

export default {
  name: "KiwiTopApp",
  mixins: [
    support_parent,
    mod_table,
    mod_tabs,
    mod_storage,
    mod_sidebar,
    mod_search,
  ],

  data() {
    return {
      meta: {
        title: "動画ライブラリ",
        description: "コメントしたりできる",
        og_image_key: "video",
      },
    }
  },

  watch: {
    "$route.query": "$fetch",
  },

  mounted() {
    this.app_log("動画一覧")
  },

  fetchOnServer: false,
  fetch() {
    // this.$GX.assert(this.search_preset_key, "this.search_preset_key")
    this.query       = this.$route.query.query
    // this.search_preset_key = this.$route.query.search_preset_key ?? this.search_preset_key ?? "everyone" // 引数 -> localStorageの値 -> 初期値 の順で決定
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
      page:        this.page,
      per:         this.per,
      // sort_column: this.sort_column,
      // sort_order:  this.sort_order,
      tag:         this.tag,
    }
    return this.$axios.$get("/api/kiwi/tops/index.json", {params}).then(e => {
      this.meta = e.meta
      if (this.query || this.tag) {
        this.meta.title = _.compact([this.query, ...this.tags]).join(" ") + ` - ${this.meta.title}`
      }
      // this.tab_index   = this.IndexScopeInfo.fetch(this.search_preset_key).code
      this.bananas = e.bananas.map(e => new Banana(this, e))
      this.xpage_info = new XpageInfo(e.xpage_info)
      // this.total       = e.total
      // this.banana_counts = e.banana_counts
    })
  },

  methods: {
    router_push(params) {
      params = {...this.url_params, ...params}
      params = this.$GX.hash_compact_blank(params)
      this.$router.push({name: "video", query: params})
    },
  },

  computed: {
    base() { return this },
  },
}
</script>

<style lang="sass">
@import "../all_support.sass"

.KiwiTopApp
  .MainSection.section
    +mobile
      padding: 0.75rem
    +tablet
      padding: 1.5rem

.STAGE-development
  .KiwiTopApp
    .columns
      border: 1px dashed change_color($danger, $alpha: 0.5)
      .column
        border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
