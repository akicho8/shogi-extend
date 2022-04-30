<template lang="pug">
.SwarsCustomSearchApp
  DebugBox(v-if="development_p")
    p user_key: {{user_key}}
    p vs_user_keys: {{vs_user_keys}}

  SwarsCustomSearchSidebar(:base="base")

  MainNavbar(wrapper-class="container is-fluid")
    template(slot="brand")
      b-navbar-item(@click="base.back_handle")
        b-icon(icon="chevron-left")
      b-navbar-item.has-text-weight-bold(@click="title_click_handle") カスタム検索
    template(slot="end")
      //- NavbarItemLogin
      //- NavbarItemProfileLink
      NavbarItemSidebarOpen(@click="sidebar_toggle")

  MainSection
    .container.is-fluid
      .columns.form_block.is-variable.is-0
        .column.is-12
          b-field.field_block.new_query_field(label="")
            b-input(v-model.trim="new_query" disabled expanded)
            p.control
              b-button(@click="search_click_handle" type="is-primary")
                | 検索
          .columns.form_block.is-multiline.is-variable.is-0-mobile.is-0-tablet.is-0-desktop.is-0-widescreen.is-0-fullhd
            .column.is-6-tablet.is-4-desktop.is-3-widescreen
              b-field.field_block(custom-class="is-small")
                template(#label)
                  | 自分のウォーズID
                  span.mx-2(class="has-text-grey has-text-weight-normal is-italic is-size-7")
                    | 必須
                b-input(size="is-small" v-model.trim="user_key" placeholder="itoshinTV")
            .column.is-6-tablet.is-4-desktop.is-3-widescreen
              SwarsCustomSearchCheckbox(:base="base" label1="持ち時間"   :records="xi.rule_infos"  var_name="rule_keys")
            .column.is-6-tablet.is-4-desktop.is-3-widescreen
              SwarsCustomSearchCheckbox(:base="base" label1="勝敗"       :records="xi.judge_infos"  var_name="judge_keys")
            .column.is-6-tablet.is-4-desktop.is-3-widescreen
              SwarsCustomSearchCheckbox(:base="base" label1="結末"       :records="xi.final_infos"  var_name="final_keys")
            .column.is-6-tablet.is-4-desktop.is-3-widescreen
              SwarsCustomSearchCheckbox(:base="base" label1="先後"       :records="xi.location_infos"  var_name="location_keys" last_only_if_full)
            .column.is-6-tablet.is-4-desktop.is-3-widescreen
              SwarsCustomSearchCheckbox(:base="base" label1="相手の棋力" :records="xi.grade_infos" var_name="grade_keys")
            .column.is-6-tablet.is-4-desktop.is-3-widescreen
              SwarsCustomSearchInputNumber(:base="base" label="力差" xxx_enabled_var="grade_diff_enabled"    xxx_value_var="grade_diff"    xxx_compare_var="grade_diff_compare" :min="-9" :max="9" :message="grade_diff_message")
            .column.is-6-tablet.is-4-desktop.is-3-widescreen
              SwarsCustomSearchCheckbox(:base="base" label1="対局モード" :records="xi.xmode_infos" var_name="xmode_keys")
            .column.is-6-tablet.is-4-desktop.is-3-widescreen
              SwarsCustomSearchCheckbox(:base="base" label1="手合割"     :records="xi.preset_infos"  var_name="preset_keys")
            .column.is-6-tablet.is-4-desktop.is-3-widescreen
              SwarsCustomSearchInputTag(:base="base" label="自分タグ" tags_var="my_tag_values" op_var="my_tag_values_op")
            .column.is-6-tablet.is-4-desktop.is-3-widescreen
              SwarsCustomSearchInputTag(:base="base" label="相手タグ" tags_var="vs_tag_values" op_var="vs_tag_values_op")
            .column.is-6-tablet.is-4-desktop.is-3-widescreen
              SwarsCustomSearchInputNumber(:base="base" label="手数" xxx_enabled_var="turn_max_enabled"      xxx_value_var="turn_max"      xxx_compare_var="turn_max_compare")
            .column.is-6-tablet.is-4-desktop.is-3-widescreen
              SwarsCustomSearchInputNumber(:base="base" label="中盤" xxx_enabled_var="outbreak_turn_enabled" xxx_value_var="outbreak_turn" xxx_compare_var="outbreak_turn_compare")
            .column.is-6-tablet.is-4-desktop.is-3-widescreen
              SwarsCustomSearchInputNumber(:base="base" label="開戦" xxx_enabled_var="critical_turn_enabled" xxx_value_var="critical_turn" xxx_compare_var="critical_turn_compare")
            .column.is-6-tablet.is-4-desktop.is-3-widescreen
              SwarsCustomSearchInputNumber(:base="base" label="最大思考" xxx_enabled_var="my_think_max_enabled"      xxx_value_var="my_think_max"      xxx_compare_var="my_think_max_compare" :min="0" :max="60*10" :message="scs_time_format(my_think_max)")
            .column.is-6-tablet.is-4-desktop.is-3-widescreen
              SwarsCustomSearchInputNumber(:base="base" label="平均思考" xxx_enabled_var="my_think_avg_enabled"      xxx_value_var="my_think_avg"      xxx_compare_var="my_think_avg_compare" :min="0" :max="60*10" :message="scs_time_format(my_think_avg)")
            .column.is-6-tablet.is-4-desktop.is-3-widescreen
              SwarsCustomSearchInputNumber(:base="base" label="最終思考" xxx_enabled_var="my_think_last_enabled"      xxx_value_var="my_think_last"      xxx_compare_var="my_think_last_compare" :min="0" :max="60*10" :message="scs_time_format(my_think_last)")
            .column.is-6-tablet.is-4-desktop.is-3-widescreen(v-if="staff_p")
              SwarsCustomSearchInputNumber(:base="base" label="中盤以降平均思考" xxx_enabled_var="my_mid_think_avg_enabled"      xxx_value_var="my_mid_think_avg"      xxx_compare_var="my_mid_think_avg_compare" :min="0" :max="60*10" :message="scs_time_format(my_mid_think_avg)")
            .column.is-6-tablet.is-4-desktop.is-3-widescreen(v-if="staff_p")
              SwarsCustomSearchInputNumber(:base="base" label="中盤以降最大連続即指し回数" xxx_enabled_var="my_mid_machine_gun_enabled"      xxx_value_var="my_mid_machine_gun"      xxx_compare_var="my_mid_machine_gun_compare" :min="0" :max="100")
            .column.is-6-tablet.is-4-desktop.is-3-widescreen
              SwarsCustomSearchInputVsUserKeys(:base="base")

      SwarsCustomSearchDebugPanels(:base="base" v-if="development_p")
</template>

<script>
import _ from "lodash"

import { support_parent  } from "./support_parent.js"
import { app_chore       } from "./app_chore.js"
import { app_search      } from "./app_search.js"
import { app_storage     } from "./app_storage.js"
import { app_sidebar     } from "./app_sidebar.js"

import { CompareInfo   } from "./models/compare_info.js"
import { LogicalInfo   } from "./models/logical_info.js"

import { ParamInfo   } from "./models/param_info.js"

export default {
  name: "SwarsCustomSearchApp",
  mixins: [
    support_parent,
    app_search,
    app_chore,
    app_storage,
    app_sidebar,
  ],
  props: {
    xi: { type: Object,  required: true, },
  },
  data() {
    return {
    }
  },
  methods: {
    search_click_handle() {
      this.sound_play_click()
      this.remote_notify({subject: "カスタム検索", body: this.new_query})
      this.$router.push({name: "swars-search", query: {query: this.new_query}})
    },

    back_handle() {
      this.sound_play_click()
      this.back_to({name: "swars-search", query: {query: this.user_key}})
    },

    array_to_query(key, values) {
      let v = this.presence(values)
      if (v) {
        return [key, ":", v.join(",")].join("")
      }
    },

    compare_query_build(key, enabled, compare, value) {
      if (enabled) {
        return `${key}:${compare.value}${value}`
      }
    },

    scs_time_format(seconds) {
      return this.time_format_human_hms(seconds)
    },
  },

  computed: {
    base() { return this },

    // ChoiceXmodeInfo()   { return ChoiceXmodeInfo                       },
    // choice_xmode_info() { return ChoiceXmodeInfo.fetch(this.xmode_key) },

    // ChoiceFinalInfo()   { return ChoiceFinalInfo                       },
    // choice_final_info() { return ChoiceFinalInfo.fetch(this.final_key) },
    //
    // ChoicePresetInfo()   { return ChoicePresetInfo                       },
    // choice_preset_info() { return ChoicePresetInfo.fetch(this.preset_key) },
    //
    // ChoiceRuleInfo()   { return ChoiceRuleInfo                       },
    // choice_rule_info() { return ChoiceRuleInfo.fetch(this.rule_key) },

    // ChoiceJudgeInfo()   { return ChoiceJudgeInfo                       },
    // choice_judge_info() { return ChoiceJudgeInfo.fetch(this.judge_key) },

    LogicalInfo()                     { return LogicalInfo                                        },
    CompareInfo()                     { return CompareInfo                                        },
    critical_turn_compare_info()      { return CompareInfo.fetch(this.critical_turn_compare)      },
    outbreak_turn_compare_info()      { return CompareInfo.fetch(this.outbreak_turn_compare)      },
    turn_max_compare_info()           { return CompareInfo.fetch(this.turn_max_compare)           },
    grade_diff_compare_info()         { return CompareInfo.fetch(this.grade_diff_compare)         },
    my_think_max_compare_info()       { return CompareInfo.fetch(this.my_think_max_compare)       },
    my_think_avg_compare_info()       { return CompareInfo.fetch(this.my_think_avg_compare)       },
    my_think_last_compare_info()       { return CompareInfo.fetch(this.my_think_last_compare)       },
    my_mid_think_avg_compare_info()   { return CompareInfo.fetch(this.my_mid_think_avg_compare)   },
    my_mid_machine_gun_compare_info() { return CompareInfo.fetch(this.my_mid_machine_gun_compare) },

    new_query() {
      let av = []

      // フォームと順番を合わせること
      av.push(this.user_key)
      av.push(this.array_to_query("持ち時間", this.rule_keys))
      av.push(this.array_to_query("勝敗", this.judge_keys))
      av.push(this.array_to_query("結末", this.final_keys))
      av.push(this.array_to_query("先後", this.location_keys))
      av.push(this.array_to_query("相手の棋力", this.grade_keys))
      av.push(this.compare_query_build("力差", this.grade_diff_enabled, this.grade_diff_compare_info, this.grade_diff))
      av.push(this.array_to_query("対局モード", this.xmode_keys))
      av.push(this.array_to_query("手合割", this.preset_keys))
      av.push(this.array_to_query(        this.LogicalInfo.fetch(this.my_tag_values_op).search_key, this.my_tag_values))
      av.push(this.array_to_query("vs-" + this.LogicalInfo.fetch(this.vs_tag_values_op).search_key, this.vs_tag_values))
      av.push(this.array_to_query("棋力", this.grade_keys))
      av.push(this.compare_query_build("手数", this.turn_max_enabled, this.turn_max_compare_info, this.turn_max))
      av.push(this.compare_query_build("中盤", this.outbreak_turn_enabled, this.outbreak_turn_compare_info, this.outbreak_turn))
      av.push(this.compare_query_build("開戦", this.critical_turn_enabled, this.critical_turn_compare_info, this.critical_turn))
      av.push(this.compare_query_build("最大思考", this.my_think_max_enabled, this.my_think_max_compare_info, this.my_think_max))
      av.push(this.compare_query_build("平均思考", this.my_think_avg_enabled, this.my_think_avg_compare_info, this.my_think_avg))
      av.push(this.compare_query_build("最終思考", this.my_think_last_enabled, this.my_think_last_compare_info, this.my_think_last))
      av.push(this.compare_query_build("中盤以降平均思考", this.my_mid_think_avg_enabled, this.my_mid_think_avg_compare_info, this.my_mid_think_avg))
      av.push(this.compare_query_build("中盤以降最大連続即指し回数", this.my_machine_gun_enabled, this.my_machine_gun_compare_info, this.my_machine_gun))

      av.push(this.array_to_query("相手", this.vs_user_keys))

      let str = av.join(" ")
      str = this.str_squish(str)
      return str
    },

    grade_diff_message() {
      let v = this.grade_diff
      let x = Math.abs(v)
      let s = ""
      if (v > 0) {
        s = `相手は自分より${this.grade_diff}強い`
      } else if (v < 0) {
        s = `相手は自分より${-this.grade_diff}弱い`
      } else {
        s = "相手は自分と同じぐらい強い"
      }
      return s
    },
  },
}
</script>

<style lang="sass">
.SwarsCustomSearchApp
  +bulma_columns_vertical_minus_margin_clear

  .MainSection.section
    +mobile
      padding: 0rem 0.75rem
    +tablet
      padding: 1.0rem 0rem

  .container
    +mobile
      padding: 0

  .field_block
    &:hover
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

.STAGE-development
  .SwarsCustomSearchApp
    .columns
      .columns
        .column
          border: 1px dashed change_color($primary, $alpha: 0.5)
          background-color: change_color($danger, $alpha: 0.1)
    .field_block
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
