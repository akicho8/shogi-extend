<template lang="pug">
.SwarsBattleIndex
  DebugBox
    p $route.query: {{$route.query}}
  b-sidebar.is-unselectable(fullheight right v-model="sidebar_p")
    .mx-4.my-4
      //- .MySidebarMenuIconWithTitle
      //-   b-icon.is_clickable(icon="menu" @click.native="sidebar_p = false")
      //-   .my_title.has-text-centered
      //-     nuxt-link.has-text-weight-bold.has-text-dark(:to="{name: 'index'}") SHOGI-EXTEND

      b-menu
        b-menu-list(label="Action")
          b-menu-item(tag="nuxt-link" :to="{name: 'swars-users-key', params: {key: config.current_swars_user_key}}" @click.native="sound_play('click')" icon="account" label="プレイヤー情報" :disabled="!config.current_swars_user_key")

        b-menu-list(label="表示形式")
          b-menu-item(@click.stop="display_key_set('table')")
            template(slot="label")
              span(:class="{'has-text-weight-bold': display_key === 'table'}") テーブル
              b-dropdown.is-pulled-right(position="is-bottom-left" :close-on-click="false" :mobile-modal="false" @active-change="sound_play('click')")
                b-icon(icon="dots-vertical" slot="trigger")
                template(v-for="(e, key) in config.table_columns_hash")
                  b-dropdown-item.px-4(@click.native.stop="cb_toggle_handle(e)" :key="key")
                    span(:class="{'has-text-grey': !visible_hash[key], 'has-text-weight-bold': visible_hash[key]}") {{e.label}}
          b-menu-item(label="仕掛け"   @click.stop="display_key_set('critical')" :class="{'has-text-weight-bold': display_key === 'critical'}")
          b-menu-item(label="終局図"   @click.stop="display_key_set('last')"          :class="{'has-text-weight-bold': display_key === 'last'}")

        b-menu-list(label="表示オプション")
          b-menu-item(@click="sound_play('click')")
            template(slot="label" slot-scope="props")
              | 表示件数
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            template(v-for="per in config.per_page_list")
              b-menu-item(:label="`${per}`" @click.stop="per_change_handle(per)" :class="{'has-text-weight-bold': per === config.per}")

          b-menu-item(@click="sound_play('click')")
            template(slot="label" slot-scope="props")
              | フィルタ
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            b-menu-item(label="勝ち" @click.stop="filter_research(`judge:win`)"  :class="{'has-text-weight-bold': filter_match_p('judge:win')}")
            b-menu-item(label="負け" @click.stop="filter_research(`judge:lose`)" :class="{'has-text-weight-bold': filter_match_p('judge:lose')}")
            b-menu-item(label="なし" @click.stop="filter_research(``)"           :class="{'has-text-weight-bold': !filter_match_p('judge:')}")

        b-menu-list(label="その他")

          b-menu-item(:disabled="!config.current_swars_user_key" @click="sound_play('click')")
            template(slot="label" slot-scope="props")
              | ダウンロード
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            template(v-for="e in ZipKifuInfo.values")
              b-menu-item(@click="zip_dl_handle(e.key)" :label="e.name")

          b-menu-item(:disabled="!config.current_swars_user_key" @click="sound_play('click')")
            template(slot="label" slot-scope="props")
              | 外部APP ｼｮｰﾄｶｯﾄ
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
            template(v-for="e in ExternalAppInfo.values")
              b-menu-item(@click="external_app_handle(e)" :label="e.name")

          b-menu-item(
            label="KENTO API"
            @click.native="sound_play('click')"
            tag="nuxt-link"
            :to="{name: 'swars-users-key-kento-api', params: {key: config.current_swars_user_key}}"
            :disabled="!config.current_swars_user_key")

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

  //- b-navbar(type="is-primary" :wrapper-class="['container', {'is-fluid': wide_p}]" :mobile-burger="false" spaced)
  b-navbar(type="is-primary" wrapper-class="container is-fluid" :mobile-burger="false" spaced)
    template(slot="brand")
      HomeNavbarItem
      b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{query: {}}" @click.native="query= ''") 将棋ウォーズ棋譜検索
    template(slot="end")
      b-navbar-item(@click="sidebar_toggle")
        b-icon(icon="menu")

  .section
    .container(:class="{'is-fluid': wide_p}")
      .columns
        .column
          b-field
            b-autocomplete(
              size="is-large"
              v-model.trim="query"
              :data="search_form_complete_list"
              type="search"
              placeholder="ウォーズIDを入力"
              open-on-focus
              expanded
              @focus="query = ''"
              @select="search_select_handle"
              @keydown.native.enter="search_enter_handle"
              ref="main_search_form"
              )
            p.control
              b-button.search_form_submit_button(@click="search_click_handle" icon-left="magnify" size="is-large" :loading="$fetchState.pending" :disabled="!query")

          .columns.is-multiline.mt-4(v-if="display_key === 'critical' || display_key === 'last'")
            template(v-for="e in config.records")
              // https://bulma.io/documentation/columns/responsiveness/
              // widescreen 1/5 (is-one-fifth-widescreen)
              // desktop    1/4 (is-one-quarter-desktop)
              // table      1/4 (is-one-quarter-tablet)
              .column.is-one-fifth-widescreen.is-one-quarter-desktop.is-one-third-tablet.has-text-centered.px-0
                a.no-decoration(@click.stop.prevent="show_handle(e)")
                  SwarsBattleIndexMembershipUserLinkTo.is_line_break_on.is-size-7(:membership="e.memberships[1]")
                  MyShogiPlayer(
                    :run_mode="'view_mode'"
                    :debug_mode="false"
                    :start_turn="trick_start_turn_for(e)"
                    :kifu_body="e.sfen_body"
                    :theme="'simple'"
                    :size="'x-small'"
                    :sound_effect="false"
                    :vlayout="true"
                    :setting_button_show="false"
                    :summary_show="false"
                    :operation_disable="true"
                    :overlay_navi="false"
                    :flip="e.flip"
                  )
                  // :hidden_if_piece_stand_blank="display_key === 'critical'"
                  SwarsBattleIndexMembershipUserLinkTo.is_line_break_on.is-size-7(:membership="e.memberships[0]")

          template(v-if="display_key === 'table'")
            b-table.mt-5(
              v-if="$route.query.query"
              :loading="$fetchState.pending"

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

              b-table-column(v-slot="{row}" field="id" :label="config.table_columns_hash['id'].label" :visible="visible_hash.id" sortable numeric v-if="config.table_columns_hash.id")
                a(@click="show_handle(row)") \#{{row.id}}

              template(v-if="config.current_swars_user_key")
                b-table-column(v-slot="{row}" label="自分")
                  SwarsBattleIndexMembership(:visible_hash="visible_hash" :membership="row.memberships[0]")
                b-table-column(v-slot="{row}" label="相手")
                  SwarsBattleIndexMembership(:visible_hash="visible_hash" :membership="row.memberships[1]")
              template(v-else)
                b-table-column(v-slot="{row}" label="勝ち")
                  SwarsBattleIndexMembership(:visible_hash="visible_hash" :membership="row.memberships[0]")
                b-table-column(v-slot="{row}" label="負け")
                  SwarsBattleIndexMembership(:visible_hash="visible_hash" :membership="row.memberships[1]")

              b-table-column(v-slot="{row}" field="final_key" :label="config.table_columns_hash.final_info.label" :visible="visible_hash.final_info" sortable)
                span(:class="row.final_info.class")
                  | {{row.final_info.name}}

              b-table-column(v-slot="{row}" field="turn_max" :label="config.table_columns_hash.turn_max.label" :visible="visible_hash.turn_max" sortable numeric)
                | {{row.turn_max}}

              b-table-column(v-slot="{row}" field="critical_turn" :label="config.table_columns_hash.critical_turn.label" :visible="visible_hash.critical_turn" sortable numeric v-if="config.table_columns_hash.critical_turn")
                | {{row.critical_turn}}

              b-table-column(v-slot="{row}" field="outbreak_turn" :label="config.table_columns_hash.outbreak_turn.label" :visible="visible_hash.outbreak_turn" sortable numeric v-if="config.table_columns_hash.outbreak_turn")
                | {{row.outbreak_turn}}

              b-table-column(v-slot="{row}" field="grade_diff" :label="config.table_columns_hash.grade_diff.label" :visible="visible_hash.grade_diff" sortable numeric v-if="config.table_columns_hash.grade_diff")
                | {{row.grade_diff}}

              b-table-column(v-slot="{row}" field="rule_key" :label="config.table_columns_hash.rule_info.label" :visible="visible_hash.rule_info" sortable)
                | {{row.rule_info.name}}

              b-table-column(v-slot="{row}" field="preset_key" :label="config.table_columns_hash.preset_info.label" :visible="visible_hash.preset_info" sortable)
                | {{row.preset_info.name}}

              b-table-column(v-slot="{row}" field="battled_at" :label="config.table_columns_hash.battled_at.label" :visible="visible_hash.battled_at" sortable)
                | {{row_time_format(row.battled_at)}}

              b-table-column(v-slot="{row}")
                .buttons.are-small
                  PiyoShogiButton(type="button" :href="piyo_shogi_app_with_params_url(row)")
                  KentoButton(tag="a" :href="kento_app_with_params_url(row)")
                  KifCopyButton(@click="kifu_copy_handle(row)")
                  b-button(tag="nuxt-link" :to="{name: 'swars-battles-key', params: {key: row.key}}" @click.native="sound_play('click')") 詳細

    pre(v-if="development_p") {{config}}
</template>

<script>
import _ from "lodash"

import { store }   from "./store.js"
import { support } from "./support.js"

import { MyLocalStorage } from "@/components/models/MyLocalStorage.js"
import { ExternalAppInfo } from "@/components/models/ExternalAppInfo.js"

import SwarsBattleIndexCore from "./SwarsBattleIndexCore.js"

import MemoryRecord from 'js-memory-record'

class ZipKifuInfo extends MemoryRecord {
}
ZipKifuInfo.memory_record_reset([])

export default {
  store,
  name: "SwarsBattleIndex",
  mixins: [
    support,
    SwarsBattleIndexCore,
  ],

  beforeCreate() {
    this.$store.state.app = this
  },

  data() {
    return {
      sidebar_p: false,
      config: {},
    }
  },

  head() {
    return {
      title: this.page_title,
      meta: [
        { hid: "og:title",       property: "og:title",       content: "将棋ウォーズ棋譜検索"                            },
        { hid: "twitter:card",   property: "twitter:card",   content: "summary_large_image"                             },
        { hid: "og:image",       property: "og:image",       content: this.$config.MY_OGP_URL + "/ogp/swars-battles.png" },
        { hid: "og:description", property: "og:description", content: "ぴよ将棋やKENTOと連携して開けます。またクリップボード経由で棋譜を外部の将棋アプリに渡すような使い方ができます"                                                },
      ],
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

  fetch() {
    // this.clog(`fetch: ${this.$route.query}`)

    // this.sidebar_p = false

    // alert(`${this.$route.query.query} を設定`)
    // this.query = this.$route.query.query

    // http://0.0.0.0:3000/w.json?query=devuser1&format_type=user
    // http://0.0.0.0:4000/swars/users/devuser1

    // return this.$axios.$get("/w.json", {params: this.$route.query}).then(config => {
    this.clog(`fetch: ${JSON.stringify(this.$route.query)}`)
    return this.$axios.$get("/w.json", {params: this.$route.query}).then(config => {
      this.config = config

      // if (this.display_key == null) {
      //   this.display_key  = this.config.display_key // 何の局面の表示をするか？
      // }

      // this.query = this.config.query

      this.ls_setup() // config から visible_hash や display_key を設定

      ZipKifuInfo.memory_record_reset(this.config.zip_kifu_info)

      if (this.config.import_logs) {
        this.config.import_logs.forEach(e => {
          if (e.method === "dialog") {
            this.talk(e.title)
            this.$buefy.dialog.alert({
              title: e.title,
              type: `is-${e.type}`,
              hasIcon: true,
              message: e.message,
              onConfirm: () => { this.sound_play('click') },
              onCancel: () => { this.sound_play('click') },
            })
          }
          if (e.method === "toast") {
            this.general_ok_notice(e.message, {type: `is-${e.type}`})
          }
        })
      }
    })
  },

  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    // 検索すべてここで処理する
    interactive_search(params) { // private
      this.sound_play("click")
      if (this.$fetchState.pending) {
        this.general_ng_notice("連打すんな")
        return
      }
      const new_params = {...this.$route.query, ...params} // フィルターなどでは query を上書きする。またはなにもしない。
      if (Number(new_params.page || 0) <= 1) {
        delete new_params.page
      }
      this.clog("new_params", new_params)
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
      if (!this.config.current_swars_user_key) {
        this.general_ng_notice("先に誰かで検索してください")
        return
      }
      this.query = _.trim(`${this.config.current_swars_user_key} ${query}`)
      this.interactive_search({query: this.query})
    },

    filter_match_p(str) {
      const query = this.$route.query.query
      if (query) {
        return query.includes(str)
      }
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

    zip_dl_handle(key) {
      this.sound_play("click")
      const params = {
        ...this.$route.query,
        zip_kifu_key: key,
      }
      const usp = new URLSearchParams()
      _.each(params, (v, k) => usp.set(k, v))
      const url = this.$config.MY_SITE_URL + `/w.zip?${usp}`
      location.href = url
    },

    // チェックボックスをトグルする
    cb_toggle_handle(column) {
      this.sound_play('click')
      this.$set(this.visible_hash, column.key, !this.visible_hash[column.key])
    },

    row_class(row, index) {
      if (row.judge) {
        return `is-${row.judge.key}` // is- で始めないと mobile-cards になったとき消される
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
    page_title() {
      return _.compact([this.$route.query.query, "将棋ウォーズ棋譜検索"]).join(" - ")
    },

    ExternalAppInfo() { return ExternalAppInfo },
    ZipKifuInfo()     { return ZipKifuInfo     },

    wide_p() {
      return true
      // return this.config.total >= 1
    },

    search_form_complete_list() {
      if (this.config.remember_swars_user_keys) {
        return this.config.remember_swars_user_keys.filter((option) => {
          return option.toString().toLowerCase().indexOf((this.query || "").toLowerCase()) >= 0
        })
      }
    }
  },
}
</script>

<style scoped lang="sass">
.menu-label:not(:first-child)
  margin-top: 2em

// .MySidebarMenuIconWithTitle
//   display: flex
//   justify-content: flex-start
//   align-items: center
//   .my_title
//     width: 100%

.SwarsBattleIndex
  .section
    padding-top: 2.5rem
    +mobile
      padding-top: 1.6rem

  .container
    +mobile
      padding-left: 0 ! important
      padding-right: 0 ! important
</style>
