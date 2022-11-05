<template lang="pug">
.SwarsUserShowApp
  client-only
    DebugBox(v-if="development_p")
      p tab_index: {{pretty_inspect(tab_index)}}
      p rule: {{pretty_inspect(rule)}}
      p sample_max: {{pretty_inspect(sample_max)}}
      p xmode: {{pretty_inspect(xmode)}}
      p query.tab_index: {{pretty_inspect($route.query.tab_index)}}
      p query.rule: {{pretty_inspect($route.query.rule)}}
      p query.sample_max: {{pretty_inspect($route.query.sample_max)}}
      p query.xmode: {{pretty_inspect($route.query.xmode)}}

    b-loading(:active="$fetchState.pending")
    //- info を更新(最大100件タップ)したときに円が更新されるようにするために key が必要
    .MainContainer(v-if="!$fetchState.pending && !$fetchState.error" :key="info.onetime_key")
      PageCloseButton(@click="back_handle" position="is_absolute")
      SwarsUserShowDropdownMenu(:base="base")
      SwarsUserShowHead(:base="base")
      b-tabs(type="is-toggle" size="is-small" v-model="tab_index" position="is-centered" :animated="false" @input="$sound.play_click()")
        b-tab-item(label="日付")
        b-tab-item(label="段級")
        b-tab-item(label="戦法")
        b-tab-item(label="対攻")
        b-tab-item(label="囲い")
        b-tab-item(label="対囲")
        b-tab-item(label="他")
      SwarsUserShowTabContent0Day(:base="base")
      SwarsUserShowTabContent1Grade(:base="base")
      SwarsUserShowTabContent2MyAttack(:base="base")
      SwarsUserShowTabContent3VsAttack(:base="base")
      SwarsUserShowTabContent4MyDefense(:base="base")
      SwarsUserShowTabContent5VsDefense(:base="base")
      SwarsUserShowTabContent6Etc(:base="base")

    DebugPre(v-if="development_p") {{$route.query.info}}
</template>

<script>
import { support_parent   } from "./support_parent.js"
import { app_storage      } from "./app_storage.js"
import { app_search       } from "./app_search.js"
import { app_support      } from "./app_support.js"

import { RuleSelectInfo   } from "./models/rule_select_info.js"
import { SampleMaxInfo    } from "./models/sample_max_info.js"
import { XmodeSelectInfo } from "./models/xmode_select_info.js"
import { ParamInfo        } from "./models/param_info.js"

import _ from "lodash"

export default {
  name: "SwarsUserShowApp",
  mixins: [
    support_parent,
    app_storage,
    app_search,
    app_support,
  ],

  data() {
    return {
      info: null,
    }
  },

  watch: {
    // tab_index だけは update_handle に渡さないので変更に合わせてURLを書き換える
    tab_index() {
      this.url_replace()
    },
  },

  // http://localhost:4000/swars/users/DevUser1
  // http://localhost:3000/w.json?query=DevUser1&format_type=user
  // http://localhost:3000/w.json?query=foo&format_type=user
  // fetch({error}) とすると $fetchState がつくられなくなる謎の罠あり
  fetchOnServer: false,
  fetch() {
    return this.$axios.$get("/w.json", {params: this.api_params}).then(e => {
      this.info = e
      this.url_replace() // URLを書き換えてからではなくfetchしたあとでURLを置換する
    })
  },

  mounted() {
    this.ga_click("プレイヤー情報")
  },

  methods: {
    // URLを書き換えたことに反応させるのではなく
    // 単に内部変数を書き換えて明示的に fetch する
    update_handle(params = {}) {
      _.each(params, (value, key) => this.$data[key] = value)
      this.$fetch()
    },

    // URLを書き換えるだけ
    // 絶対に watch してはいけない
    url_replace() {
      this.$router.replace({
        name: "swars-users-key",
        params: this.$route.params,
        query: this.url_params,
      }).catch(err => {})
    },

    // 検索に戻る
    back_handle() {
      this.$sound.play_click()
      this.back_to({name: "swars-search", query: {query: this.$route.params.key}})
    },

    // 日付のスタイル
    battled_on_to_css_class(row) {
      if (row.day_type) {
        return `has-text-${row.day_type}`
      }
    },
  },

  computed: {
    base()            { return this             },
    ParamInfo()       { return ParamInfo        },
    RuleSelectInfo()  { return RuleSelectInfo   },
    SampleMaxInfo()   { return SampleMaxInfo    },
    XmodeSelectInfo() { return XmodeSelectInfo  },

    url_params() {
      return this.hash_compact({
        tab_index:  this.tab_index,
        rule:       this.rule,
        sample_max: this.sample_max,
        xmode:      this.xmode,
      })
    },

    api_params() {
      return {
        ...this.url_params,
        query: this.$route.params.key,
        debug: this.$route.query.debug,
        format_type: "user",
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
