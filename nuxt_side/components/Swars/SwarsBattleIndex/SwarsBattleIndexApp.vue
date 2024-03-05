<template lang="pug">
.SwarsBattleIndexApp
  b-loading(:active="$fetchState.pending")

  DebugBox(v-if="development_p")
    p mounted_then_query_present_p: {{mounted_then_query_present_p}}

  SwarsBattleIndexSidebar(:base="base")

  MainNavbar(wrapper-class="container is-fluid")
    template(slot="brand")
      NavbarItemHome
      b-navbar-item(tag="nuxt-link" :to="{}" @click.native="reset_handle")
        h1.has-text-weight-bold 将棋ウォーズ棋譜検索
    template(slot="end")
      NavbarItemLogin
      NavbarItemProfileLink
      NavbarItemSidebarOpen(@click="sidebar_toggle")

  MainSection
    .container.is-fluid
      .columns
        .column
          b-field
            b-autocomplete#query(
              max-height="50vh"
              size="is-medium"
              v-model.trim="query"
              :data="search_input_complement_list"
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
          template(v-if="xi && xi.stat")
            pre.box.mb-0.mt-4.is-size-7.has-background-white-ter.is-shadowless
              | {{xi.stat}}
      SwarsBattleIndexDebugPanels(:base="base" v-if="development_p")
</template>

<script>
import _ from "lodash"

import { support_parent           } from "./support_parent.js"
import { mod_chore                } from "./mod_chore.js"
import { mod_help                 } from "./mod_help.js"
import { mod_default_key          } from "./mod_default_key.js"
import { mod_columns              } from "./mod_columns.js"
import { mod_link_to              } from "./mod_link_to.js"
import { mod_search               } from "./mod_search.js"
import { mod_complement_user_keys } from "./mod_complement_user_keys.js"
import { mod_tiresome             } from "./mod_tiresome.js"
import { mod_per                  } from "./mod_per.js"
import { mod_sidebar              } from "./mod_sidebar.js"
import { mod_storage              } from "./mod_storage.js"
import { mod_vs_user              } from "./mod_vs_user.js"

import { ExternalAppInfo } from "@/components/models/external_app_info.js"
import { ZipDlInfo       } from "@/components/models/zip_dl_info.js"

import { ParamInfo  } from "./models/param_info.js"
import { SceneInfo  } from "../models/scene_info.js"
import { LayoutInfo } from "./models/layout_info.js"

import { Gs } from "@/components/models/gs.js"

export default {
  name: "SwarsBattleIndexApp",
  mixins: [
    support_parent,
    mod_link_to,
    mod_search,
    mod_complement_user_keys,
    mod_tiresome,
    mod_per,
    mod_columns,
    mod_sidebar,
    mod_chore,
    mod_help,
    mod_default_key,
    mod_storage,
    mod_vs_user,
  ],

  data() {
    return {
      xi: {},
    }
  },

  provide() {
    return {
      TheApp: this,
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
    this.$debug.trace("SwarsBattleIndexApp", "fetch begin")

    let params = {...this.$route.query}

    if (this.$gs.blank_p(params.query)) {
      params.query = this.swars_search_default_key_get()
    }

    // if (this.$gs.blank_p(params.per)) {
    //   if (this.per_info.key !== this.base.ParamInfo.fetch("per_key").default_for(this.base)) {
    //     params.per = this.per_info.per
    //   }
    // }

    if (this.$gs.blank_p(params.per)) {
      // if (this.per_info.key !== this.base.ParamInfo.fetch("per_key").default_for(this.base)) {
      params.per = this.per_info.per
      // }
    }

    params = this.pc_url_params_clean(params)

    this.ga_process(params)

    // Number(params.per || 1)

    return this.$axios.$get("/w.json", {params: params}).then(xi => {
      this.$debug.trace("SwarsBattleIndexApp", "fetch then")

      this.xi = xi

      // なかから nuxt-link したとき $fetch が呼ばれるが、
      // this.query は前の状態なので更新する
      this.query = this.xi.query
      this.user_keys_update_by_query()
      // this.query = this.$route.query.query

      this.xnotice_run_all(this.xi)

      this.tiresome_alert_check()
    })
  },

  methods: {
    reset_handle() {
      // this.query = ""
      // this.xi.records = []
    },

    ////////////////////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////////////////////

    row_class(row, index) {
      const list = []
      if (row.judge_key) {
        list.push(`is-${row.judge_key}`) // is- で始めると mobile-cards になったとき消されなくなる
      }
      if (row.xmode_info) {
        list.push(`is-xmode-${row.xmode_info.key}`)
      }
      return list.join(" ")
    },

    scene_key_set(info) {
      // if (this.scene_key != info.key) {
      this.$sound.play_click()
      this.talk(info.name)
      this.scene_key = info.key
      // }
      // if (this.layout_key !== "is_layout_board") {
      this.layout_key = "is_layout_board"
      // }
      this.app_log({subject: "局面", body: info.name})
    },

    layout_key_set(info) {
      // if (this.layout_key != info.key) {
      this.$sound.play_click()
      this.talk(info.name)
      this.layout_key = info.key
      this.app_log({subject: "レイアウト", body: info.name})
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

    SceneInfo()     { return SceneInfo                         },
    scene_info()    { return SceneInfo.fetch(this.scene_key) },

    LayoutInfo()     { return LayoutInfo                         },
    layout_info()    { return LayoutInfo.fetch(this.layout_key) },

    user_info_query() { return Gs.presence(Gs.query_compact(this.query)) },
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

    .is-xmode-野良
      __css_keep__: 0
    .is-xmode-友達
      background-color: $warning-light
      .tag
        background-color: $white
    .is-xmode-指導
      background-color: $danger-light
      .tag
        background-color: $white

.STAGE-development
  .SwarsBattleIndexApp
    .column
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
