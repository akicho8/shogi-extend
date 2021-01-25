<template lang="pug">
.WkbkArticleIndexApp
  WkbkArticleIndexSidebar(:base="base")
  WkbkArticleIndexNavbar(:base="base")
  WkbkArticleIndexTab(:base="base")
  WkbkArticleIndexTag(:base="base")
  WkbkArticleIndexTable(:base="base")
  DebugPre {{$data}}
</template>

<script>
import { Article        } from "../models/article.js"
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

  watch: {
    "$route.query": "$fetch",
  },

  fetch() {
    this.page        = this.$route.query.page        || 1
    this.per         = this.$route.query.per         || 50
    this.sort_column = this.$route.query.sort_column || ""
    this.sort_order  = this.$route.query.sort_order  || ""
    this.scope       = this.$route.query.scope       || this.default_scope
    this.tag         = this.$route.query.tag         || ""

    const params = {
      remote_action: "article_index",
      page:        this.page,
      per:         this.per,
      sort_column: this.sort_column,
      sort_order:  this.sort_order,
      scope:       this.scope,
      tag:         this.tag,
    }

    return this.$axios.$get("/api/wkbk.json", {params}).then(e => {
      this.tab_index      = this.IndexScopeInfo.fetch(this.scope).code
      this.articles       = e.articles.map(e => new Article(e))
      this.total          = e.total
      this.article_counts = e.article_counts
    })
  },

  methods: {
    router_replace(params) {
      this.$router.replace({name: "library-articles", query: {...this.url_params, ...params}})
    },
  },

  computed: {
    base() { return this },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkArticleIndexApp
</style>
