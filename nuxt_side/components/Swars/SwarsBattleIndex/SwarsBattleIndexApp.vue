<template lang="pug">
.SwarsBattleIndexApp
  b-loading(:active="loading_p")

  DebugBox(v-if="development_p")
    p mounted_then_query_present_p: {{mounted_then_query_present_p}}

  SwarsBattleIndexSidebar()

  MainNavbar(wrapper-class="container is-fluid")
    template(slot="brand")
      NavbarItemHome
      b-navbar-item(tag="nuxt-link" :to="{}" @click.native="reset_handle")
        h1.has-text-weight-bold 将棋ウォーズ棋譜検索
    template(slot="end")
      NavbarItemLogin
      NavbarItemProfileLink
      NavbarItemSidebarOpen(@click="sidebar_toggle")

  XyMasterLiteApp(v-if="xy_master_lite_p")

  MainSection(v-if="!xy_master_lite_p")
    .container.is-fluid
      .columns
        .column
          b-field
            b-autocomplete#query(
              open-on-focus
              spellcheck="false"
              max-height="50vh"
              size="is-medium"
              v-model.trim="query"
              :data="search_input_complement_list"
              type="search"
              placeholder="ウォーズIDを入力"
              clearable
              expanded
              @select="search_select_handle"
              @keydown.native.enter="search_enter_handle"
              ref="main_search_form"
              )
            p.control
              b-button.search_click_handle(@click="search_click_handle" icon-left="magnify" size="is-medium")

          SwarsBattleIndexBoard(v-if="layout_info.key === 'is_layout_board'")
          SwarsBattleIndexTable(v-if="layout_info.key === 'is_layout_table'")
          template(v-if="xi && xi.stat")
            pre.box.mb-0.mt-4.is-size-7.has-background-white-ter.is-shadowless
              | {{xi.stat}}
      SwarsBattleIndexDebugPanels(v-if="development_p")
</template>

<script>
// 名前クリックでプレイヤー情報に飛ばすときに検索クエリをつけたままにするか？
// true だとクエリが外れずに使いにくい
const QUERY_KEEP_P = false

import _ from "lodash"

import { support_parent           } from "./support_parent.js"
import { mod_chore                } from "./mod_chore.js"
import { mod_default_key          } from "./mod_default_key.js"
import { mod_columns              } from "./mod_columns.js"
import { mod_link_to              } from "./mod_link_to.js"
import { mod_search               } from "./mod_search.js"
import { mod_shortcut             } from "./shortcut/mod_shortcut.js"
import { mod_complement_user_keys } from "./mod_complement_user_keys.js"
import { mod_tiresome             } from "./mod_tiresome.js"
import { mod_per                  } from "./mod_per.js"
import { mod_sidebar              } from "./mod_sidebar.js"
import { mod_storage              } from "./mod_storage.js"

import { ExternalAppInfo } from "@/components/models/external_app_info.js"
import { TacticInfo      } from "@/components/models/tactic_info.js"

import { ParamInfo  } from "./models/param_info.js"
import { SceneInfo  } from "../models/scene_info.js"
import { LayoutInfo } from "./models/layout_info.js"

import { GX } from "@/components/models/gx.js"

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
    mod_default_key,
    mod_storage,
    mod_shortcut,
  ],

  data() {
    return {
      xi: {},
    }
  },

  provide() {
    return {
      APP: this,
    }
  },

  // watchQuery: ['query'],
  watch: {
    "$route.query": "$fetch",
  },

  fetchOnServer: false,
  fetch() {
    this.$debug.trace("SwarsBattleIndexApp", "fetch begin")

    let params = {...this.$route.query}

    if (this.$gs.blank_p(params.query)) {
      params.query = this.swars_search_default_key_get()
    }

    // if (this.$gs.blank_p(params.per)) {
    //   if (this.per_info.key !== this.APP.ParamInfo.fetch("per_key").default_for(this.APP)) {
    //     params.per = this.per_info.per
    //   }
    // }

    if (this.$gs.blank_p(params.per)) {
      // if (this.per_info.key !== this.APP.ParamInfo.fetch("per_key").default_for(this.APP)) {
      params.per = this.per_info.per
      // }
    }

    params = this.pc_url_params_clean(params)

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
    search_input_focus() {
      this.$refs.main_search_form.focus({preventScroll: true})
      return true
    },

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
      if (row.imode_info) {
        list.push(`is-imode-${row.imode_info.key}`)
      }
      return list.join(" ")
    },

    scene_key_set(info, e) {
      info = this.SceneInfo.fetch(info)
      this.sfx_click()
      this.talk(info.name)
      if (this.keyboard_meta_p(e)) {
        this.other_window_open(this.tab_switch_router_url({layout_key: "is_layout_board", scene_key: info.key}))
      } else {
        this.layout_key = "is_layout_board" // 強制的に「盤面」に切り替える
        this.scene_key = info.key
      }
      this.app_log({subject: "局面", body: info.name})
      return true
    },

    layout_key_set(info, e) {
      info = this.LayoutInfo.fetch(info)
      this.sfx_click()
      this.talk(info.name)
      if (this.keyboard_meta_p(e)) {
        this.other_window_open(this.tab_switch_router_url({layout_key: info.key}))
      } else {
        this.layout_key = info.key
      }
      this.app_log({subject: "レイアウト", body: info.name})
      return true
    },

    tab_switch_router_params(new_params = {}) {
      return {
        query: {
          ...this.$route.query,
          layout_key: this.layout_info.key,
          scene_key: this.scene_info.key,
          ...new_params,
        },
      }
    },
    tab_switch_router_url(new_params = {}) {
      return this.$router.resolve(this.tab_switch_router_params(new_params)).href
    },
  },

  computed: {
    ExternalAppInfo() { return ExternalAppInfo },
    TacticInfo()      { return TacticInfo },
    ParamInfo()       { return ParamInfo },

    SceneInfo()     { return SceneInfo                         },
    scene_info()    { return SceneInfo.fetch(this.scene_key) },

    LayoutInfo()     { return LayoutInfo                         },
    layout_info()    { return LayoutInfo.fetch(this.layout_key) },

    current_query()  { return GX.presence(GX.query_compact(this.query)) }, // 現在のクエリを継続して使うとき用
    query_for_link() { return QUERY_KEEP_P ? this.current_query : undefined },  // 名前クリックしたときのクエリ

    loading_p() {
      return this.$fetchState.pending && !this.xy_master_lite_p
    },

    xy_master_lite_p() {
      return false              // やっぱやめ

      if (this.$route.query.xy_master_lite_p) {
        return true
      }
      return this.$fetchState.pending &&
        this.$gs.present_p(this.$route.query.query) &&
        this.$gs.blank_p(this.$route.query.sort_column) &&
        this.$gs.blank_p(this.$route.query.sort_order) &&
        this.$gs.blank_p(this.$route.query.page)
    },
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
    .is-xmode-大会
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
