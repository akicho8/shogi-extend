<template lang="pug">
.SwarsCustomSearchApp
  //- b-loading(:active="$fetchState.pending")

  DebugBox(v-if="development_p")
    //- p mounted_then_query_present_p: {{mounted_then_query_present_p}}

  //- SwarsCustomSearchSidebar(:base="base")

  MainNavbar(wrapper-class="container is-fluid")
    template(slot="brand")
      b-navbar-item(@click="base.back_handle")
        b-icon(icon="chevron-left")
        //- b-navbar-item(tag="nuxt-link" :to="{}" @click.native="reset_handle")
      b-navbar-item.has-text-weight-bold カスタム検索
    //- template(slot="end")
    //-   NavbarItemLogin
    //-   NavbarItemProfileLink
    //-   //- NavbarItemSidebarOpen(@click="sidebar_toggle")

  MainSection
    .container.is-fluid
      .columns.form_block
        .column
          b-field.field_block.new_query_field(label="")
            //- p.control
            //-   span.button.is-static.is-fullwidth
            //-     | {{new_query}}
            b-input(v-model.trim="new_query" disabled expanded size="is-medium")
            p.control
              b-button(@click="search_click_handle" type="is-primary" size="is-medium")
                | 検索

          b-field.field_block(label="ウォーズID")
            b-input(v-model.trim="user_key" required placeholder="itoshinTV")

          SwarsCustomSearchCheckbox(:base="base" label1="相手の棋力" :records="xi.grade_infos" var_name="grade_keys")
          SwarsCustomSearchCheckbox(:base="base" label1="対局モード" :records="xi.xmode_infos" var_name="xmode_keys")
          SwarsCustomSearchCheckbox(:base="base" label1="持ち時間"   :records="xi.rule_infos"  var_name="rule_keys")
          SwarsCustomSearchCheckbox(:base="base" label1="結末"       :records="xi.final_infos"  var_name="final_keys")
          SwarsCustomSearchCheckbox(:base="base" label1="手合割"     :records="xi.preset_infos"  var_name="preset_keys")
          SwarsCustomSearchCheckbox(:base="base" label1="勝敗"       :records="xi.judge_infos"  var_name="judge_keys")
          SwarsCustomSearchCheckbox(:base="base" label1="先後"       :records="xi.location_infos"  var_name="location_keys" last_only_if_full)

          //- SimpleRadioButtons.field_block(:base="base" model_name="ChoiceXmodeInfo" var_name="xmode_key")
          //- SimpleRadioButtons.field_block(:base="base" model_name="ChoiceJudgeInfo" var_name="judge_key")
          //- SimpleRadioButtons.field_block(:base="base" model_name="ChoiceFinalInfo" var_name="final_key")
          //- SimpleRadioButtons.field_block(:base="base" model_name="ChoicePresetInfo" var_name="preset_key")
          //- SimpleRadioButtons.field_block(:base="base" model_name="ChoiceRuleInfo" var_name="rule_key")

          SwarsCustomSearchTagInput(:base="base" label="自分タグ" tags_var="my_tag_values" op_var="my_tag_values_op")
          SwarsCustomSearchTagInput(:base="base" label="相手タグ" tags_var="vs_tag_values" op_var="vs_tag_values_op")

          //- SwarsCustomSearchTagInput(:base="base" label1="自分側 AND タグ" label2="自分側ですべて含む" var_name="my_tag_values"    )
          //- SwarsCustomSearchTagInput(:base="base" label1="自分側 OR タグ"  label2="自分側でどれか含む" var_name="or_tag_values"     )
          //- SwarsCustomSearchTagInput(:base="base" label1="相手側 AND タグ" label2="相手側ですべて含む" var_name="vs_my_tag_values" )
          //- SwarsCustomSearchTagInput(:base="base" label1="相手側 OR タグ"  label2="相手側でどれか含む" var_name="vs_or_tag_values"  )

          //- // ネイティブなselectは選択中の項目が選択された状態で開くため使いやすい
          //- template(v-if="development_p")
          //-   b-field.field_block(label="相手の棋力" v-if="xi")
          //-     b-select(v-model="grade_keys" multiple @input="sound_play_click()")
          //-       option(v-for="e in xi.grade_infos" :value="e.key") {{e.short_name}}
          //-
          //-     //- // https://buefy.org/documentation/dropdown/
          //-     //- b-dropdown.dropdown_menu(position="is-bottom-left" hoverable)
          //-     //-   b-icon.has-text-grey-light.is_clickable(slot="trigger" icon="dots-vertical")
          //-     //-     b-dropdown-item(@click="func1_handle") クリックに反応
          //-     //-     b-dropdown-item(separator)
          //-     //-       b-dropdown-item(:href="xx_url") Aタグとして飛ぶ
          //-     //-       b-dropdown-item アイコンつき
          //-     //-       b-icon(icon="arrow-up-bold" size="is-small")
          //-     //-         | 最大200件
          //-
          //- //- 使いづらい
          //- template(v-if="development_p")
          //-   b-field.field_block(label="相手の棋力" v-if="xi")
          //-     .control
          //-       b-dropdown(v-model="grade_keys" @active-change="e => e && sound_play_click()")
          //-         template(#trigger)
          //-           b-button(label="foo" icon-right="menu-down")
          //-         template(v-for="e in xi.grade_infos")
          //-           b-dropdown-item(:value="e" @click="sound_play_click()") {{e}}

          SwarsCustomSearchTagInput2(:base="base" label="開戦" xxx_enabled_var="critical_turn_enabled" xxx_value_var="critical_turn" xxx_compare_var="critical_turn_compare")
          SwarsCustomSearchTagInput2(:base="base" label="中盤" xxx_enabled_var="outbreak_turn_enabled" xxx_value_var="outbreak_turn" xxx_compare_var="outbreak_turn_compare")
          SwarsCustomSearchTagInput2(:base="base" label="手数" xxx_enabled_var="turn_max_enabled"      xxx_value_var="turn_max"      xxx_compare_var="turn_max_compare")
          SwarsCustomSearchTagInput2(:base="base" label="力差" xxx_enabled_var="grade_diff_enabled"    xxx_value_var="grade_diff"    xxx_compare_var="grade_diff_compare" :min="-9" :max="9" :message="grade_diff_message")

          //- b-field.field_block(label="開戦")
          //-   b-switch(v-model="critical_turn_enabled" @input="sound_play_toggle")
          //-   b-numberinput(controls-position="compact" expanded v-model="critical_turn" :min="0" :max="200" :exponential="true" @input="sound_play_click()" :disabled="!critical_turn_enabled")
          //-   b-select(v-model="critical_turn_compare" @input="sound_play_click()" :disabled="!critical_turn_enabled")
          //-     option(v-for="e in CompareInfo.values" :value="e.key") {{e.name}}
          //-
          //- b-field.field_block(label="中盤")
          //-   b-switch(v-model="outbreak_turn_enabled" @input="sound_play_toggle")
          //-   b-numberinput(controls-position="compact" expanded v-model="outbreak_turn" :min="0" :max="200" :exponential="true" @input="sound_play_click()" :disabled="!outbreak_turn_enabled")
          //-   b-select(v-model="outbreak_turn_compare" @input="sound_play_click()" :disabled="!outbreak_turn_enabled")
          //-     option(v-for="e in CompareInfo.values" :value="e.key") {{e.name}}
          //-
          //- b-field.field_block(label="手数")
          //-   b-switch(v-model="turn_max_enabled" @input="sound_play_toggle")
          //-   b-numberinput(controls-position="compact" expanded v-model="turn_max" :min="0" :max="200" :exponential="true" @input="sound_play_click()" :disabled="!turn_max_enabled")
          //-   b-select(v-model="turn_max_compare" @input="sound_play_click()" :disabled="!turn_max_enabled")
          //-     option(v-for="e in CompareInfo.values" :value="e.key") {{e.name}}
          //-
          //- b-field.field_block(label="力差")
          //-   b-switch(v-model="grade_diff_enabled" @input="sound_play_toggle")
          //-   b-numberinput(controls-position="compact" expanded v-model="grade_diff" :min="-9" :max="9" :exponential="true" @input="sound_play_click()" :disabled="!grade_diff_enabled")
          //-   b-select(v-model="grade_diff_compare" @input="sound_play_click()" :disabled="!grade_diff_enabled")
          //-     option(v-for="e in CompareInfo.values" :value="e.key") {{e.name}}

          //- b-field
          //-   b-autocomplete#query(

          //- b-field
          //-   b-autocomplete#query(
          //-     max-height="50vh"
          //-     size="is-medium"
          //-     v-model.trim="query"
          //-     :data="search_input_complement_list"
          //-     type="search"
          //-     placeholder="ウォーズIDを入力"
          //-     open-on-focus
          //-     clearable
          //-     expanded
          //-     @select="search_select_handle"
          //-     @keydown.native.enter="search_enter_handle"
          //-     ref="main_search_form"
          //-     )
          //-   p.control
          //-     b-button.search_click_handle(@click="search_click_handle" icon-left="magnify" size="is-medium")

          //- SwarsCustomSearchBoard(:base="base" v-if="layout_info.key === 'is_layout_board'")
          //- SwarsCustomSearchTable(:base="base" v-if="layout_info.key === 'is_layout_table'")
      SwarsCustomSearchDebugPanels(:base="base" v-if="development_p")
</template>

<script>
import _ from "lodash"

import { support_parent  } from "./support_parent.js"
import { app_chore       } from "./app_chore.js"
import { app_search      } from "./app_search.js"
import { app_storage     } from "./app_storage.js"

// import { ChoiceXmodeInfo } from "./models/choice_xmode_info.js"
// import { ChoiceJudgeInfo } from "./models/choice_judge_info.js"
// import { ChoiceFinalInfo } from "./models/choice_final_info.js"
// import { ChoicePresetInfo } from "./models/choice_preset_info.js"
// import { ChoiceRuleInfo } from "./models/choice_rule_info.js"
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
  ],

  props: {
    xi: { type: Object,  required: true, },
  },

  data() {
    return {
      // xi: null,
    }
  },

  // fetchOnServer: false,
  // fetch() {
  //   this.ga_click("カスタム検索")
  //
  //   let params = {
  //     ...this.$route.query,
  //   }
  //
  //   params = this.pc_url_params_clean(params)
  //
  //   return this.$axios.$get("/api/swars/custom_search_setup.json", {params}).then(xi => {
  //     this.xi = xi
  //     this.filtered_tags_rebuild("")  //
  //   })
  // },

  methods: {
    search_click_handle() {
      this.sound_play_click()
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
      let v = null
      if (this.grade_diff > 0) {
        v = `より${this.grade_diff}段分強い`
      } else if (this.grade_diff < 0) {
        v = `より${-this.grade_diff}段分弱い`
      } else {
        v = "と同じ棋力"
      }
      return `相手が自分${v} (${this.grade_diff_compare_info.name})`
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
