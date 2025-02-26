<template lang="pug">
.SwarsCustomSearchFormAll.form_block
  b-field.field_block.new_query_field(label="" v-if="new_query_field_show")
    b-field(grouped)
      b-input(v-model.trim="TheApp.new_query" readonly expanded autocomplete="off" spellcheck="false")
      p.control
        b-button.has-text-weight-bold(@click="TheApp.search_click_handle" type="is-primary" :disabled="TheApp.swars_id_required_message")
          | 検索

  .columns.form_block.is-multiline.is-variable.is-0-mobile.is-0-tablet.is-0-desktop.is-0-widescreen.is-0-fullhd

    .column.is-6-tablet.is-4-desktop
      b-field.field_block.user_key(custom-class="is-small" :type="{'is-danger': TheApp.swars_id_required_message}" :message="TheApp.swars_id_required_message")
        template(#label)
          | 対象のウォーズID
          span.mx-2(class="has-text-grey has-text-weight-normal is-italic is-size-7")
            | 必須
        b-input(v-model.trim="TheApp.user_key" placeholder="BOUYATETSU5" :size="TheApp.input_element_size" :disabled="!user_key_field_show" spellcheck="false")

    .column.is-6-tablet.is-4-desktop
      ScsCheckbox(label1="持ち時間"   :records="TheApp.xi.rule_infos"  var_name="rule_keys")

    .column.is-6-tablet.is-4-desktop
      ScsCheckbox(label1="対局モード" :records="TheApp.xi.xmode_infos" var_name="xmode_keys")

    .column.is-6-tablet.is-4-desktop
      ScsCheckbox(label1="開始局面" :records="TheApp.xi.imode_infos" var_name="imode_keys")

    .column.is-6-tablet.is-4-desktop
      ScsCheckbox(label1="勝敗"       :records="TheApp.xi.judge_infos"  var_name="judge_keys")

    .column.is-6-tablet.is-4-desktop
      ScsCheckbox(label1="結末"       :records="TheApp.xi.final_infos"  var_name="final_keys")

    .column.is-6-tablet.is-4-desktop
      ScsCheckbox(label1="先後"       :records="TheApp.xi.location_infos"  var_name="location_keys" last_only_if_full)

    .column.is-6-tablet.is-4-desktop
      ScsCheckbox(label1="相手の棋力" :records="TheApp.xi.grade_infos" var_name="grade_keys")

    .column.is-6-tablet.is-4-desktop
      ScsInputNumber(label="力差" xxx_enabled_var="grade_diff_enabled"    xxx_value_var="grade_diff"    xxx_compare_var="grade_diff_compare" :min="-9" :max="9" :message="TheApp.grade_diff_message")

    .column.is-6-tablet.is-4-desktop
      ScsCheckbox(label1="垢BAN" :records="TheApp.xi.ban_infos" var_name="ban_keys" last_only_if_full)

    .column.is-6-tablet.is-4-desktop
      ScsInputTag(label="自分タグ" tags_var="my_tag_values" op_var="my_tag_values_op")

    .column.is-6-tablet.is-4-desktop
      ScsInputTag(label="相手タグ" tags_var="vs_tag_values" op_var="vs_tag_values_op")

    .column.is-6-tablet.is-4-desktop
      ScsCheckbox(label1="自分の棋風" :records="TheApp.xi.style_infos" var_name="my_style_keys")

    .column.is-6-tablet.is-4-desktop
      ScsCheckbox(label1="相手の棋風" :records="TheApp.xi.style_infos" var_name="vs_style_keys")

    .column.is-6-tablet.is-4-desktop
      ScsInputNumber(label="手数" xxx_enabled_var="turn_max_enabled"      xxx_value_var="turn_max"      xxx_compare_var="turn_max_compare")

    .column.is-6-tablet.is-4-desktop
      ScsInputNumber(label="中盤" xxx_enabled_var="outbreak_turn_enabled" xxx_value_var="outbreak_turn" xxx_compare_var="outbreak_turn_compare")

    .column.is-6-tablet.is-4-desktop
      ScsInputNumber(label="開戦" xxx_enabled_var="critical_turn_enabled" xxx_value_var="critical_turn" xxx_compare_var="critical_turn_compare")

    .column.is-6-tablet.is-4-desktop
      ScsCheckbox(label1="手合割"     :records="TheApp.xi.preset_infos"  var_name="preset_keys")

    .column.is-6-tablet.is-4-desktop(v-if="staff_p || true")
       ScsInputDate()

    .column.is-6-tablet.is-4-desktop
      ScsInputVsUserKeys()

    .column.is-6-tablet.is-4-desktop
      ScsInputNumber(label="最大思考" xxx_enabled_var="my_think_max_enabled"      xxx_value_var="my_think_max"      xxx_compare_var="my_think_max_compare" :min="0" :max="60*10" :message="TheApp.scs_time_format(TheApp.my_think_max)")

    .column.is-6-tablet.is-4-desktop
      ScsInputNumber(label="平均思考" xxx_enabled_var="my_think_avg_enabled"      xxx_value_var="my_think_avg"      xxx_compare_var="my_think_avg_compare" :min="0" :max="60*10" :message="TheApp.scs_time_format(TheApp.my_think_avg)")

    .column.is-6-tablet.is-4-desktop
      ScsInputNumber(label="最終思考" xxx_enabled_var="my_think_last_enabled"      xxx_value_var="my_think_last"      xxx_compare_var="my_think_last_compare" :min="0" :max="60*10" :message="TheApp.scs_time_format(TheApp.my_think_last)")

    .column.is-6-tablet.is-4-desktop(v-if="staff_p")
      ScsInputNumber(label="棋神波形数" xxx_enabled_var="my_ai_wave_count_enabled"      xxx_value_var="my_ai_wave_count"      xxx_compare_var="my_ai_wave_count_compare" :min="0" :max="60*10" :message="TheApp.scs_time_format(TheApp.my_ai_wave_count)")

    .column.is-6-tablet.is-4-desktop(v-if="staff_p")
      ScsInputNumber(label="棋神を模倣した指し手の数" xxx_enabled_var="my_ai_drop_total_enabled"      xxx_value_var="my_ai_drop_total"      xxx_compare_var="my_ai_drop_total_compare" :min="0" :max="100")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsCustomSearchFormAll",
  mixins: [support_child],
  props: {
    new_query_field_show: { type: Boolean, required: false, default: true, },
    user_key_field_show:  { type: Boolean, required: false, default: true, },
  },
  computed: {},
}
</script>

<style lang="sass">
@import "./support.sass"
.SwarsCustomSearchFormAll
  +bulma_columns_vertical_minus_margin_clear

  .field_block
    &:hover
      +desktop
        background-color: $primary-light

  .new_query_field
    position: sticky
    top: 0
    z-index: 10 /* 適当 */
    background-color: $white
    padding-top: 1.2rem
    padding-bottom: 1.2rem
    &:hover
      background-color: unset
    input, textarea
      border: 0
      background-color: $primary-light

  +mobile
    .field_block
      padding: 0.5rem 0
    .new_query_field
      padding: 0.5rem 0

.STAGE-development-x
  .SwarsCustomSearchFormAll
    .columns
      .column
        border: 1px dashed change_color($primary, $alpha: 0.5)
        background-color: change_color($danger, $alpha: 0.1)
    .field_block
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
