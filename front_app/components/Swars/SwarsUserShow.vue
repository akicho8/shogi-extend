<template lang="pug">
//- info を更新(最大100件タップ)したときに円が更新されるようにするために key が必要
.SwarsUserShow(v-if="!$fetchState.pending" :key="info.key")
  // 自分で閉じるボタン設置。組み込みのはもともとフルスクリーンを考慮しておらず、白地に白いボタンで見えないため。
  .delete.page_delete.is-large(@click="delete_click_handle")

  b-dropdown.top_right_menu(position="is-bottom-left")
    b-icon.has-text-grey-light(slot="trigger" icon="dots-vertical")

    b-dropdown-item(@click="update_handle({try_fetch: true})")
      b-icon(icon="sync" size="is-small")
      | 更新

    b-dropdown-item(@click="update_handle({sample_max: 0})" v-if="development_p")
      b-icon(icon="arrow-up-bold" size="is-small")
      | 最大0件

    b-dropdown-item(@click="update_handle({sample_max: 1})" v-if="development_p")
      b-icon(icon="arrow-up-bold" size="is-small")
      | 最大1件

    b-dropdown-item(@click="update_handle({sample_max: 100})")
      b-icon(icon="arrow-up-bold" size="is-small")
      | 最大100件

    b-dropdown-item(@click="update_handle({sample_max: 200})")
      b-icon(icon="arrow-up-bold" size="is-small")
      | 最大200件

    b-dropdown-item(:href="`/w?query=${info.user.key}`")
      b-icon(icon="magnify" size="is-small")
      | 棋譜検索

    b-dropdown-item(separator)

    b-dropdown-item(:href="`https://twitter.com/search?q=将棋 ${info.user.key}`")
      b-icon(icon="twitter" size="is-small" type="is-info")
      | Twitter検索

    b-dropdown-item(:href="`https://shogiwars.heroz.jp/users/mypage/${info.user.key}`")
      b-icon(icon="link" size="is-small")
      | ウォーズ

    b-dropdown-item(:href="`https://www.google.co.jp/search?q=${info.user.key}`")
      b-icon(icon="google" size="is-small")
      | ぐぐる

  .top_container
    ////////////////////////////////////////////////////////////////////////////////
    // 名前
    .user_key.has-text-weight-bold.has-text-centered
      | {{info.user.key}}
    // 段級位
    .is-flex.rule_container
      .rule_one(v-for="(row, key) in info.rules_hash")
        span.rule_name.is-size-7.has-text-grey
          | {{row.rule_name}}
        span.grade_name.is-size-5
          template(v-if="row.grade_name")
            | {{row.grade_name}}
          template(v-else)
            span.has-text-grey-lighter
              | ？

    ////////////////////////////////////////////////////////////////////////////////
    WinLoseCircle(:info="info")

    ////////////////////////////////////////////////////////////////////////////////
    .ox_container.has-text-centered.is_line_break_on
      template(v-for="judge_key in info.judge_keys")
        span.has-text-danger(v-if="judge_key === 'win'")
          b-icon(icon="checkbox-blank-circle" size="is-small" type="is-danger")
        span.has-text-success(v-if="judge_key === 'lose'")
          b-icon(icon="close" size="is-small" type="is-success")

    .medal_container.has-text-centered.has-text-weight-bold(v-if="info.medal_list.length >= 1")
      template(v-for="(row, i) in info.medal_list")
        template(v-if="row.method === 'tag'")
          b-tag(:key="`medal_list/${i}`" :type="row.type" rounded) {{row.name}}
        template(v-else-if="row.method === 'raw'")
          span.raw(:key="`medal_list/${i}`") {{row.name}}
        template(v-else-if="row.method === 'icon'")
          template(v-if="row.tag_wrap")
            b-tag(:key="`medal_list/${i}`" :type="row.tag_wrap.type" rounded)
              b-icon(:key="`medal_list/${i}`" :icon="row.name" :type="row.type" size="is-small")
          template(v-else)
            b-icon(:key="`medal_list/${i}`" :icon="row.name" :type="row.type" size="is-small")

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  b-tabs(type="is-toggle" size="is-small" v-model="tab_index" position="is-centered")
    //- TODO: key を指定する
    b-tab-item(label="日付")
    b-tab-item(label="段級")
    b-tab-item(label="戦法")
    b-tab-item(label="対抗")

  .tab_content
    template(v-if="tab_index === 0")
      .box.one_box.two_column.is_clickable(v-for="(row, i) in info.every_day_list" :key="`every_day_list/${i}`" @click="every_day_click_handle(row)")
        .columns.is-mobile
          .column.is-paddingless
            .one_box_title.has-text-weight-bold.is-size-5
              | {{date_to_custom_format(row.battled_on) + " "}}
              span(:class="battled_on_to_class(row)")
                | {{date_to_wday(row.battled_on)}}
        .columns.is-mobile
          .column.is-paddingless
            WinLoseCircle(:info="row" size="is-small" narrowed)
          .column.is-paddingless.is-flex
            template(v-for="tag in row.all_tags")
              .tag_wrapper.is_clickable.has-text-weight-bold.is-size-5(@click.stop="tactic_show_modal(tag.name)")
                | {{tag.name}}

              //- b-taglist.tag_wrapper(attached @click.native="tactic_modal_start(tag)")
              //-   b-tag(type="is-light" size="is-medium")
              //-     | {{tag.name}}
              //-   template(v-if="tag.count >= 2")
              //-     b-tag(type="is-primary")
              //-       | {{tag.count}}

    template(v-if="tab_index === 1")
      .box.one_box.is_clickable(v-for="(row, i) in info.every_grade_list" :key="`every_grade_list/${i}`" @click="every_grade_click_handle(row)")
        .columns.is-mobile
          .column.is-three-quarters.is-paddingless
            .one_box_title
              span.has-text-weight-bold.is-size-6.vs_mark.has-text-grey-light
                | vs
              span.has-text-weight-bold.is-size-5.vs_name
                | {{row.grade_name}}
          .column.is-paddingless
            .has-text-right
              span.has-text-grey-light.is-size-7.use_rate_label
                | 遭遇率
              span.use_rate
                | {{float_to_perc(row.appear_ratio, 1)}}
              span.has-text-grey-light.is-size-7.use_rate_unit
                | %
        .columns
          .column.is-paddingless
            WinLoseCircle(:info="row" size="is-small")
    template(v-if="tab_index === 2")
      .box.one_box.is_clickable(v-for="(row, i) in info.every_my_attack_list" :key="`every_my_attack_list/${i}`" @click="every_my_attack_click_handle(row)")
        .columns.is-mobile
          .column.is-three-quarters.is-paddingless
            .one_box_title.has-text-weight-bold.is-size-5
              | {{row.tag.name}}
          .column.is-paddingless
            .has-text-right
              span.has-text-grey-light.is-size-7.use_rate_label
                | 使用率
              span.use_rate
                | {{float_to_perc(row.appear_ratio, 1)}}
              span.has-text-grey-light.is-size-7.use_rate_unit
                | %
        .columns
          .column.is-paddingless
            WinLoseCircle(:info="row" size="is-small")

    template(v-if="tab_index === 3")
      .box.one_box.is_clickable(v-for="(row, i) in info.every_vs_attack_list" :key="`every_vs_attack_list/${i}`" @click="every_vs_attack_click_handle(row)")
        .columns.is-mobile
          .column.is-three-quarters.is-paddingless
            .one_box_title
              span.has-text-weight-bold.is-size-6.vs_mark.has-text-grey-light
                | vs
              span.has-text-weight-bold.is-size-5.vs_name
                | {{row.tag.name}}
          .column.is-paddingless
            .has-text-right
              span.has-text-grey-light.is-size-7.use_rate_label
                | 遭遇率
              span.use_rate
                | {{float_to_perc(row.appear_ratio, 1)}}
              span.has-text-grey-light.is-size-7.use_rate_unit
                | %
        .columns
          .column.is-paddingless
            WinLoseCircle(:info="row" size="is-small")
</template>

<script>
import ls_support from "./ls_support.js"

export default {
  name: "SwarsUserShow",

  mixins: [ls_support],

  props: {
    // info: { required: true },
  },

  data() {
    return {
      info: null,
      tab_index: null,
    }
  },

  watch: {
    "$route.query.sample_max": "$fetch",
    "$route.query.query":      "$fetch",
    "$route.query.try_fetch":  "$fetch",

    tab_index(v) {
      if (this.info) {
        this.$router.replace({name: "swars-users-key", params: {key: this.info.user.key}, query: {tab_index: this.tab_index}})
      }
    },
  },

  async fetch() {
    // alert("fetch")
    // console.log(this.$route.query)
    // http://0.0.0.0:3000/w.json?query=devuser1&format_type=user
    // http://0.0.0.0:4000/swars/users/devuser1
    this.info = await this.$axios.$get("/w.json", {params: {query: this.$route.params.key, format_type: "user", ...this.$route.query}})
  },


  created() {
    if ("tab_index" in this.$route.query) {
      this.tab_index = parseInt(this.$route.query.tab_index)
    }
  },

  methods: {
    swars_search_jump(queries) {
      const query = [
        this.info.user.key,
        `sample:${this.info.sample_max}`, // 検索用のlimit
        ...queries,
      ].join(" ")

      this.$router.push({name: "swars-search", query: {query: query}})
    },

    every_day_click_handle(row) {
      this.swars_search_jump([`date:${this.date_to_ymd(row.battled_on)}`])
    },

    every_my_attack_click_handle(row) {
      this.swars_search_jump([`tag:${row.tag.name}`])
    },

    every_vs_attack_click_handle(row) {
      this.swars_search_jump([`vs-tag:${row.tag.name}`])
    },

    every_grade_click_handle(row) {
      this.swars_search_jump([`vs-grade:${row.grade_name}`])
    },

    update_handle(options = {}) {
      this.$router.replace({name: "swars-users-key", params: {key: this.info.user.key}, query: {tab_index: this.tab_index, ...options}})
    },

    delete_click_handle() {
      this.$router.go(-1)
    },

    battled_on_to_class(row) {
      if (row.day_type) {
        return `has-text-${row.day_type}`
      }
    },
  },

  computed: {
    ls_default() {
      return {
        tab_index: 0, // 初期値
      }
    },
  },
}
</script>

<style lang="sass">
.SwarsUserShow
  .delete.page_delete
    position: absolute
    top: 0.6rem
    left: 0.6rem

  .top_right_menu
    position: absolute
    top: 0.9rem
    right: 0.75rem
    .dropdown-trigger
      cursor: pointer
    .dropdown-item
      .icon
        margin-right: 0.5rem

  .top_container
    padding-bottom: 0.2rem // アイコンの下の隙間
    border-bottom: 1px solid $grey-lighter

    .user_key
    .rule_container
      justify-content: center
      // 一つのルール
      .rule_one
        margin: 0 0.5rem
        font-weight: bold
        .rule_name
        .grade_name
          margin-left: 0.2rem

    .WinLoseCircle
      margin-top: 1rem

    .ox_container
      font-size: 0.8rem
      margin-top: 0.5rem

    .medal_container
      margin-top: 0.1rem
      > .tag                // .tag > .icon の場合もあるため最初の .tag だけに適用
        margin: auto 0.1rem
      > .raw
        position: relative
        bottom: -0.1rem     // 絵文字は大きいので若干下げる
        margin: auto 0.1rem
      > .icon
        position: relative
        bottom: -0.152rem
        margin: auto 0.1rem

  ////////////////////////////////////////////////////////////////////////////////

  .b-tabs, .tab-content
    padding: 0

  .b-tabs
    margin-top: 1rem

  ////////////////////////////////////////////////////////////////////////////////

  .tab_content
    margin-top: -0.3rem

    .one_box
      margin: 1rem 0.5rem
      padding: 1.5rem
      .vs_mark
      .vs_name
        margin-left: 0.5rem
      .use_rate_label
        vertical-align: 5%
      .use_rate
        margin-left: 0.4rem
      .use_rate_unit
        margin-left: 0.2rem
        vertical-align: 5%
      &.two_column
        .WinLoseCircle
          margin-top: 0.25rem
      +desktop
        margin-left: auto
        margin-right: auto
        max-width: 28rem
      .is-flex
        flex-direction: column
        justify-content: center
        align-items: center
        .tag_wrapper
          margin: 0rem

        // flex-wrap: wrap
        // justify-content: flex-start
        // align-content: space-around
        // align-items: center
        // .buttons

        // align-items: center
        // display: flex
        // flex-wrap: wrap
        // justify-content: flex-start

        // .tag_wrapper
        //   margin-bottom: 0.5rem
        //   margin-right: 0.5rem

      // b-taglist は本来 "棒銀 棒金" のようなタグの並びを折り返すためにある
      // しかし "棒銀[2]" のように数字をくっつける場合にも(不適切な形でbuefyの本家が)使っている
      // そのため幅が狭いと "棒銀[2]" の数字が改行してしまう場合がある
      // その対策
      .tag_wrapper
        flex-wrap: nowrap
</style>
