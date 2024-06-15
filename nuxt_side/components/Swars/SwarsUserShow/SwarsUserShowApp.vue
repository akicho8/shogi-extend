<template lang="pug">
.SwarsUserShowApp
  client-only
    DebugBox(v-if="development_p")
      p tab_index: {{$gs.pretty_inspect(tab_index)}}
      p sample_max: {{$gs.pretty_inspect(sample_max)}}
      p query.tab_index: {{$gs.pretty_inspect($route.query.tab_index)}}
      p query.sample_max: {{$gs.pretty_inspect($route.query.sample_max)}}

    b-loading(:active="$fetchState.pending")
    //- info を更新(最大100件タップ)したときに円が更新されるようにするために key が必要
    .MainContainer(v-if="!$fetchState.pending && !$fetchState.error" :key="info.onetime_key")
      PageCloseButton(@click="back_handle" position="is_absolute")
      SwarsUserShowDropdownMenu
      SwarsUserShowHead
      b-tabs(type="is-toggle" size="is-small" v-model="tab_index" position="is-centered" :animated="false" @input="$sound.play_click()" @click.native="tab_item_click_handle($event)")
        b-tab-item(label="日付")
        b-tab-item(label="段級")
        b-tab-item(label="戦法")
        b-tab-item(label="対攻")
        b-tab-item(label="囲い")
        b-tab-item(label="対囲")
        b-tab-item(label="手筋")
        b-tab-item(label="対筋")
        b-tab-item(label="他")
        b-tab-item(label="備考" v-if="info.my_note_items")
        b-tab-item(label="対備" v-if="info.vs_note_items")
      SwarsUserShowTabContent0Day
      SwarsUserShowTabContent1Grade
      SwarsUserShowTabContentPart(:tab_index="2"  var_name="my_attack_items"    :vs_mode="false")
      SwarsUserShowTabContentPart(:tab_index="3"  var_name="vs_attack_items"    :vs_mode="true")
      SwarsUserShowTabContentPart(:tab_index="4"  var_name="my_defense_items"   :vs_mode="false")
      SwarsUserShowTabContentPart(:tab_index="5"  var_name="vs_defense_items"   :vs_mode="true")
      SwarsUserShowTabContentPart(:tab_index="6"  var_name="my_technique_items" :vs_mode="false")
      SwarsUserShowTabContentPart(:tab_index="7"  var_name="vs_technique_items" :vs_mode="true")
      SwarsUserShowTabContent8Etc
      SwarsUserShowTabContentPart(:tab_index="9"  var_name="my_note_items"      :vs_mode="false")
      SwarsUserShowTabContentPart(:tab_index="10" var_name="vs_note_items"      :vs_mode="true")
    SwarsUserShowFooter

    DebugPre(v-if="development_p") {{$route.query.info}}
</template>

<script>
import { support_parent   } from "./support_parent.js"
import { mod_storage      } from "./mod_storage.js"
import { mod_search       } from "./mod_search.js"
import { mod_chore        } from "./mod_chore.js"
import { mod_filter_modal    } from "./mod_filter_modal.js"

import { RuleSelectInfo   } from "./models/rule_select_info.js"
import { SampleMaxInfo    } from "./models/sample_max_info.js"
import { XmodeSelectInfo  } from "./models/xmode_select_info.js"
import { ParamInfo } from "./models/param_info.js"

import _ from "lodash"

export default {
  name: "SwarsUserShowApp",
  mixins: [
    support_parent,
    mod_storage,
    mod_search,
    mod_chore,
    mod_filter_modal,
  ],

  provide() {
    return { TheApp: this }
  },

  data() {
    return {
      info: null,
    }
  },

  watch: {
    // tab_index だけは update_handle に渡さないので変更に合わせてURLを書き換える
    tab_index() { this.$router.replace(this.tab_switch_router_params).catch(err => {}) },

    // query が変化したら再度APIからとってくる
    "$route.query.query": "$fetch",
  },

  fetchOnServer: false,
  fetch() {
    return this.$axios.$get("/api/swars/user_stat", {params: this.axios_get_params}).then(e => this.info = e)
  },

  mounted() {
    // this.ga_click("プレイヤー情報")
  },

  methods: {
    // URLを書き換えたことに反応させるのではなく
    // 単に内部変数を書き換えて明示的に fetch する
    update_handle(params = {}) {
      _.each(params, (value, key) => this.$data[key] = value)
      this.$fetch()
    },

    // 検索に戻る
    back_handle() {
      this.name_click_handle()
    },

    // 日付のスタイル
    battled_on_to_css_class(row) {
      if (row.day_type) {
        return `has-text-${row.day_type}`
      }
    },

    // メタキーと一緒にクリックした場合のみ別タブで開く
    tab_item_click_handle(e) {
      if (this.keyboard_meta_p(e)) {
        this.other_window_open(this.tab_switch_router_url)
      }
    },
  },

  computed: {
    ParamInfo()       { return ParamInfo        },
    RuleSelectInfo()  { return RuleSelectInfo   },
    SampleMaxInfo()   { return SampleMaxInfo    },
    XmodeSelectInfo() { return XmodeSelectInfo  },

    tab_switch_router_params() { return {query: { ...this.$route.query, tab_index: this.tab_index }} },
    tab_switch_router_url()    { return this.$router.resolve(this.tab_switch_router_params).href  },

    axios_get_params() {
      return {
        user_key: this.$route.params.key, // ウォーズID
        sample_max: this.sample_max,      // localStorage から取得している
        badge_debug: this.badge_debug,
        ...this.$route.query,
      }
    },
  },
}
</script>

<style lang="sass">
.SwarsUserShowApp
  ////////////////////////////////////////////////////////////////////////////////

  .b-tabs, .tab-content
    padding: 0

  .b-tabs
    margin-top: 1rem
    margin-bottom: 0

  ////////////////////////////////////////////////////////////////////////////////

  .boxes
    margin-top: 1rem
    margin-bottom: 3rem

    .one_box
      margin: 0 0.75rem
      &:not(:first-child)
        margin-top: 0.75rem
      padding: 0.75rem

      .vs_mark
        __css_keep__: 0
      .vs_name
        margin-left: 0.5rem

      .one_box_title
        display: flex
        align-items: center
        justify-content: flex-start

        font-weight: bold
        font-size: $size-5

      .use_rate_block
        display: flex
        align-items: center
        justify-content: center
        white-space: nowrap
        font-size: $size-7
        .use_rate_label
          color: $grey-light
        .use_rate_value
          margin: 0 0.25em
        .use_rate_unit
          color: $grey-light

      &.two_column
        .WinLoseCircle
          margin-top: 0.25rem

      +tablet
        margin-left: auto
        margin-right: auto
        max-width: 28rem

      .tactic_name_with_count_blocks
        display: flex
        flex-direction: column
        justify-content: center
        align-items: center

        .tag_wrapper
          color: inherit

          display: flex
          align-items: center
          justify-content: center

          // b-taglist は本来 "棒銀 棒金" のようなタグの並びを折り返すためにある
          // しかし "棒銀[2]" のように数字をくっつける場合にも(不適切な形でbuefyの本家が)使っている
          // そのため幅が狭いと "棒銀[2]" の数字が改行してしまう場合がある
          // その対策
          flex-wrap: nowrap

.STAGE-development
  .SwarsUserShowApp
    .boxes
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
