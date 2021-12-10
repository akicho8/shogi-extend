<template lang="pug">
.SwarsBattleIndexApp
  b-loading(:active="$fetchState.pending")

  DebugBox(v-if="development_p")
    p current_route_query: {{current_route_query}}
    p $route.query: {{$route.query}}
    p g_current_user: {{g_current_user && g_current_user.id}}
    p visible_hash: {{visible_hash}}

  SwarsBattleIndexSidebar(:base="base")

  MainNavbar(wrapper-class="container is-fluid")
    template(slot="brand")
      NavbarItemHome
      b-navbar-item(tag="nuxt-link" :to="{}" @click.native="reset_handle")
        h1.has-text-weight-bold 将棋ウォーズ棋譜検索
    template(slot="end")
      NavbarItemLogin
      NavbarItemProfileLink
      b-navbar-item.px_5_if_tablet.sidebar_toggle_navbar_item(@click="sidebar_toggle")
        b-icon(icon="menu")

  MainSection
    .container.is-fluid
      .columns
        .column
          b-field
            b-autocomplete#query(
              max-height="50vh"
              size="is-medium"
              v-model.trim="query"
              :data="search_form_complete_list"
              type="search"
              placeholder="ウォーズIDを入力"
              open-on-focus
              clearable
              expanded
              @select="search_select_handle"
              @keydown.native.enter="search_enter_handle"
              ref="main_search_form"
              )
            p.control
              b-button.search_click_handle(@click="search_click_handle" icon-left="magnify" size="is-medium")

          SwarsBattleIndexBoard(:base="base" v-if="layout_info.key === 'is_layout_board'")
          SwarsBattleIndexTable(:base="base" v-if="layout_info.key === 'is_layout_table'")
      SwarsBattleIndexDebugPanels(:base="base" v-if="development_p")
</template>

<script>
import _ from "lodash"

import { support_parent  } from "./support_parent.js"
import { app_chore       } from "./app_chore.js"
import { app_columns     } from "./app_columns.js"
import { app_core        } from "./app_core.js"
import { app_search      } from "./app_search.js"
import { app_per         } from "./app_per.js"
import { app_sidebar     } from "./app_sidebar.js"
import { app_storage     } from "./app_storage.js"
import { app_vs_input     } from "./app_vs_input.js"

import { ExternalAppInfo } from "@/components/models/external_app_info.js"
import { MyLocalStorage  } from "@/components/models/my_local_storage.js"
import { ZipDlInfo       } from "@/components/models/zip_dl_info.js"

import { ParamInfo   } from "./models/param_info.js"
import { DisplayInfo } from "./models/display_info.js"
import { LayoutInfo } from "./models/layout_info.js"

export default {
  name: "SwarsBattleIndexApp",
  mixins: [
    support_parent,
    app_core,
    app_search,
    app_per,
    app_columns,
    app_sidebar,
    app_chore,
    app_storage,
    app_vs_input,
  ],

  data() {
    return {
      config: {},
    }
  },

  // watchQuery: ['query'],
  watch: {
    "$route.query": "$fetch",
  },

  mounted() {
    if (false) {
      this.desktop_focus_to(this.$refs.main_search_form)
    }
  },

  fetchOnServer: false,
  fetch() {
    this.__trace__("SwarsBattleIndexApp", "fetch begin")

    let params = {...this.$route.query}

    if (this.blank_p(params.query)) {
      params.query = MyLocalStorage.get("swars_search_default_key")
    }

    // if (this.blank_p(params.per)) {
    //   if (this.per_info.key !== this.base.ParamInfo.fetch("per_key").default_for(this.base)) {
    //     params.per = this.per_info.per
    //   }
    // }

    if (this.blank_p(params.per)) {
      // if (this.per_info.key !== this.base.ParamInfo.fetch("per_key").default_for(this.base)) {
      params.per = this.per_info.per
      // }
    }

    params = this.pc_url_params_clean(params)

    this.ga_process(params)

    // Number(params.per || 1)

    return this.$axios.$get("/w.json", {params: params}).then(config => {
      this.__trace__("SwarsBattleIndexApp", "fetch then")

      this.config = config

      // なかから nuxt-link したとき $fetch が呼ばれるが、
      // this.query は前の状態なので更新する
      this.query = this.config.query
      // this.query = this.$route.query.query

      // this.ls_setup() // config から visible_hash や display_key を設定

      this.xnotice_run_all(this.config)
    })
  },

  methods: {
    reset_handle() {
      // this.query = ""
      // this.config.records = []
    },

    ////////////////////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////////////////////

    row_class(row, index) {
      if (row.judge) {
        return `is-${row.judge.key}` // is- で始めると mobile-cards になったとき消されなくなる
      }
    },

    display_key_set(info) {
      // if (this.display_key != info.key) {
      this.sound_play_click()
      this.talk(info.name)
      this.display_key = info.key
      // }
      // if (this.layout_key !== "is_layout_board") {
      this.layout_key = "is_layout_board"
      // }
    },

    layout_key_set(info) {
      // if (this.layout_key != info.key) {
      this.sound_play_click()
      this.talk(info.name)
      this.layout_key = info.key
      // }
    },

    ga_process(params) {
      if (params.query) {
        this.ga_click("将棋ウォーズ棋譜検索 検索実行")
      } else {
        this.ga_click("将棋ウォーズ棋譜検索 未入力")
      }
    },
  },

  computed: {
    base()            { return this            },
    ExternalAppInfo() { return ExternalAppInfo },
    ZipDlInfo()       { return ZipDlInfo       },
    ParamInfo()       { return ParamInfo },

    DisplayInfo()     { return DisplayInfo                         },
    display_info()    { return DisplayInfo.fetch(this.display_key) },

    LayoutInfo()     { return LayoutInfo                         },
    layout_info()    { return LayoutInfo.fetch(this.layout_key) },
  },
}
</script>

<style lang="sass">
.SwarsBattleIndexApp
  .MainSection.section
    +tablet
      padding: 1.75rem 0rem

  .container
    +mobile
      padding: 0

  .b-table
    margin-top: 0rem
    // margin-bottom: 2rem
    +mobile
      margin-top: 1rem
    td
      vertical-align: middle

  // 小さな盤面をたくさん表示
  .CustomShogiPlayer
    --sp_piece_count_font_size: 8px
    --sp_stand_piece_w: 20px
    --sp_stand_piece_h: 25px
    --sp_piece_count_gap_bottom: 64%

.STAGE-development
  .SwarsBattleIndexApp
    .column
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
