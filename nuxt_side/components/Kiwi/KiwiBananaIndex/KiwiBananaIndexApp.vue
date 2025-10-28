<template lang="pug">
.KiwiBananaIndexApp
  client-only
    DebugBox(v-if="development_p")
      p page: {{page}}

    FetchStateErrorMessage(:fetchState="$fetchState")

    KiwiBananaIndexSidebar(:base="base")
    KiwiBananaIndexNavbar(:base="base")

    MainSection.when_mobile_footer_scroll_problem_workaround
      .container.is-fluid
        .columns
          .column
            KiwiBananaIndexTable(:base="base")

    KiwiBananaIndexDebugPanels(:base="base" v-if="development_p")
</template>

<script>
import { Banana        } from "../models/banana.js"

import { support_parent } from "./support_parent.js"
import { mod_table      } from "./mod_table.js"
import { mod_storage    } from "./mod_storage.js"
import { mod_columns    } from "./mod_columns.js"
import { mod_sidebar    } from "./mod_sidebar.js"

export default {
  name: "KiwiBananaIndexApp",
  mixins: [
    support_parent,
    mod_table,
    mod_storage,
    mod_columns,
    mod_sidebar,
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
    this.app_log("動画スタジオ")
  },

  fetchOnServer: false,
  fetch() {
    if (this.nuxt_login_required()) { return }

    // this.scope       = this.$route.query.scope ?? this.scope ?? "everyone" // 引数 -> localStorageの値 -> 初期値 の順で決定
    this.page        = this.$route.query.page
    this.per         = this.$route.query.per || this.KiwiConfig.value_of("per_page")
    this.sort_column = this.param_to_s("sort_column", "updated_at")
    this.sort_order  = this.param_to_s("sort_order", "desc")
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

    return this.$axios.$get("/api/kiwi/bananas/index.json", {params}).then(e => {
      // this.meta  = e.meta
      this.bananas = e.bananas.map(e => new Banana(this, e))
      this.total = e.total
    })
  },

  methods: {
    router_push(params) {
      params = {...this.url_params, ...params}
      params = this.$GX.hash_compact(params)
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
.KiwiBananaIndexApp
  .MainSection.section
    +tablet
      padding: 2rem

.STAGE-development
  .KiwiBananaIndexApp
    .container
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
