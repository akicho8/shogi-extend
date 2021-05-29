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
      b-navbar-item.px_5_if_tablet(@click="sidebar_toggle")
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
              b-button.search_form_submit_button(@click="search_click_handle" icon-left="magnify" size="is-medium" :loading="$fetchState.pending && false" :disabled="!query")

          .columns.is-multiline.mt-4(v-if="board_show_p")
            template(v-for="e in config.records")
              // https://bulma.io/documentation/columns/responsiveness/
              // widescreen 1/5 (is-one-fifth-widescreen)
              // desktop    1/4 (is-one-quarter-desktop)
              // table      1/4 (is-one-quarter-tablet)
              .column.is-one-fifth-widescreen.is-one-quarter-desktop.is-one-third-tablet.is-clickable(@click.stop="show_handle(e)")
                //- SwarsBattleShowUserLink.is_line_break_on.is-size-7(:membership="e.memberships[1]")
                CustomShogiPlayer(
                  :sp_player_info="e.player_info"
                  sp_layout="is_vertical"
                  sp_run_mode="view_mode"
                  :sp_turn="sp_start_turn(e)"
                  :sp_body="e.sfen_body"
                  :sp_sound_enabled="false"
                  sp_summary="is_summary_off"
                  :sp_op_disabled="true"
                  :sp_viewpoint="e.memberships[0].location.key"
                )
                // :sp_hidden_if_piece_stand_blank="display_key === 'critical'"
                //- SwarsBattleShowUserLink.is_line_break_on.is-size-7(:membership="e.memberships[0]")

          //- v-if="$route.query.query || config.records.length >= 1"
          template(v-if="display_key === 'table'")
            SwarsBattleIndexTable(:base="base")
  client-only
    DebugPre(v-if="development_p") {{config}}
    DebugPre(v-if="development_p") {{$store.user}}
</template>

<script>
import _ from "lodash"

import { support_parent  } from "./support_parent.js"
import { app_chore       } from "./app_chore.js"
import { app_columns     } from "./app_columns.js"
import { app_core        } from "./app_core.js"
import { app_search      } from "./app_search.js"
import { app_sidebar     } from "./app_sidebar.js"
import { app_storage     } from "./app_storage.js"
import { app_vs_input     } from "./app_vs_input.js"

import { ExternalAppInfo } from "@/components/models/external_app_info.js"
import { MyLocalStorage  } from "@/components/models/my_local_storage.js"
import { ZipDlInfo       } from "@/components/models/zip_dl_info.js"

export default {
  name: "SwarsBattleIndexApp",
  mixins: [
    support_parent,
    app_core,
    app_search,
    app_columns,
    app_sidebar,
    app_chore,
    app_storage,
    app_vs_input,
  ],

  data() {
    return {
      dl_menu_item_expanded_p: false, // ダウンロードメニューの開閉状態
      config: {},
    }
  },

  // watchQuery: ['query'],
  watch: {
    "$route.query": "$fetch",

    // ダウンロードメニューを開いたときだけしゃべる
    dl_menu_item_expanded_p(v) {
      if (v) {
        this.sound_stop_all()
        this.toast_ok("Windowsアプリで棋譜が読めないときは Shift_JIS のほうを試してみてください")
      }
    },
  },

  mounted() {
    if (false) {
      this.desktop_focus_to(this.$refs.main_search_form)
    }
  },

  fetchOnServer: false,
  fetch() {
    // if (!this.$route.query.query) {
    //   this.$router.push({name: "swars-search", query: {query: "user1"}})
    // }

    let query = {...this.$route.query}
    if (!query.query) {
      query.query = MyLocalStorage.get("swars_search_default_key")
    }

    if (query.query) {
      this.ga_click("ウォーズ検索●")
    } else {
      this.ga_click("ウォーズ検索")
    }

    return this.$axios.$get("/w.json", {params: query}).then(config => {
      this.config = config

      // if (this.display_key == null) {
      //   this.display_key  = this.config.display_key // 何の局面の表示をするか？
      // }

      // なかから nuxt-link したとき $fetch が呼ばれるが、
      // this.query は前の状態なので更新する
      this.query = this.config.query
      // this.query = this.$route.query.query

      this.ls_setup() // config から visible_hash や display_key を設定

      this.notice_collector_run(this.config)
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

    display_key_set(key) {
      if (this.display_key != key) {
        this.sound_play('click')
        this.display_key = key
      }
    },
  },

  computed: {
    base()            { return this            },
    ExternalAppInfo() { return ExternalAppInfo },
    ZipDlInfo()       { return ZipDlInfo       },
    board_show_p()    { return ["critical", "outbreak", "last"].includes(this.display_key) },
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
