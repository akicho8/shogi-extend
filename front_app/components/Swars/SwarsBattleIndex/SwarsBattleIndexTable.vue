<template lang="pug">
b-table.SwarsBattleIndexTable(
  v-if="$route.query.query || base.config.records.length >= 1"
  ref="table"

  :total        = "base.config.total"
  :current-page = "base.config.page"
  :per-page     = "base.config.per"

  :show-header  = "base.config.total >= 1 || true"
  :paginated    = "base.config.total >= 1 || true"
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

  b-table-column(v-slot="{row}" field="id" :label="base.config.table_columns_hash['id'].label" :visible="!!base.visible_hash.id" sortable numeric v-if="base.config.table_columns_hash.id")
    a(@click="show_handle(row)") \#{{row.id}}

  template(v-for="(membership_label, i) in membership_labels")
    b-table-column(v-slot="{row}" :label="membership_label")
      SwarsBattleIndexMembership(:base="base" :membership="row.memberships[i]" key="`records/${row.id}/${i}`")

  b-table-column(v-slot="{row}" field="final_key" :label="base.config.table_columns_hash.final_info.label" :visible="!!base.visible_hash.final_info" sortable)
    span(:class="row.final_info.class")
      | {{row.final_info.name}}

  b-table-column(v-slot="{row}" field="turn_max" :label="base.config.table_columns_hash.turn_max.label" :visible="!!base.visible_hash.turn_max" sortable numeric)
    | {{row.turn_max}}

  b-table-column(v-slot="{row}" field="critical_turn" :label="base.config.table_columns_hash.critical_turn.label" :visible="!!base.visible_hash.critical_turn" sortable numeric v-if="base.config.table_columns_hash.critical_turn")
    | {{row.critical_turn}}

  b-table-column(v-slot="{row}" field="outbreak_turn" :label="base.config.table_columns_hash.outbreak_turn.label" :visible="!!base.visible_hash.outbreak_turn" sortable numeric v-if="base.config.table_columns_hash.outbreak_turn")
    | {{row.outbreak_turn}}

  b-table-column(v-slot="{row}" field="grade_diff" :label="base.config.table_columns_hash.grade_diff.label" :visible="!!base.visible_hash.grade_diff" sortable numeric v-if="base.config.table_columns_hash.grade_diff")
    | {{row.grade_diff}}

  b-table-column(v-slot="{row}" field="rule_key" :label="base.config.table_columns_hash.rule_info.label" :visible="!!base.visible_hash.rule_info" sortable)
    | {{row.rule_info.name}}

  b-table-column(v-slot="{row}" field="preset_key" :label="base.config.table_columns_hash.preset_info.label" :visible="!!base.visible_hash.preset_info" sortable)
    | {{row.preset_info.name}}

  b-table-column(v-slot="{row}" field="battled_at" :label="base.config.table_columns_hash.battled_at.label" :visible="!!base.visible_hash.battled_at" sortable)
    | {{row_time_format(row.battled_at)}}

  b-table-column(v-slot="{row}")
    .buttons.are-small
      PiyoShogiButton(type="button" :href="base.piyo_shogi_app_with_params_url(row)" @click="sound_play('click')")
      KentoButton(tag="a" :href="base.kento_app_with_params_url(row)" @click="sound_play('click')")
      KifCopyButton(@click="base.kifu_copy_handle(row)")
      DetailButton(tag="nuxt-link" :to="{name: 'swars-battles-key', params: {key: row.key}, query: {viewpoint: row.memberships[0].location.key}}" @click.native="sound_play('click')") 詳細

</template>

<script>
import { support_child } from "./support_child.js"
import { Location      } from "shogi-player/components/models/location.js"

export default {
  name: "SwarsBattleIndexSidebar",
  mixins: [support_child],
  computed: {
    current_viewpoint_location() { return Location.fetch(this.base.config.viewpoint) },

    membership_labels() {
      let retv = null
      if (this.base.config.viewpoint) {
        retv = [
          this.current_viewpoint_location.name,
          this.current_viewpoint_location.flip.name,
        ]
      } else if (this.base.config.current_swars_user_key) {
        retv = [
          "自分",
          "相手",
        ]
      } else {
        retv = [
          "勝ち",
          "負け",
        ]
      }
      return retv
    }
  },
}
</script>

<style lang="sass">
SwarsBattleIndexTable
  .menu-label:not(:first-child)
    margin-top: 2em
</style>
