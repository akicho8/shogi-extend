<template lang="pug">
.SwarsSearchApp
  //- DebugBox
  //-   p http://0.0.0.0:4000/swars/search?query=devuser1
  b-sidebar(type="is-light" fullheight overlay v-model="sidebar_open_p")
    .mx-3.my-3
      .MySidebarMenuIconWithTitle
        b-icon.is_clickable(icon="menu" @click.native="sidebar_open_p = false")
        .my_title.has-text-centered
          nuxt-link.has-text-weight-bold.has-text-dark(:to="{name: 'index'}") SHOGI-EXTEND

      b-menu.mt-4
        b-menu-list(label="")
          b-menu-item(icon="home" tag="nuxt-link" :to="{name: 'index'}" label="ホーム")
          b-menu-item(@click="jump_to_user(config.current_swars_user_key)" icon="account" label="プレイヤー情報" :disabled="!config.current_swars_user_key")

        b-menu-list(label="表示形式")
          b-menu-item(@click.stop="board_show_type = 'none'")
            template(slot="label")
              | テーブル
              b-dropdown.is-pulled-right(position="is-bottom-left" :close-on-click="false" :mobile-modal="false" @active-change="sound_play('click')")
                b-icon(icon="dots-vertical" slot="trigger")
                template(v-for="(e, key) in table_columns_hash")
                  b-dropdown-item.px-4(@click.native.stop="cb_toggle_handle(e)" :key="key")
                    .has-text-weight-bold(v-if="visible_hash[key]")
                      | {{e.label}}
                    .has-text-grey(v-else)
                      | {{e.label}}

          b-menu-item(label="仕掛け"   @click.stop="board_show_type = 'outbreak_turn'" )
          b-menu-item(label="終局図"   @click.stop="board_show_type = 'last'"          )

        b-menu-list(label="フィルタ")
          b-menu-item(label="勝ち"    @click.stop="filter_search(`judge:win`)")
          b-menu-item(label="負け"    @click.stop="filter_search(`judge:lose`)")
          b-menu-item(label="なし"    @click.stop="filter_search(``)")

        b-menu-list(label="その他")
          b-menu-item(:disabled="!config.current_swars_user_key")
            template(slot="label" slot-scope="props")
              | ZIP ダウンロード
              b-icon.is-pulled-right(:icon="props.expanded ? 'menu-down' : 'menu-up'")
            template(v-for="e in ZipKifuInfo.values")
              b-menu-item(@click="zip_dl_handle(e.key)" :label="e.name")

        b-menu-list(label="test" v-if="development_p")
          b-menu-item
            template(slot="label")
              | Devices
              b-dropdown.is-pulled-right(position="is-bottom-left")
                b-icon(icon="dots-vertical" slot="trigger")
                b-dropdown-item Action
                b-dropdown-item Action
                b-dropdown-item Action

  b-navbar(type="is-primary" :mobile-burger="false" spaced)
    template(slot="brand")
      b-navbar-item(@click="sidebar_open_p = !sidebar_open_p")
        b-icon(icon="menu")
      b-navbar-item.has-text-weight-bold(tag="div") 将棋ウォーズ棋譜検索
    //- template(slot="end")
    //-   b-navbar-item(tag="a" href="/") TOP

  .section
    .columns
      .column
        b-field
          b-autocomplete(
            size="is-large"
            v-model.trim="query"
            :data="search_form_complete_list"
            list="search_field_query_completion"
            rounded
            type="search"
            placeholder="ウォーズIDを入力"
            open-on-focus
            expanded
            @focus="query = ''"
            @select="search_select_handle"
            @keydown.native.enter="search_enter_handle"
            )

            //- @select="ac_select"
            //- @typing="ac_typing"
            //- @focus="ac_focus"
            //- @keypress.native.enter="ac_keypress_native_enter"

          p.control
            b-button.search_form_submit_button(@click="search_click_handle" class="is-info" icon-left="magnify" size="is-large")

        .columns.is-multiline.mt-4(v-show="board_show_type === 'outbreak_turn' || board_show_type === 'last'")
          template(v-for="e in config.records")
            // https://bulma.io/documentation/columns/responsiveness/
            // widescreen 1/5 (is-one-fifth-widescreen)
            // desktop    1/4 (is-one-quarter-desktop)
            // table      1/4 (is-one-quarter-tablet)
            .column.is-one-fifth-widescreen.is-one-quarter-desktop.is-one-third-tablet.has-text-centered.px-0
              a.no-decoration(@click.stop.prevent="show_handle(e)")
                small.is_line_break_on.has-text-black-ter
                  | {{e.memberships[1].user.key}} {{e.memberships[1].grade_info.name}}
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
                // :hidden_if_piece_stand_blank="board_show_type === 'outbreak_turn'"
                small.is_line_break_on.has-text-black-ter
                  | {{e.memberships[0].user.key}} {{e.memberships[0].grade_info.name}}

        template(v-if="board_show_type === 'none'")
          b-table.is_battle_table(
            :loading="$fetchState.pending"

            paginated
            backend-pagination
            pagination-simple
            :current-page="page"
            :data="config.records"
            :total="total"
            :per-page="per"
            @page-change="page_change_handle"

            backend-sorting
            :default-sort-direction="config.sort_order_default"
            :default-sort="[sort_column, sort_order]"
            @sort="sort_handle"

            ref="table"

            :row-class="row_class"

            )

            TableEmpty(slot="empty" v-if="!$fetchState.pending && config.records.length === 0")

            b-table-column(v-slot="{row}" field="id" :label="table_columns_hash['id'].label" :visible="visible_hash.id" sortable numeric v-if="table_columns_hash.id")
              a(@click.stop :href="row.show_path") \#{{row.id}}

            template(v-if="config.current_swars_user_key")
              b-table-column(v-slot="{row}" label="自分")
                SwarsTableColumn(:visible_hash="visible_hash" :membership="row.memberships[0]")
              b-table-column(v-slot="{row}" label="相手")
                SwarsTableColumn(:visible_hash="visible_hash" :membership="row.memberships[1]")
            template(v-else)
              b-table-column(v-slot="{row}" label="勝ち")
                SwarsTableColumn(:visible_hash="visible_hash" :membership="row.memberships[0]")
              b-table-column(v-slot="{row}" label="負け")
                SwarsTableColumn(:visible_hash="visible_hash" :membership="row.memberships[1]")

            b-table-column(v-slot="{row}" field="final_key" :label="table_columns_hash.final_info.label" :visible="visible_hash.final_info" sortable)
              span(:class="row.final_info.class")
                | {{row.final_info.name}}

            b-table-column(v-slot="{row}" field="turn_max" :label="table_columns_hash.turn_max.label" :visible="visible_hash.turn_max" sortable numeric)
              | {{row.turn_max}}

            b-table-column(v-slot="{row}" field="critical_turn" :label="table_columns_hash.critical_turn.label" :visible="visible_hash.critical_turn" sortable numeric v-if="table_columns_hash.critical_turn")
              | {{row.critical_turn}}

            b-table-column(v-slot="{row}" field="outbreak_turn" :label="table_columns_hash.outbreak_turn.label" :visible="visible_hash.outbreak_turn" sortable numeric v-if="table_columns_hash.outbreak_turn")
              | {{row.outbreak_turn}}

            b-table-column(v-slot="{row}" field="grade_diff" :label="table_columns_hash.grade_diff.label" :visible="visible_hash.grade_diff" sortable numeric v-if="table_columns_hash.grade_diff")
              | {{row.grade_diff}}

            b-table-column(v-slot="{row}" field="rule_key" :label="table_columns_hash.rule_info.label" :visible="visible_hash.rule_info" sortable)
              | {{row.rule_info.name}}

            b-table-column(v-slot="{row}" field="preset_key" :label="table_columns_hash.preset_info.label" :visible="visible_hash.preset_info" sortable)
              | {{row.preset_info.name}}

            b-table-column(v-slot="{row}" field="battled_at" :label="table_columns_hash.battled_at.label" :visible="visible_hash.battled_at" sortable)
              | {{row_time_format(row.battled_at)}}

            b-table-column(v-slot="{row}")
              .buttons.are-small
                PiyoShogiButton(type="button" :href="piyo_shogi_app_with_params_url(row)")
                KentoButton(tag="a" @click.stop :href="kento_app_with_params_url(row)")
                KifCopyButton(@click.stop.prevent="kif_clipboard_copy({kc_path: row.show_path})")
                SpShowButton(@click="show_handle(row)")
                PulldownMenu(:record="row" position="is-bottom-right" :turn_offset="trick_start_turn_for(row)")

          //- - if current_records
          //-   - if Rails.env.development?
          //-     .columns
          //-       .column
          //-         = paginate current_records
          //-
          //-   .columns.is-unselectable(v-if="fetched_count >= 1 && records.length >= 1 && board_show_type === 'none'")
          //-     .column
          //-       - args = params.to_unsafe_h.except(:latest_open_index)
          //-       - list = [Kaminari.config.default_per_page, *AppConfig[:per_page_list], Kaminari.config.max_per_page]
          //-       = list.collect { |per| link_to(" #{per} ", args.merge(per: per)) }.join(tag.span(" / ", :class => "has-text-grey-lighter")).html_safe
          //-       span.has-text-grey-light.is-size-7
          //-         | 件ごと表示

        template(v-if="config.import_enable_p")
          template(v-if="config.records.length >= 1")
            .buttons.is-centered.are-small
              b-button.usage_modal_open_handle(@click="usage_modal_open_handle" icon-left="lightbulb-on-outline") 便利な使い方

  //- pre {{config}}
</template>

<script>
import { store }   from "./store.js"
import { support } from "./support.js"

import battle_index_mod from "./battle_index_mod.js"
import usage_mod from "./usage_mod.js"

import MemoryRecord from 'js-memory-record'

class ZipKifuInfo extends MemoryRecord {
}

export default {
  store,
  name: "SwarsSearchApp",
  mixins: [
    support,
    battle_index_mod,
    usage_mod,
  ],
  props: {
    // config: { type: Object, required: true },
  },

  beforeCreate() {
    this.$store.state.app = this
  },

  data() {
    return {
      sidebar_open_p: false,
      submited: false,
      detailed: false,
      config: {},
    }
  },

  head() {
    return {
      title: "将棋ウォーズ棋譜検索",
      meta: [
        { hid: "og:title",       property: "og:title",       content: "将棋ウォーズ棋譜検索"                            },
        { hid: "twitter:card",   property: "twitter:card",   content: "summary_large_image"                             },
        { hid: "og:image",       property: "og:image",       content: this.$config.MY_OGP_URL + "/ogp/swars-search.png" },
        { hid: "og:description", property: "og:description", content: ""                                                },
      ],
    }
  },

  watch: {
    '$route.query': '$fetch',
  },

  fetch() {
    // http://0.0.0.0:3000/w.json?query=devuser1&format_type=user
    // http://0.0.0.0:4000/swars/users/devuser1
    return this.$axios.$get("/w.json", {params: this.$route.query}).then(config => {
      this.config = config
      this.search_scope_key = this.config.search_scope_key // スコープ
      this.board_show_type  = this.config.board_show_type // 何の局面の表示をするか？
      this.records          = this.config.records // 表示するレコード配列

      this.total            = this.config.total
      this.page             = this.config.page
      this.per              = this.config.per

      this.sort_column      = this.config.sort_column
      this.sort_order       = this.config.sort_order

      this.query              = this.config.query
      this.table_columns_hash = this.config.table_columns_hash

      this.$_ls_setup()
      ZipKifuInfo.memory_record_reset(this.config.zip_kifu_info)
    })
  },

  // async asyncData({ $axios, query }) {
  //   // http://0.0.0.0:4000/swars/search?query=devuser1
  //   // http://0.0.0.0:3000/w.json?query=devuser1
  //   console.log("asyncData")
  //   const config = await $axios.$get("/w.json", {params: query})
  //   return { config }
  // },

  computed: {
    query_key() {
      if (this.config) {
        return this.config.current_swars_user_key
      }
    },

    ZipKifuInfo() { return ZipKifuInfo },

    permalink_url() {
      return this.query_url_build(this.query)
    },

    // 最初に一覧を表示するか？
    index_table_show_p() {
      // required_query_for_search の指定がなければ常に表示する
      if (!this.config.required_query_for_search) {
        return true
      }
      // テーブルを表示する条件は検索文字列があること。または modal_record があること。
      // フォームに割り当てられている this.query だと変動するので使ってはいけない
      return this.config.query // || this.config.modal_record
    },

    search_form_complete_list() {
      return this.config.remember_swars_user_keys.filter((option) => {
        return option.toString().toLowerCase().indexOf(this.query.toLowerCase()) >= 0
      })
    }
  },

  methods: {
    zip_dl_handle(key) {
      const params = new URLSearchParams()
      params.set("zip_kifu_key", key)
      params.set("query", this.query)
      const url = this.$config.MY_SITE_URL + `/w.zip?${params}`
      location.href = url
    },

    // チェックボックスをトグルする
    cb_toggle_handle(column) {
      this.sound_play('click')
      this.$set(this.visible_hash, column.key, !this.visible_hash[column.key])
      // if (this.visible_hash[column.key]) {
      //   this.say(column.name)
      // }
    },

    query_search(query) {
      this.$router.push({to: "swars-search", query: {query: query}})
      // this.query = query
      // window.history.replaceState("", null, this.permalink_url)
      // this.async_records_load()
    },
    filter_search(query) {
      if (this.config.current_swars_user_key) {
        this.$router.push({to: "swars-search", query: {query: _.trim(`${this.config.current_swars_user_key} ${query}`)}})
      }
      // this.query = query
      // window.history.replaceState("", null, this.permalink_url)
      // this.async_records_load()
      // }
    },

    form_submited(e) {
      this.process_now()

      this.submited = true
    },

    query_url_build(query) {
      const params = new URLSearchParams()
      params.set("query", query)
      return `/w?${params}`
    },

    row_class(row, index) {
      if (row.judge) {
        return `is-${row.judge.key}` // is- で始めないと mobile-cards になったとき消される
      }
    },
  },
}
</script>

<style lang="sass">
.MySidebarMenuIconWithTitle
  display: flex
  justify-content: flex-start
  align-items: center
  .my_title
    width: 100%

.SwarsSearchApp
  .section
    &:first-of-type
      padding-top: 1.8rem

  //////////////////////////////////////////////////////////////////////////////// 便利な使い方

  .usage_modal
    li:not(:first-child)
      margin-top: 0.8rem

  //////////////////////////////////////////////////////////////////////////////// 検索の下のところ

  .search_bottom_controllers
    justify-content: space-around
    +desktop
      justify-content: flex-start
    .search_index_dropdown_menu
    .board_show_type_field
      margin-left: 1rem
    .player_info_show_button
      margin-left: 1rem

  //////////////////////////////////////////////////////////////////////////////// テーブル上のチェックボックス

  .table_column_toggle_checkboxes
    +mobile
      .is-grouped
        justify-content: center
        .control-label
          padding-left: 0.18rem // 「□(ここ)ラベル」の隙間

  //////////////////////////////////////////////////////////////////////////////// モバイル時の shogi-player の横スペース調整用

  .sp_mobile_padding
    +mobile
      padding-left: 0px
      padding-right: 0px
</style>
