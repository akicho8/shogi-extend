<template lang="pug">
.SwarsUserShowApp
  b-loading(:active="$fetchState.pending")
  //- info を更新(最大100件タップ)したときに円が更新されるようにするために key が必要
  .MainContainer(v-if="!$fetchState.pending && !$fetchState.error" :key="info.onetime_key")
    PageCloseButton(@click="back_handle" position="is_absolute")
    SwarsUserShowDropdownMenu(:base="base")
    SwarsUserShowHead(:base="base")
    b-tabs(type="is-toggle" size="is-small" v-model="tab_index" position="is-centered" :animated="false" @input="sound_play('click')")
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
    SwarsUserShowTabContent6MetaInfo(:base="base")

  DebugPre(v-if="development_p") {{info}}
</template>

<script>
import { support_parent } from "./support_parent.js"
import { app_storage    } from "./app_storage.js"
import { app_search     } from "./app_search.js"
import { app_support    } from "./app_support.js"
import { RuleSelectInfo  } from "./rule_select_info.js"

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
    // tab_index を除外するため
    "$route.query.rule": "$fetch",
    "$route.query.sample_max": "$fetch",
    "$route.query.query":      "$fetch",
    "$route.query.try_fetch":  "$fetch",

    tab_index(v) {
      if (this.info) {
        this.update_handle({})
      }
    },
  },

  // http://0.0.0.0:4000/swars/users/devuser1
  // http://0.0.0.0:3000/w.json?query=devuser1&format_type=user
  // http://0.0.0.0:3000/w.json?query=foo&format_type=user
  //
  // fetch({error}) とすると $fetchState がつくられなくなる謎の罠あり
  fetch() {
    const params = {
      ...this.$route.query,
      query: this.$route.params.key,
      format_type: "user",
    }
    return this.$axios.$get("/w.json", {params}).then(e => { // FIXME: /api/users.json にする
      this.info = e

      // 1. 以前の tab_index を設定する
      this.ls_setup()

      // 2. 次にリンクの指定があるときは tab_index を上書きする(順序重要)
      if ("tab_index" in this.$route.query) {
        this.tab_index = parseInt(this.$route.query.tab_index)
      }
    })
  },

  mounted() {
    this.ga_click("プレイヤー情報")
  },

  methods: {
    update_handle(options = {}) {
      // https://github.com/vuejs/vue-router/issues/2872
      this.$router.replace({
        name: "swars-users-key",
        params: { key: this.info.user.key },
        query: {
          tab_index: this.tab_index,
          sample_max: this.$route.query.sample_max,
          rule: this.$route.query.rule,
          ...options,
        },
      }).catch(err => {})
    },

    back_handle() {
      this.sound_play("click")
      this.back_to({name: "swars-search", query: {query: this.$route.params.key}})
    },

    battled_on_to_css_class(row) {
      if (row.day_type) {
        return `has-text-${row.day_type}`
      }
    },
  },

  computed: {
    base() { return this },
    RuleSelectInfo() { return RuleSelectInfo },
    current_rule() { return this.$route.query.rule },
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

      +desktop
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
