<template lang="pug">
b-table.SwarsBattleIndexTable(
  v-if="$route.query.query || present_p(base.xi.records)"

  :total        = "base.xi.total"
  :current-page = "base.xi.page"
  :per-page     = "base.xi.per"

  :show-header="base.column_visible_p('tablet_header')"
  paginated
  scrollable
  :mobile-cards="base.column_visible_p('mobile_card')"

  :hoverable="false"

  backend-pagination
  pagination-simple
  :data="base.xi.records"
  @page-change="(page) => base.page_change_or_sort_handle({page})"

  backend-sorting
  :default-sort-direction="base.xi.sort_order_default"
  :default-sort="[base.xi.sort_column, base.xi.sort_order]"
  @sort="(sort_column, sort_order) => base.page_change_or_sort_handle({sort_column, sort_order})"
  :row-class="base.row_class"
  )

  SwarsBattleIndexTableEmpty(slot="empty" v-if="!base.$fetchState.pending && $route.query.query && base.xi.total === 0")

  b-table-column(v-slot="{row}" field="id" :label="base.ColumnInfo.fetch('id').name" :visible="base.column_visible_p('id')" sortable centered numeric)
    a(@click="base.show_handle(row)") \#{{row.id}}

  b-table-column(v-slot="{row}" label="自分" :visible="base.column_visible_p('membership_left')")
    SwarsBattleIndexMembership(:base="base" :row="row" :membership="row.memberships[0]" :with_user_key="base.column_visible_p('user_key_left')")

  b-table-column(v-slot="{row}" label="相手" :visible="base.column_visible_p('membership_right')")
    SwarsBattleIndexMembership(:base="base" :row="row" :membership="row.memberships[1]" :with_user_key="base.column_visible_p('user_key_right')")

  b-table-column(v-slot="{row}" field="membership.judge_id" :label="base.ColumnInfo.fetch('judge_key').name" :visible="base.column_visible_p('judge_key')" sortable centered)
    | {{base.JudgeInfo.fetch(row.memberships[0].judge_key).name}}

  b-table-column(v-slot="{row}" field="membership.location_id" :label="base.ColumnInfo.fetch('location_key').name" :visible="base.column_visible_p('location_key')" sortable centered)
    template(v-if="row.preset_info.handicap_shift === 0")
      | {{base.Location.fetch(row.memberships[0].location_key).name}}
    template(v-else)
      | {{base.Location.fetch(row.memberships[0].location_key).handicap_long_name}}

  b-table-column(v-slot="{row}" field="final_id" :label="base.ColumnInfo.fetch('final_key').name" :visible="base.column_visible_p('final_key')" sortable centered)
    span(:class="row.final_info.class") {{row.final_info.name}}

  b-table-column(v-slot="{row}" field="turn_max" :label="base.ColumnInfo.fetch('turn_max').name" :visible="base.column_visible_p('turn_max')" sortable numeric centered)
    | {{row.turn_max}}

  b-table-column(v-slot="{row}" field="critical_turn" :label="base.ColumnInfo.fetch('critical_turn').name" :visible="base.column_visible_p('critical_turn')" sortable numeric centered)
    | {{row.critical_turn}}

  b-table-column(v-slot="{row}" field="outbreak_turn" :label="base.ColumnInfo.fetch('outbreak_turn').name" :visible="base.column_visible_p('outbreak_turn')" sortable numeric centered)
    | {{row.outbreak_turn}}

  b-table-column(v-slot="{row}" field="membership.grade_diff" :label="base.ColumnInfo.fetch('grade_diff').name" :visible="base.column_visible_p('grade_diff')" sortable numeric centered)
    | {{row.grade_diff}}

  b-table-column(v-slot="{row}" field="rule_id" :label="base.ColumnInfo.fetch('rule_key').name" :visible="base.column_visible_p('rule_key')" sortable centered)
    | {{row.rule_info.name}}

  b-table-column(v-slot="{row}" field="xmode_id" :label="base.ColumnInfo.fetch('xmode_key').name" :visible="base.column_visible_p('xmode_key')" sortable centered)
    | {{row.xmode_info.name}}

  b-table-column(v-slot="{row}" field="preset_id" :label="base.ColumnInfo.fetch('preset_key').name" :visible="base.column_visible_p('preset_key')" sortable centered)
    | {{row.preset_info.name}}

  b-table-column(v-slot="{row}" field="battled_at" :label="base.ColumnInfo.fetch('battled_at').name" :visible="base.column_visible_p('battled_at')" sortable centered)
    | {{$time.format_row(row.battled_at)}}

  b-table-column(v-slot="{row}" :visible="base.operation_any_column_visible_p")
    .buttons.are-small
      PiyoShogiButton(
        v-if="base.column_visible_p('piyo_shogi')"
        type="button"
        :href="base.piyo_shogi_app_with_params_url(row)"
        @click="$sound.play_click()"
        )

      KentoButton(
        v-if="base.column_visible_p('kento')"
        tag="a"
        :href="base.kento_app_with_params_url(row)"
        @click="$sound.play_click()"
        )

      KifCopyButton(
        v-if="base.column_visible_p('kif_copy')"
        @click="base.kifu_copy_handle(row)"
        )

      a.button.kif_save_as_utf8(
        v-if="base.column_visible_p('kif_save_as_utf8')"
        :href="base.kifu_save_url(row, {body_encode: 'UTF-8'})"
        @click="base.kifu_save_handle(row)"
        ) 保存

      a.button.kif_save_as_shiftjis(
        v-if="base.column_visible_p('kif_save_as_shiftjis')"
        :href="base.kifu_save_url(row, {body_encode: 'Shift_JIS'})"
        @click="base.kifu_save_handle(row)"
        ) 保存

      ShowButton(
        v-if="base.column_visible_p('show')"
        tag="nuxt-link"
        :to="{name: 'swars-battles-key', params: {key: row.key}, query: {viewpoint: row.memberships[0].location_key}}"
        @click.native="$sound.play_click()"
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
</style>
