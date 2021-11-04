<template lang="pug">
.GalleryBananaIndexApp
  client-only
    DebugBox(v-if="development_p")
      p page: {{page}}

    FetchStateErrorMessage(:fetchState="$fetchState")

    GalleryBananaIndexSidebar(:base="base")
    GalleryBananaIndexNavbar(:base="base")

    MainSection.when_mobile_footer_scroll_problem_workaround
      .container.is-fluid
        .columns
          .column
            GalleryBananaIndexTable(:base="base")

    GalleryBananaIndexDebugPanels(:base="base" v-if="development_p")
</template>

<script>
import { Banana        } from "../models/banana.js"

import { support_parent } from "./support_parent.js"
import { app_table      } from "./app_table.js"
import { app_storage    } from "./app_storage.js"
import { app_columns    } from "./app_columns.js"
import { app_sidebar    } from "./app_sidebar.js"

export default {
  name: "GalleryBananaIndexApp",
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
    this.ga_click("動画ライブラリ")
  },

  fetchOnServer: false,
  fetch() {
    if (this.nuxt_login_required()) { return }

    // this.scope       = this.$route.query.scope ?? this.scope ?? "everyone" // 引数 -> localStorageの値 -> 初期値 の順で決定
    this.page        = this.$route.query.page
    this.per         = this.$route.query.per || this.GalleryConfig.value_of("per_page")
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

    return this.$axios.$get("/api/gallery/bananas/index.json", {params}).then(e => {
      // this.meta  = e.meta
      this.bananas = e.bananas.map(e => new Banana(this, e))
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
.GalleryBananaIndexApp
  .MainSection.section
    +tablet
      padding: 2rem

.STAGE-development
  .GalleryBananaIndexApp
    .container
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
