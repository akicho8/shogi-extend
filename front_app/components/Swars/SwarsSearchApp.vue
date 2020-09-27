<template lang="pug">
.SwarsSearchApp
  //- DebugBox
  //-   p http://0.0.0.0:4000/swars/search?query=devuser1

  b-navbar(type="is-primary")
    template(slot="brand")
      b-navbar-item.has-text-weight-bold(tag="div") 将棋ウォーズ棋譜検索
    template(slot="end")
      b-navbar-item(tag="a" href="/") TOP

  .section
    .columns
      .column
        b-field
          b-autocomplete(name="query" v-model.trim="query" :data="search_form_complete_list" rounded icon="magnify" type="search" placeholder="ウォーズIDを入力" ref="query_field" :open-on-focus="true" expanded list="search_field_query_completion" @select="ac_select" @typing="ac_typing" @focus="ac_focus" @keypress.native.enter="ac_keypress_native_enter")
          p.control
            b-button.search_form_submit_button(@click="search_handle" class="is-info" icon-left="magnify")

        .search_bottom_controllers.mt-5.is-flex(v-if="config.current_swars_user_key")
          template(v-if="config.current_swars_user_key")
            b-dropdown.search_index_dropdown_menu(position="is-bottom-right")
              b-button(slot="trigger" size="is-small" icon-left="menu") フィルタ
              b-dropdown-item(@click="query_search(`${config.current_swars_user_key} judge:win`)") 勝ち
              b-dropdown-item(@click="query_search(`${config.current_swars_user_key} judge:lose`)") 負け
              template(v-if="config.current_swars_user_key !== $route.query.query")
                b-dropdown-item(separator)
                b-dropdown-item(@click="query_search(config.current_swars_user_key)") 解除

          b-field.board_show_type_field
            b-radio-button(v-model="board_show_type" size="is-small" native-value="none") テーブル
            b-radio-button(v-model="board_show_type" size="is-small" native-value="outbreak_turn") 仕掛け
            b-radio-button(v-model="board_show_type" size="is-small" native-value="last") 終局図

          template(v-if="config.current_swars_user_key")
            b-button.player_info_show_button(@click="user_info_show_modal2(config.current_swars_user_key)" icon-left="account" size="is-small" rounded) プレイヤー情報

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
          template(v-if="records.length >= 1")
            b-field.table_column_toggle_checkboxes.mt-3(grouped group-multiline)
              .control(v-for="(value, key, index) in table_columns_hash" :key="index")
                b-checkbox(v-model="visible_hash[key]" size="is-small")
                  | {{value.label}}

          //- b-table(:data="records")
          //-   b-table-column(v-slot="{row}" field="id" :label="ID" sortable numeric) {{row.id}}

          b-table.is_battle_table(
            v-if="index_table_show_p"

            :loading="loading"

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

            TableEmpty(slot="empty")

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

          template(v-if="development_p")
            .box.is_line_break_on
              p page:{{page}} per:{{per}} total:{{total}} loading:{{loading}} records.length:{{records.length}} sort_column:{{sort_column}} sort_order:{{sort_order}} config.sort_order_default={{config.sort_order_default}}
              p visible_only_keys: {{visible_only_keys}}
              p permalink_url: {{permalink_url}}

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
              b-button.zip_dl_modal_open_handle(@click="zip_dl_modal_open_handle" icon-left="download") ZIP

  pre {{config}}
</template>

<script>
import { store }   from "./store.js"
import { support } from "./support.js"

import battle_index_mod from "./battle_index_mod.js"
import usage_mod from "./usage_mod.js"

// import { app_room      } from "./app_room.js"
// import { app_room_init } from "./app_room_init.js"
//
// import the_pulldown_menu                  from "./the_pulldown_menu.vue"
// import the_image_view_point_setting_modal from "./the_image_view_point_setting_modal.vue"
// import the_any_source_read_modal          from "./the_any_source_read_modal.vue"
//
// import shogi_player from "shogi-player/src/components/ShogiPlayer.vue"

export default {
  store,
  name: "SwarsSearchApp",
  mixins: [
    support,
    battle_index_mod,
    usage_mod,
  ],
  // components: {
  //   shogi_player,
  //   the_pulldown_menu,
  //   the_image_view_point_setting_modal,
  //   the_any_source_read_modal,
  // },
  props: {
    config: { type: Object, required: true },
  },

  beforeCreate() {
    this.$store.state.app = this
  },

  data() {
    return {
      submited: false,
      detailed: false,
    }
  },

  created() {
    // GVI.$on("query_search", e => this.query_search(e))
  },

  beforeDestroy() {
    // GVI.$off("query_search")
  },

  mounted() {
    // if (this.index_table_show_p) {
    //   this.async_records_load()
    // }
  },

  computed: {
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
      return this.config.query || this.config.modal_record
    },

    search_form_complete_list() {
      return this.config.remember_swars_user_keys.filter((option) => {
        return option.toString().toLowerCase().indexOf(this.query.toLowerCase()) >= 0
      })
    }
  },

  methods: {
    query_search(query) {
      this.$router.push({to: "swars-search", query: {query: query}})
      // this.query = query
      // window.history.replaceState("", null, this.permalink_url)
      // this.async_records_load()
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

  //////////////////////////////////////////////////////////////////////////////// 検索ボタン

  .search_form_submit_button
    min-width: 4rem

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
