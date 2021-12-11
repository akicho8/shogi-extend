<template lang="pug">
b-table.SwarsBattleIndexTable(
  v-if="$route.query.query || present_p(base.config.records)"

  :total        = "base.config.total"
  :current-page = "base.config.page"
  :per-page     = "base.config.per"

  show-header
  paginated
  scrollable

  :hoverable="false"

  backend-pagination
  pagination-simple
  :data="base.config.records"
  @page-change="(page) => base.page_change_or_sort_handle({page})"

  backend-sorting
  :default-sort-direction="base.config.sort_order_default"
  :default-sort="[base.config.sort_column, base.config.sort_order]"
  @sort="(sort_column, sort_order) => base.page_change_or_sort_handle({sort_column, sort_order})"
  :row-class="base.row_class"
  )

  SwarsBattleIndexTableEmpty(slot="empty" v-if="!base.$fetchState.pending && $route.query.query && base.config.total === 0")

  b-table-column(v-slot="{row}" field="id" :label="base.ColumnInfo.fetch('id').name" :visible="column_visible_p('id')" sortable numeric)
    a(@click="base.show_handle(row)") \#{{row.id}}

  b-table-column(v-slot="{row}" label="自分" :visible="column_visible_p('membership_left')")
    SwarsBattleIndexMembership(:base="base" :membership="row.memberships[0]")

  b-table-column(v-slot="{row}" label="相手" :visible="column_visible_p('membership_right')")
    SwarsBattleIndexMembership(:base="base" :membership="row.memberships[1]")

  b-table-column(v-slot="{row}" field="final_key" :label="base.ColumnInfo.fetch('final_key').name" :visible="column_visible_p('final_key')" sortable)
    span(:class="row.final_info.class") {{row.final_info.name}}

  b-table-column(v-slot="{row}" field="turn_max" :label="base.ColumnInfo.fetch('turn_max').name" :visible="column_visible_p('turn_max')" sortable numeric)
    | {{row.turn_max}}

  b-table-column(v-slot="{row}" field="critical_turn" :label="base.ColumnInfo.fetch('critical_turn').name" :visible="column_visible_p('critical_turn')" sortable numeric)
    | {{row.critical_turn}}

  b-table-column(v-slot="{row}" field="outbreak_turn" :label="base.ColumnInfo.fetch('outbreak_turn').name" :visible="column_visible_p('outbreak_turn')" sortable numeric)
    | {{row.outbreak_turn}}

  b-table-column(v-slot="{row}" field="grade_diff" :label="base.ColumnInfo.fetch('grade_diff').name" :visible="column_visible_p('grade_diff')" sortable numeric)
    | {{row.grade_diff}}

  b-table-column(v-slot="{row}" field="rule_key" :label="base.ColumnInfo.fetch('rule_key').name" :visible="column_visible_p('rule_key')" sortable)
    | {{row.rule_info.name}}

  b-table-column(v-slot="{row}" field="preset_key" :label="base.ColumnInfo.fetch('preset_key').name" :visible="column_visible_p('preset_key')" sortable)
    | {{row.preset_info.name}}

  b-table-column(v-slot="{row}" field="battled_at" :label="base.ColumnInfo.fetch('battled_at').name" :visible="column_visible_p('battled_at')" sortable)
    | {{row_time_format(row.battled_at)}}

  b-table-column(v-slot="{row}" :visible="operation_any_column_visible_p")
    .buttons.are-small

      PiyoShogiButton(type="button" :href="base.piyo_shogi_app_with_params_url(row)" @click="sound_play_click()" v-if="column_visible_p('piyo_shogi')")

      KentoButton(tag="a" :href="base.kento_app_with_params_url(row)" @click="sound_play_click()" v-if="column_visible_p('kento')")

      KifCopyButton(@click="base.kifu_copy_handle(row)" v-if="column_visible_p('kif_copy')")

      ShowButton(
        tag="nuxt-link"
        :to="{name: 'swars-battles-key', params: {key: row.key}, query: {viewpoint: row.memberships[0].location.key}}"
        @click.native="sound_play_click()"
        v-if="column_visible_p('show')")
        | 詳細

</template>

<script>
import { support_child } from "./support_child.js"
import { Location      } from "shogi-player/components/models/location.js"

export default {
  name: "SwarsBattleIndexSidebar",
  mixins: [support_child],
  methods: {
    column_visible_p(key) {
      return this.base.ColumnInfo.fetch(key).available_p(this.base) && this.base.visible_hash[key]
    },
  },
  computed: {
    operation_any_column_visible_p() {
      const ary = this.base.ColumnInfo.values.filter(e => e.operation_p)
      return ary.some(e => this.column_visible_p(e.key))
    },
  },
}
</script>

<style lang="sass">
.SwarsBattleIndexTable
  .menu-label:not(:first-child)
    margin-top: 2em
</style>
