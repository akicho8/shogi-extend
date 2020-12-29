<template lang="pug">
.column.is-5.TsMasterRanking(v-if="base.idol_p && base.time_records_hash")
  b-field.scope_info_field
    template(v-for="e in base.ScopeInfo.values")
      b-radio-button(v-model="base.scope_key" :native-value="e.key" @input="sound_play('click')")
        | {{e.name}}

  b-tabs(v-model="base.current_rule_index" expanded @input="sound_play('click')")
    template(v-for="e in base.RuleInfo.values")
      b-tab-item(:label="e.name" :value="e.key")
        b-table(
          :data="base.time_records_hash[e.key]"
          :paginated="true"
          :per-page="base.config.per_page"
          :current-page.sync="base.current_pages[base.current_rule_index]"
          :pagination-simple="false"
          :mobile-cards="false"
          :row-class="(row, index) => row.id === (base.time_record && base.time_record.id) && 'is-selected'"
          :narrowed="true"
          default-sort-direction="desc"
          )
          b-table-column(v-slot="props" field="rank"       label="順位"  numeric centered :width="1") {{props.row.rank}}
          b-table-column(v-slot="props" field="entry_name" label="名前"  sortable) {{string_truncate(props.row.entry_name || '？？？', {length: 15})}}
          b-table-column(v-slot="props" field="spent_sec"  label="タイム") {{base.time_format_from_msec(props.row.spent_sec)}}
          b-table-column(v-slot="props" field="created_at" label="日付" :visible="!!base.curent_scope.date_visible") {{base.time_default_format(props.row.created_at)}}

  .has-text-centered-mobile
    b-switch(v-model="base.entry_name_uniq_p" @input="sound_play('click')") プレイヤー別順位
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "TsMasterRanking",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "./support.sass"

.STAGE-development
  .TsMasterRanking
    border: 1px dashed change_color($primary, $alpha: 0.5)

.TsMasterRanking
  +mobile
    margin-top: $xym_common_gap

  .scope_info_field
    .field
      +mobile
        justify-content: center
</style>
