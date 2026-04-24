<template lang="pug">
.column.is-5.XyMasterRanking(v-if="TheApp.is_mode_idol && TheApp.time_records_hash")
  b-field.scope_info_field
    template(v-for="e in TheApp.ScopeInfo.values")
      b-radio-button(v-model="TheApp.scope_key" :native-value="e.key" @input="sfx_click()")
        | {{e.name}}

  b-tabs(v-model="TheApp.current_rule_index" expanded @input="sfx_click()")
    template(v-for="e in TheApp.RuleInfo.values")
      b-tab-item(:label="e.name" :value="e.key")
        b-table(
          :data="TheApp.time_records_hash[e.key]"
          :paginated="true"
          :per-page="TheApp.config.per_page"
          :current-page.sync="TheApp.current_pages[TheApp.current_rule_index]"
          :pagination-simple="false"
          :mobile-cards="false"
          :row-class="(row, index) => row.id === (TheApp.time_record && TheApp.time_record.id) && 'is-selected'"
          :narrowed="true"
          default-sort-direction="desc"
          )
          b-table-column(v-slot="{row}" field="rank" label="順位"  sortable numeric centered :width="1" cell-class="index_td")
            template(v-if="badge_hash[row.rank]")
              XemojiWrap.badge(:str="badge_hash[row.rank]")
            template(v-else)
              | {{row.rank}}
          b-table-column(v-slot="{row}" field="entry_name" label="名前" sortable cell-class="entry_name_td")
            XemojiWrap(:str="$GX.str_truncate(row.entry_name || '？？？', {length: 12})")

          b-table-column(v-slot="{row}" field="spent_sec"  label="タイム" sortable cell-class="spent_sec") {{TheApp.time_format_from_msec(row.spent_sec)}}
          b-table-column(v-slot="{row}" field="x_count"    label="X" sortable numeric centered) {{row.x_count}}
          b-table-column(v-slot="{row}" field="created_at" label="日付" :visible="!!TheApp.curent_scope.date_show_p") {{TheApp.time_default_format(row.created_at)}}

  .has-text-centered-mobile
    b-switch(v-model="TheApp.entry_name_uniq_p" @input="sfx_click()") プレイヤー別順位
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XyMasterRanking",
  mixins: [support_child],
  computed: {
    badge_hash() {
      return {
        "1": "🥇",
        "2": "🥈",
        "3": "🥉",
      }
    },
  },
}
</script>

<style lang="sass">
@import "./support.sass"

.STAGE-development
  .XyMasterRanking
    border: 1px dashed change_color($primary, $alpha: 0.5)

.XyMasterRanking
  +mobile
    margin-top: $xy_master_common_gap

  .scope_info_field
    .field
      +mobile
        justify-content: center

  // .entry_name
  //   min-width: 12rem // これがないと3文字しか見えない

  .table
    td
      vertical-align: middle
  .table
    .index_td
      padding: 0
      height: stretch
      .badge
        display: flex
        justify-content: center
        .xemoji
          height: 1.25em
          width: unset
</style>
