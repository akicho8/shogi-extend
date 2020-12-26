<template lang="pug">
.SwarsBattleIndex
  b-loading(:active="$fetchState.pending")

  DebugBox
    p current_route_query: {{current_route_query}}
    p $route.query: {{$route.query}}
    p g_current_user: {{g_current_user && g_current_user.id}}
    p visible_hash: {{visible_hash}}

  b-sidebar.is-unselectable.SwarsBattleIndex-Sidebar(fullheight right overlay v-model="sidebar_p" v-if="config")
    .mx-4.my-4
      //- .MySidebarMenuIconWithTitle
      //-   b-icon.is-clickable(icon="menu" @click.native="sidebar_p = false")
      //-   .my_title.has-text-centered
      //-     nuxt-link.has-text-weight-bold.has-text-dark(:to="{name: 'index'}") SHOGI-EXTEND

      //- a.delete(@click="sidebar_toggle")

      b-menu
        b-menu-list(label="Action")
          b-menu-item(tag="nuxt-link" :to="{name: 'swars-users-key', params: {key: config.current_swars_user_key}}" @click.native="sound_play('click')" label="プレイヤー情報" :disabled="menu_item_disabled")

        b-menu-list(label="表示形式")
          b-menu-item(@click.stop="display_key_set('table')")
            template(slot="label")
              span(:class="{'has-text-weight-bold': display_key === 'table'}") テーブル
              b-dropdown.is-pulled-right(position="is-bottom-left" :close-on-click="false" :mobile-modal="false" @active-change="false && sound_play('click')")
                b-icon(icon="dots-vertical" slot="trigger")
                template(v-for="(e, key) in config.table_columns_hash")
                  b-dropdown-item.px-4(@click.native.stop="cb_toggle_handle(e)" :key="key")
                    span(:class="{'has-text-grey': !visible_hash[key], 'has-text-weight-bold': visible_hash[key]}") {{e.label}}
          b-menu-item(label="開戦" @click.stop="display_key_set('critical')" :class="{'has-text-weight-bold': display_key === 'critical'}")
          b-menu-item(label="中盤" @click.stop="display_key_set('outbreak')" :class="{'has-text-weight-bold': display_key === 'outbreak'}")
          b-menu-item(label="終局" @click.stop="display_key_set('last')"     :class="{'has-text-weight-bold': display_key === 'last'}")

        b-menu-list(label="表示オプション")
          b-menu-item(@click="sound_play('click')")
            template(slot="label" slot-scope="props")
              | 表示件数
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            template(v-for="per in config.per_page_list")
              b-menu-item(:label="`${per}`" @click.stop="per_change_handle(per)" :class="{'has-text-weight-bold': per === config.per}")

          b-menu-item(@click="sound_play('click')" :disabled="menu_item_disabled")
            template(slot="label" slot-scope="props")
              | フィルタ
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            SwarsBattleIndexFilterMenuItem(:base="base" label="勝ち"            q="judge:win")
            SwarsBattleIndexFilterMenuItem(:base="base" label="負け"            q="judge:lose")
            SwarsBattleIndexFilterMenuItem(:base="base" label="150手以上で勝ち" q="turn_max:>=150 judge:win")
            SwarsBattleIndexFilterMenuItem(:base="base" label="150手以上で負け" q="turn_max:>=150 judge:lose")
            SwarsBattleIndexFilterMenuItem(:base="base" label="50手以下で勝ち"  q="turn_max:<=50 judge:win")
            SwarsBattleIndexFilterMenuItem(:base="base" label="50手以下で負け"  q="turn_max:<=50 judge:lose")
            SwarsBattleIndexFilterMenuItem(:base="base" label="なし"            q="")

        b-menu-list(label="一括取得")
          //- b-menu-item(:disabled="menu_item_disabled" :expanded.sync="dl_menu_item_expanded_p" @click="sound_play('click')")
          //-   template(slot="label" slot-scope="props")
          //-     | 直近{{config.zip_dl_max_default}}件 ﾀﾞｳﾝﾛｰﾄﾞ
          //-     b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
          //-   template(v-for="e in ZipDlInfo.values")
          //-     b-menu-item(@click="zip_dl_handle(e)" :label="e.name")

          b-menu-item(
            label="ダウンロード"
            @click.native="config.current_swars_user_key && sound_play('click')"
            tag="nuxt-link"
            :to="{name: 'swars-direct-download', query: current_route_query}"
            :disabled="menu_item_disabled")

          b-menu-item(
            label="古い棋譜を補完"
            @click.native="config.current_swars_user_key && sound_play('click')"
            tag="nuxt-link"
            :to="{name: 'swars-users-key-download-all', params: {key: config.current_swars_user_key}}"
            :disabled="menu_item_disabled")

        b-menu-list(label="便利な使い方あれこれ")
          b-menu-item(
            label="検索初期値の設定"
            @click.native="config.current_swars_user_key && sound_play('click')"
            tag="nuxt-link"
            :to="{name: 'swars-users-key-default-key', params: {key: config.current_swars_user_key}}"
            :disabled="menu_item_disabled")

          b-menu-item(label="ホーム画面に追加" @click="bookmark_desc" :disabled="menu_item_disabled")

          b-menu-item(:disabled="menu_item_disabled" @click="sound_play('click')")
            template(slot="label" slot-scope="props")
              | 外部APP ｼｮｰﾄｶｯﾄ
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            template(v-for="e in ExternalAppInfo.values")
              b-menu-item(@click="external_app_handle(e)" :label="e.name")

          b-menu-item(
            label="KENTO API"
            @click.native="config.current_swars_user_key && sound_play('click')"
            tag="nuxt-link"
            :to="{name: 'swars-users-key-kento-api', params: {key: config.current_swars_user_key}}"
            :disabled="menu_item_disabled")

        b-menu-list(label="test" v-if="development_p")
          b-menu-item
            template(slot="label")
              | Devices
              b-dropdown.is-pulled-right(position="is-bottom-left")
                b-icon(icon="dots-vertical" slot="trigger")
                b-dropdown-item Action
                b-dropdown-item Action
                b-dropdown-item Action

        b-menu-list(label="DEBUG" v-if="development_p")
          b-menu-item(label="棋譜の不整合"     @click="$router.push({query: {query: 'Yamada_Taro', error_capture_test: true, force: true}})")
          b-menu-item(label="棋譜の再取得"     @click="$router.push({query: {query: 'Yamada_Taro', destroy_all: true, force: true}})")
          b-menu-item(label="棋譜の普通に取得" @click="$router.push({query: {query: 'Yamada_Taro'}})")
          b-menu-item(label="全レコード表示"   @click="$router.push({query: {query: '', all: 'true', per: 50, debug: 'true'}})")

  MainNavbar(wrapper-class="container is-fluid")
    template(slot="brand")
      NavbarItemHome
      b-navbar-item(tag="nuxt-link" :to="{}" @click.native="reset_handle")
        h1.has-text-weight-bold 将棋ウォーズ棋譜検索
    template(slot="end")
      NavbarItemLogin
      NavbarItemProfileLink
      b-navbar-item(@click="sidebar_toggle")
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
              .column.is-one-fifth-widescreen.is-one-quarter-desktop.is-one-third-tablet.is-clickable(@click="show_handle(e)")
                //- SwarsBattleShowUserLink.is_line_break_on.is-size-7(:membership="e.memberships[1]")

                CustomShogiPlayer(
                  :player_info="e.player_info"
                  sp_layout="is_vertical"
                  sp_run_mode="view_mode"
                  :sp_turn="sp_start_turn(e)"
                  :sp_body="e.sfen_body"
                  :sp_sound_enabled="false"
                  sp_summary="is_summary_off"
                  :sp_op_disabled="true"
                  :sp_vpoint="e.vpoint"
                )
                // :sp_hidden_if_piece_stand_blank="display_key === 'critical'"
                //- SwarsBattleShowUserLink.is_line_break_on.is-size-7(:membership="e.memberships[0]")

          //- v-if="$route.query.query || config.records.length >= 1"
          template(v-if="display_key === 'table'")
            b-table(
              v-if="$route.query.query || config.records.length >= 1"

              :total        = "config.total"
              :current-page = "config.page"
              :per-page     = "config.per"

              :show-header  = "config.total >= 1 || true"
              :paginated    = "config.total >= 1 || true"

              backend-pagination
              pagination-simple
              :data="config.records"
              @page-change="(page) => page_change_or_sort_handle({page})"

              backend-sorting
              :default-sort-direction="config.sort_order_default"
              :default-sort="[config.sort_column, config.sort_order]"
              @sort="(sort_column, sort_order) => page_change_or_sort_handle({sort_column, sort_order})"

              ref="table"

              :row-class="row_class"

              )

              SwarsBattleIndexTableEmpty(slot="empty" v-if="!$fetchState.pending && $route.query.query && config.total === 0")

              b-table-column(v-slot="{row}" field="id" :label="config.table_columns_hash['id'].label" :visible="!!visible_hash.id" sortable numeric v-if="config.table_columns_hash.id")
                a(@click="show_handle(row)") \#{{row.id}}

              template(v-if="config.current_swars_user_key")
                b-table-column(v-slot="{row}" label="自分")
                  SwarsBattleIndexMembership(:base="base" :membership="row.memberships[0]")
                b-table-column(v-slot="{row}" label="相手")
                  SwarsBattleIndexMembership(:base="base" :membership="row.memberships[1]")
              template(v-else)
                b-table-column(v-slot="{row}" label="勝ち")
                  SwarsBattleIndexMembership(:base="base" :membership="row.memberships[0]")
                b-table-column(v-slot="{row}" label="負け")
                  SwarsBattleIndexMembership(:base="base" :membership="row.memberships[1]")

              b-table-column(v-slot="{row}" field="final_key" :label="config.table_columns_hash.final_info.label" :visible="!!visible_hash.final_info" sortable)
                span(:class="row.final_info.class")
                  | {{row.final_info.name}}

              b-table-column(v-slot="{row}" field="turn_max" :label="config.table_columns_hash.turn_max.label" :visible="!!visible_hash.turn_max" sortable numeric)
                | {{row.turn_max}}

              b-table-column(v-slot="{row}" field="critical_turn" :label="config.table_columns_hash.critical_turn.label" :visible="!!visible_hash.critical_turn" sortable numeric v-if="config.table_columns_hash.critical_turn")
                | {{row.critical_turn}}

              b-table-column(v-slot="{row}" field="outbreak_turn" :label="config.table_columns_hash.outbreak_turn.label" :visible="!!visible_hash.outbreak_turn" sortable numeric v-if="config.table_columns_hash.outbreak_turn")
                | {{row.outbreak_turn}}

              b-table-column(v-slot="{row}" field="grade_diff" :label="config.table_columns_hash.grade_diff.label" :visible="!!visible_hash.grade_diff" sortable numeric v-if="config.table_columns_hash.grade_diff")
                | {{row.grade_diff}}

              b-table-column(v-slot="{row}" field="rule_key" :label="config.table_columns_hash.rule_info.label" :visible="!!visible_hash.rule_info" sortable)
                | {{row.rule_info.name}}

              b-table-column(v-slot="{row}" field="preset_key" :label="config.table_columns_hash.preset_info.label" :visible="!!visible_hash.preset_info" sortable)
                | {{row.preset_info.name}}

              b-table-column(v-slot="{row}" field="battled_at" :label="config.table_columns_hash.battled_at.label" :visible="!!visible_hash.battled_at" sortable)
                | {{row_time_format(row.battled_at)}}

              b-table-column(v-slot="{row}")
                .buttons.are-small
                  PiyoShogiButton(type="button" :href="piyo_shogi_app_with_params_url(row)" @click="sound_play('click')")
                  KentoButton(tag="a" :href="kento_app_with_params_url(row)" @click="sound_play('click')")
                  KifCopyButton(@click="kifu_copy_handle(row)")
                  DetailButton(tag="nuxt-link" :to="{name: 'swars-battles-key', params: {key: row.key}}" @click.native="sound_play('click')") 詳細

    client-only
      DebugPre {{config}}
      DebugPre {{$store.user}}
</template>

<script>
import _ from "lodash"

import { support } from "./support.js"

import { MyLocalStorage } from "@/components/models/MyLocalStorage.js"
import { ExternalAppInfo } from "@/components/models/ExternalAppInfo.js"

import SwarsBattleIndexCore from "./SwarsBattleIndexCore.js"
//- import SwarsBattleIndexHistory from "./SwarsBattleIndexHistory.js"

import MemoryRecord from 'js-memory-record'

class ZipDlInfo extends MemoryRecord {
  static get define() {
    return [
      { name: "KIF",             format_key: "kif",  body_encode: "UTF-8",     },
      { name: "KIF (Shift_JIS)", format_key: "kif",  body_encode: "Shift_JIS", },
      { name: "KI2",             format_key: "ki2",  body_encode: "UTF-8",     },
      { name: "CSA",             format_key: "csa",  body_encode: "UTF-8",     },
      { name: "SFEN",            format_key: "sfen", body_encode: "UTF-8",     },
    ]
  }

  get format_key_upcase() {
    return this.format_key.toUpperCase()
  }
}

export default {
  name: "SwarsBattleIndex",
  mixins: [
    support,
    SwarsBattleIndexCore,
  ],

  data() {
    return {
      sidebar_p: false,
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
        this.talk_stop()
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

    bookmark_desc() {
      this.sidebar_p = false
      this.sound_play("click")
      this.$buefy.dialog.alert({
        title: "ホーム画面に追加",
        message: `検索初期値の設定の他には<b>検索直後</b>のURLを<b>ホーム画面に追加</b>かブックマークしてもウォーズIDの入力の手間を省けます`,
        canCancel: ["outside", "escape"],
        confirmText: "わかった",
        type: 'is-info',
        onConfirm: () => this.sound_play("click"),
        onCancel:  () => this.sound_play("click"),
      })
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 検索すべてここで処理する
    interactive_search(params) { // private
      this.sound_play("click")
      if (this.$fetchState.pending) {
        this.toast_ng("連打すんな")
        return
      }
      const new_params = {...this.$route.query, ...params} // フィルターなどでは query を上書きする。またはなにもしない。
      if (Number(new_params.page || 0) <= 1) {
        delete new_params.page
      }
      this.clog("new_params", new_params)
      // https://github.com/vuejs/vue-router/issues/2872
      this.$router.push({query: new_params}, () => {
        this.clog("query に変化があったので watch 経由で $fetch が呼ばれる")
      }, () => {
        this.clog("query に変化がないので watch 経由で $fetch が呼ばれない。ので自分で呼ぶ")
        this.$fetch()
      })
      // $router.push の直後に $fetch を呼ぶと nuxt.js の不具合かわからんけど、
      // $route.query が更新前の値のままなので、検索結果が異なってしまう ($nextTickも意味なし)
      // なので watch にまかせている
    },

    // b-table の @sort と @page-change に反応
    page_change_or_sort_handle(params) {
      this.$router.push({query: {...this.$route.query, ...params}}, () => {
        this.sound_play("click")
      })
    },

    // 1ページあたりの件数の変更
    per_change_handle(per) {
      this.page_change_or_sort_handle({per})
    },

    // ここだけ特別で this.query で上書きしている
    // なぜならフィルターは query に埋め込まないといけないから
    filter_research(query) {
      alert("未使用")

      if (!this.config.current_swars_user_key) {
        this.toast_warn("先に誰かで検索してください")
        return
      }
      const new_query = _.trim(`${this.config.current_swars_user_key} ${query}`)

      // ここで設定しておくと検索前に変更される。けどなくてもい。意味あるかな？
      this.query = new_query

      this.interactive_search({query: new_query})
    },

    ////////////////////////////////////////////////////////////////////////////////

    external_app_handle(info) {
      if (this.config.current_swars_user_key) {
        this.sound_play("click")
        MyLocalStorage.set("external_app_setup", true)
        this.$router.push({
          name: 'swars-users-key-direct-open-external_app_key',
          params: {
            key: this.config.current_swars_user_key,
            external_app_key: info.key,
          },
        })
      }
    },

    // 棋譜ダウンロード
    zip_dl_handle(e) {
      this.sidebar_p = false
      this.sound_play("click")

      this.toast_ok(`${e.body_encode} の ${e.format_key_upcase} をダウンロードしています`)

      const params = {
        query:          this.query,
        zip_dl_format_key: e.format_key,
        body_encode:    e.body_encode,
        // zip_dl_scope_key:  "latest",
        sort_column: this.$route.query.sort_column || this.config.sort_column,
        sort_order:  this.$route.query.sort_order || this.config.sort_order,
      }

      const usp = new URLSearchParams()
      _.each(params, (v, k) => usp.set(k, v))
      const url = this.$config.MY_SITE_URL + `/w.zip?${usp}`
      location.href = url

      this.delay_block(3, () => {
        this.toast_ok(`たぶんダウンロード完了しました`, {
          onend: () => {
            this.toast_ok(`もっとたくさんダウンロードしたいときは「古い棋譜を補完」のほうを使ってください`)
          },
        })
      })
    },

    cb_toggle_handle(column) {
      this.sound_play('click')
      this.$set(this.visible_hash, column.key, !this.visible_hash[column.key])
    },

    row_class(row, index) {
      if (row.judge) {
        return `is-${row.judge.key}` // is- で始めると mobile-cards になったとき消されなくなる
      }
    },

    sidebar_toggle() {
      this.sound_play('click')
      this.sidebar_p = !this.sidebar_p
    },

    display_key_set(key) {
      if (this.display_key != key) {
        this.sound_play('click')
        this.display_key = key
      }
    },

    kifu_copy_handle(row) {
      this.sound_play('click')
      this.kif_clipboard_copy({kc_path: row.show_path})
    },
  },

  computed: {
    current_route_query() {
      return {
        query:       this.query,
        sort_column: this.config.sort_column,
        sort_order:  this.config.sort_order,
        ...this.$route.query,
      }
    },

    menu_item_disabled() {
      return !this.config.current_swars_user_key
    },

    board_show_p() {
      return ["critical", "outbreak", "last"].includes(this.display_key)
    },

    search_form_complete_list() {
      if (this.config.remember_swars_user_keys) {
        return this.config.remember_swars_user_keys.filter((option) => {
          return option.toString().toLowerCase().indexOf((this.query || "").toLowerCase()) >= 0
        })
      }
    },

    base()            { return this            },
    ExternalAppInfo() { return ExternalAppInfo },
    ZipDlInfo()       { return ZipDlInfo       },
  },
}
</script>

<style lang="sass">
.SwarsBattleIndex-Sidebar
  .menu-label:not(:first-child)
    margin-top: 2em

.SwarsBattleIndex
  .container
    +mobile
      padding: 0

  .b-table
    margin-top: 1.5rem
    +mobile
      margin-top: 1rem

  // 小さな盤面をたくさん表示
  .CustomShogiPlayer
    --sp_piece_count_font_size: 8px
    --sp_stand_piece_w: 20px
    --sp_stand_piece_h: 25px
    --sp_piece_count_gap_bottom: 64%

.STAGE-development
  .column
    border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
