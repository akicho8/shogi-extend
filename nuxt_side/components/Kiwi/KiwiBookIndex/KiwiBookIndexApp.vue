<template lang="pug">
.KiwiBookIndexApp
  client-only
    DebugBox(v-if="development_p")
      p page: {{page}}

    p(v-if="$fetchState.error" v-text="$fetchState.error.message")

    KiwiBookIndexSidebar(:base="base")
    KiwiBookIndexNavbar(:base="base")

    MainSection.when_mobile_footer_scroll_problem_workaround
      .container.is-fluid
        .columns
          .column
            KiwiBookIndexTable(:base="base")

    DebugPre(v-if="development_p") {{$fetchState}}
    DebugPre(v-if="development_p") {{$data}}
</template>

<script>
import { Book        } from "../models/book.js"

import { support_parent } from "./support_parent.js"
import { app_table      } from "./app_table.js"
import { app_storage    } from "./app_storage.js"
import { app_columns    } from "./app_columns.js"
import { app_sidebar    } from "./app_sidebar.js"

export default {
  name: "KiwiBookIndexApp",
  mixins: [
    support_parent,
    app_table,
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
    // console.log("[mounted]")
    this.ga_click("動画管理")
  },

  fetchOnServer: false,
  fetch() {
    if (this.sns_login_required()) { return }

    // console.log("[fetch]")
    // this.__assert__(this.scope, "this.scope")

    // this.scope       = this.$route.query.scope ?? this.scope ?? "everyone" // 引数 -> localStorageの値 -> 初期値 の順で決定
    this.page        = this.$route.query.page
    this.per         = this.$route.query.per || this.KiwiConfig.value_of("per_page")
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

    return this.$axios.$get("/api/kiwi/books/index.json", {params}).then(e => {
      // this.meta  = e.meta
      this.books = e.books.map(e => new Book(this, e))
      this.total = e.total
    })
  },

  methods: {
    router_push(params) {
      params = {...this.url_params, ...params}
      params = this.hash_compact_if_null(params)
      this.$router.push({name: "video-studio", query: params})
    },
  },

  computed: {
    base() { return this },
  },
}
</script>

<style lang="sass">
@import "../all_support.sass"
.KiwiBookIndexApp
  .MainSection.section
    +mobile
      padding-bottom: 12rem // ios Safari では底辺部分をタップするとスクロールしてしまい使いにくいためスペースをあける
    +tablet
      padding: 2rem

.STAGE-development
  .KiwiBookIndexApp
    .container
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
