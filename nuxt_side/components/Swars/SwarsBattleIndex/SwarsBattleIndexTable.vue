<template lang="pug">
b-table.SwarsBattleIndexTable(
  v-if="$route.query.query || $gs.present_p(APP.xi.records)"

  :total        = "APP.xi.total"
  :current-page = "APP.xi.page"
  :per-page     = "APP.xi.per"

  :show-header="APP.column_visible_p('tablet_header')"
  paginated
  scrollable
  :mobile-cards="APP.column_visible_p('mobile_card')"

  :hoverable="false"

  backend-pagination
  pagination-simple
  :data="APP.xi.records"
  @page-change="(page) => APP.page_change_or_sort_handle({page})"

  backend-sorting
  :default-sort-direction="APP.xi.sort_order_default"
  :default-sort="[APP.xi.sort_column, APP.xi.sort_order]"
  @sort="(sort_column, sort_order) => APP.page_change_or_sort_handle({sort_column, sort_order})"
  :row-class="APP.row_class"
  )

  SwarsBattleIndexTableEmpty(slot="empty" v-if="!APP.loading_p && $route.query.query && APP.xi.total === 0")

  b-table-column(v-slot="{row}" field="id" :label="APP.ColumnInfo.fetch('id').name" :visible="APP.column_visible_p('id')" sortable centered numeric)
    nuxt-link(:to="APP.show_route_params(row)" @click.native="sfx_play_click()") \#{{row.id}}

  b-table-column(v-slot="{row}" :label="APP.xi.current_swars_user_key ? '自分' : 'WIN'" :visible="APP.column_visible_p('membership_left')" cell-class="membership")
    SwarsBattleIndexMembership(:row="row" :membership="row.memberships[0]" :with_user_key="APP.column_visible_p('user_key_left')")

  b-table-column(v-slot="{row}" :label="APP.xi.current_swars_user_key ? '相手' : 'LOSE'" :visible="APP.column_visible_p('membership_right')" cell-class="membership")
    SwarsBattleIndexMembership(:row="row" :membership="row.memberships[1]" :with_user_key="APP.column_visible_p('user_key_right')")

  b-table-column(v-slot="{row}" field="membership.style_id" :label="APP.ColumnInfo.fetch('style_key').name" :visible="APP.column_visible_p('style_key')" sortable centered)
    SwarsBattleIndexTableCellStyleBoth(:memberships="row.memberships")

  b-table-column(v-slot="{row}" field="membership.judge_id" :label="APP.ColumnInfo.fetch('judge_key').name" :visible="APP.column_visible_p('judge_key')" sortable centered)
    | {{APP.JudgeInfo.fetch(row.memberships[0].judge_key).name}}

  b-table-column(v-slot="{row}" field="membership.location_id" :label="APP.ColumnInfo.fetch('location_key').name" :visible="APP.column_visible_p('location_key')" sortable centered)
    template(v-if="row.preset_info.handicap_shift === 0")
      | {{APP.Location.fetch(row.memberships[0].location_key).name}}
    template(v-else)
      | {{APP.Location.fetch(row.memberships[0].location_key).handicap_long_name}}

  b-table-column(v-slot="{row}" field="final_id" :label="APP.ColumnInfo.fetch('final_key').name" :visible="APP.column_visible_p('final_key')" sortable centered)
    span(:class="row.final_info.class") {{row.final_info.name}}

  b-table-column(v-slot="{row}" field="turn_max" :label="APP.ColumnInfo.fetch('turn_max').name" :visible="APP.column_visible_p('turn_max')" sortable numeric centered)
    | {{row.turn_max}}

  b-table-column(v-slot="{row}" field="critical_turn" :label="APP.ColumnInfo.fetch('critical_turn').name" :visible="APP.column_visible_p('critical_turn')" sortable numeric centered)
    | {{row.critical_turn}}

  b-table-column(v-slot="{row}" field="outbreak_turn" :label="APP.ColumnInfo.fetch('outbreak_turn').name" :visible="APP.column_visible_p('outbreak_turn')" sortable numeric centered)
    | {{row.outbreak_turn}}

  b-table-column(v-slot="{row}" field="membership.grade_diff" :label="APP.ColumnInfo.fetch('grade_diff').name" :visible="APP.column_visible_p('grade_diff')" sortable numeric centered)
    | {{row.grade_diff}}

  b-table-column(v-slot="{row}" field="rule_id" :label="APP.ColumnInfo.fetch('rule_key').name" :visible="APP.column_visible_p('rule_key')" sortable centered)
    | {{row.rule_info.name}}

  b-table-column(v-slot="{row}" field="xmode_id" :label="APP.ColumnInfo.fetch('xmode_key').name" :visible="APP.column_visible_p('xmode_key')" sortable centered)
    | {{row.xmode_info.name}}

  b-table-column(v-slot="{row}" field="imode_id" :label="APP.ColumnInfo.fetch('imode_key').name" :visible="APP.column_visible_p('imode_key')" sortable centered)
    | {{row.imode_info.name}}

  b-table-column(v-slot="{row}" field="preset_id" :label="APP.ColumnInfo.fetch('preset_key').name" :visible="APP.column_visible_p('preset_key')" sortable centered)
    nuxt-link.is_hover_only_link_color(:to="{name: 'swars-search', query: {query: row.preset_info.name}}" @click.native="sfx_play_click()")
      | {{row.preset_info.name}}

  b-table-column(v-slot="{row}" field="battled_at" :label="APP.ColumnInfo.fetch('battled_at').name" :visible="APP.column_visible_p('battled_at')" sortable centered)
    | {{$time.format_row(row.battled_at)}}

  b-table-column(v-slot="{row}" :visible="APP.operation_any_column_visible_p")
    .buttons.are-small
      PiyoShogiButton(
        v-if="APP.column_visible_p('piyo_shogi')"
        type="button"
        :href="APP.kifu_vo(row).piyo_url"
        @click="sfx_play_click()"
        )

      KentoButton(
        v-if="APP.column_visible_p('kento')"
        tag="a"
        :href="APP.kifu_vo(row).kento_url"
        @click="sfx_play_click()"
        )

      KifCopyButton.kif_copy(
        v-if="APP.column_visible_p('kif_copy')"
        @click="APP.kifu_copy_handle(row, {format: 'kif'})"
        title="KIF をクリップボードにコピーする"
        )

      KifCopyButton.ki2_copy(
        v-if="APP.column_visible_p('ki2_copy')"
        @click="APP.kifu_copy_handle(row, {format: 'ki2'})"
        name="KI2"
        title="KI2 をクリップボードにコピーする"
        )

      a.button.kif_save_as_utf8(
        v-if="APP.column_visible_p('kif_save_as_utf8')"
        :href="APP.kifu_save_url(row, {body_encode: 'UTF-8'})"
        @click="APP.kifu_save_handle(row)"
        title="KIF を UTF-8 でファイルに保存する"
        ) 保存

      a.button.kif_save_as_shiftjis(
        v-if="APP.column_visible_p('kif_save_as_shiftjis')"
        :href="APP.kifu_save_url(row, {body_encode: 'Shift_JIS'})"
        @click="APP.kifu_save_handle(row)"
        title="KIF を Shift_JIS でファイルに保存する"
        ) 保存

      ShowButton(
        v-if="APP.column_visible_p('show')"
        tag="nuxt-link"
        :to="{name: 'swars-battles-key', params: {key: row.key}, query: {viewpoint: row.memberships[0].location_key}}"
        @click.native="sfx_play_click()"
        )
        | 詳細
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsBattleIndexSidebar",
  mixins: [support_child],
}
</script>

<style lang="sass">
.SwarsBattleIndexTable
  .menu-label:not(:first-child)
    margin-top: 2em
  .buttons
    flex-wrap: nowrap
  td.membership
    vertical-align: initial
</style>
