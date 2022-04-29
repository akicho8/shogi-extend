<template lang="pug">
.SwarsCustomSearchApp
  DebugBox(v-if="development_p")
    p user_key: {{user_key}}
    p vs_user_keys: {{vs_user_keys}}

  MainNavbar(wrapper-class="container is-fluid")
    template(slot="brand")
      b-navbar-item(@click="base.back_handle")
        b-icon(icon="chevron-left")
      b-navbar-item.has-text-weight-bold(@click="title_click_handle") カスタム検索

  MainSection
    .container.is-fluid
      .columns.form_block
        .column
          b-field.field_block.new_query_field(label="")
            b-input(v-model.trim="new_query" disabled expanded size="is-medium")
            p.control
              b-button(@click="search_click_handle" type="is-primary" size="is-medium")
                | 検索

          b-field.field_block(label="自分のウォーズID")
            b-input(v-model.trim="user_key" placeholder="itoshinTV")

          SwarsCustomSearchInputVsUserKeys(:base="base")

          SwarsCustomSearchCheckbox(:base="base" label1="相手の棋力" :records="xi.grade_infos" var_name="grade_keys")
          SwarsCustomSearchCheckbox(:base="base" label1="対局モード" :records="xi.xmode_infos" var_name="xmode_keys")
          SwarsCustomSearchCheckbox(:base="base" label1="持ち時間"   :records="xi.rule_infos"  var_name="rule_keys")
          SwarsCustomSearchCheckbox(:base="base" label1="結末"       :records="xi.final_infos"  var_name="final_keys")
          SwarsCustomSearchCheckbox(:base="base" label1="手合割"     :records="xi.preset_infos"  var_name="preset_keys")
          SwarsCustomSearchCheckbox(:base="base" label1="勝敗"       :records="xi.judge_infos"  var_name="judge_keys")
          SwarsCustomSearchCheckbox(:base="base" label1="先後"       :records="xi.location_infos"  var_name="location_keys" last_only_if_full)

          SwarsCustomSearchInputTag(:base="base" label="自分タグ" tags_var="my_tag_values" op_var="my_tag_values_op")
          SwarsCustomSearchInputTag(:base="base" label="相手タグ" tags_var="vs_tag_values" op_var="vs_tag_values_op")

          SwarsCustomSearchInputNumber(:base="base" label="開戦" xxx_enabled_var="critical_turn_enabled" xxx_value_var="critical_turn" xxx_compare_var="critical_turn_compare")
          SwarsCustomSearchInputNumber(:base="base" label="中盤" xxx_enabled_var="outbreak_turn_enabled" xxx_value_var="outbreak_turn" xxx_compare_var="outbreak_turn_compare")
          SwarsCustomSearchInputNumber(:base="base" label="手数" xxx_enabled_var="turn_max_enabled"      xxx_value_var="turn_max"      xxx_compare_var="turn_max_compare")
          SwarsCustomSearchInputNumber(:base="base" label="力差" xxx_enabled_var="grade_diff_enabled"    xxx_value_var="grade_diff"    xxx_compare_var="grade_diff_compare" :min="-9" :max="9" :message="grade_diff_message")
      SwarsCustomSearchDebugPanels(:base="base" v-if="development_p")
</template>

<script>
import _ from "lodash"

import { support_parent  } from "./support_parent.js"
import { app_chore       } from "./app_chore.js"
import { app_vs_user       } from "./app_vs_user.js"
import { app_search      } from "./app_search.js"
import { app_storage     } from "./app_storage.js"

import { CompareInfo   } from "./models/compare_info.js"
import { LogicalInfo   } from "./models/logical_info.js"

import { ParamInfo   } from "./models/param_info.js"

export default {
  name: "SwarsCustomSearchApp",
  mixins: [
    support_parent,
    app_search,
    app_vs_user,
    app_chore,
    app_storage,
  ],
  props: {
    xi: { type: Object,  required: true, },
  },
  data() {
    return {
    }
  },
  methods: {
    title_click_handle() {
      this.ls_reset()
      this.pc_data_reset()
    },
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

    foobar(key, enabled, compare, turn) {
      if (enabled) {
        return `${key}:${compare.value}${turn}`
      }
    }
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

    LogicalInfo()              { return LogicalInfo                                 },
    CompareInfo()                { return CompareInfo                                   },
    critical_turn_compare_info() { return CompareInfo.fetch(this.critical_turn_compare) },
    outbreak_turn_compare_info() { return CompareInfo.fetch(this.outbreak_turn_compare) },
    turn_max_compare_info()      { return CompareInfo.fetch(this.turn_max_compare)      },
    grade_diff_compare_info()    { return CompareInfo.fetch(this.grade_diff_compare)    },

    new_query() {
      let av = []
      av.push(this.user_key)
      av.push(this.array_to_query("相手の棋力", this.grade_keys))
      av.push(this.array_to_query("対局モード", this.xmode_keys))
      av.push(this.array_to_query("持ち時間", this.rule_keys))
      av.push(this.array_to_query("結末", this.final_keys))
      av.push(this.array_to_query("手合割", this.preset_keys))
      av.push(this.array_to_query("勝敗", this.judge_keys))
      av.push(this.array_to_query("棋力", this.grade_keys))
      av.push(this.array_to_query("先後", this.location_keys))
      av.push(this.array_to_query("vs", this.vs_user_keys))
      av.push(this.array_to_query(this.LogicalInfo.fetch(this.my_tag_values_op).search_key, this.my_tag_values))
      av.push(this.array_to_query("vs-" + this.LogicalInfo.fetch(this.vs_tag_values_op).search_key, this.vs_tag_values))
      av.push(this.foobar("開戦", this.critical_turn_enabled, this.critical_turn_compare_info, this.critical_turn))
      av.push(this.foobar("中盤", this.outbreak_turn_enabled, this.outbreak_turn_compare_info, this.outbreak_turn))
      av.push(this.foobar("手数", this.turn_max_enabled, this.turn_max_compare_info, this.turn_max))
      av.push(this.foobar("力差", this.grade_diff_enabled, this.grade_diff_compare_info, this.grade_diff))
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
        s = "相手は自分と同じ力"
      }
      return s
    },
  },
}
</script>

<style lang="sass">
.SwarsCustomSearchApp
  .MainSection.section
    +tablet
      padding: 1.75rem 0rem

  .container
    +mobile
      padding: 0

  .field_block
    &:hover
      background-color: $primary-light

  .new_query_field
    position: sticky
    top: 0px
    z-index: 10
    background-color: $white
    padding: 1.2rem 0
    &:hover
      background-color: unset

.STAGE-development
  .SwarsCustomSearchApp
    .column
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .field_block
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
