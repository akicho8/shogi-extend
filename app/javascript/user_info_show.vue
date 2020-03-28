<template lang="pug">
.user_info_show.modal-card
  //- .modal-card-head
  //-   .modal-card-title {{membership.user.key}}
  .modal-card-body
    // 自分で閉じるボタン設置。組み込みのはもともとフルスクリーンを考慮しておらず、白地に白いボタンで見えないため。
    .delete.is-large(@click="delete_click_handle")

    b-dropdown.top_right_menu(position="is-bottom-left" v-if="development_p")
      b-icon.has-text-white(slot="trigger" icon="dots-vertical")

      b-dropdown-item(:href="permalink_url")
        b-icon(icon="link-variant" size="is-small")
        | パーマリンク

      b-dropdown-item(:href="`${permalink_url}&debug=true`" v-if="development_p")
        b-icon(icon="link-variant" size="is-small")
        | パーマリンク(DEBUGモード)

      b-dropdown-item(:href="`/w.json?query=${info.user.key}&format_type=user`")
        b-icon(icon="link-variant" size="is-small")
        | json

      b-dropdown-item(:href="`/w.json?query=${info.user.key}&format_type=user&debug=true`" v-if="development_p")
        b-icon(icon="link-variant" size="is-small")
        | json (debug)

      b-dropdown-item.is-paddingless(custom)
        pre
          | {{info.debug_hash}}

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
      win_lose_circle(:info="info")

      ////////////////////////////////////////////////////////////////////////////////
      .ox_container.has-text-centered.line_break_on
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
      b-tab-item(label="日付")
      b-tab-item(label="戦法")
      b-tab-item(label="対抗")

    //- b-field(position="is-centered")
    //-   b-radio-button(v-model="tab_index" native-value="0" size="is-small") 日付
    //-   b-radio-button(v-model="tab_index" native-value="1" size="is-small") 戦法

    .tab_content
      template(v-if="tab_index === 0")
        .box.one_box.two_column(v-for="row in info.every_day_list" :key="`every_day_list/${row.battled_at}`")
          .columns.is-mobile
            .column.is-paddingless
              .one_box_title.has-text-weight-bold.is-size-5
                | {{battled_at_to_ymd(row) + " "}}
                span(:class="battled_at_to_class(row)")
                  | {{battled_at_to_wday(row)}}
          .columns.is-mobile
            .column.is-paddingless
              win_lose_circle(:info="row" size="is-small" narrowed)
            .column.is-paddingless.is-flex
              template(v-for="tag in row.all_tags")
                .tag_wrapper.has-text-weight-bold.is-size-5(@click="tactic_show_modal(tag)")
                  | {{tag.name}}

                //- b-taglist.tag_wrapper(attached @click.native="tactic_modal_start(tag)")
                //-   b-tag(type="is-light" size="is-medium")
                //-     | {{tag.name}}
                //-   template(v-if="tag.count >= 2")
                //-     b-tag(type="is-primary")
                //-       | {{tag.count}}

      template(v-if="tab_index === 1")
        .box.one_box.one_column(v-for="row in info.every_my_attack_list" :key="`every_my_attack_list/${row.tag.name}`")
          .columns.is-mobile
            .column.is-paddingless
              .one_box_title.has-text-weight-bold.is-size-5
                | {{row.tag.name}}
            .column.is-paddingless
              .has-text-right
                span.has-text-grey-light.is-size-7.use_rate_label
                  | 使用率
                span.use_rate
                  | {{number_to_percentage2(row.appear_ratio, 1)}}
                span.has-text-grey-light.is-size-7.use_rate_unit
                  | %
          .columns
            .column.is-paddingless
              win_lose_circle(:info="row" size="is-small")

      template(v-if="tab_index === 2")
        .box.one_box.one_column(v-for="row in info.every_vs_attack_list" :key="`every_vs_attack_list/${row.tag.name}`")
          .columns.is-mobile
            .column.is-paddingless
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
                  | {{number_to_percentage2(row.appear_ratio, 1)}}
                span.has-text-grey-light.is-size-7.use_rate_unit
                  | %
          .columns
            .column.is-paddingless
              win_lose_circle(:info="row" size="is-small")

  template(v-if="development_p")
    //- pre
    //-   | {{info}}
    .modal-card-foot
      b-button(@click="$parent.close()" size="is-small" v-if="false") 閉じる
      b-button(tag="a" :href="permalink_url" size="is-small" icon-left="link-variant") パーマリンク
      b-button(tag="a" :href="`${permalink_url}&debug=true`" size="is-small" icon-left="link-variant") パーマリンク(DEBUGモード)
</template>

<script>
import dayjs from "dayjs"
import "dayjs/locale/ja.js"
dayjs.locale('ja')

import ls_support from "ls_support.js"

export default {
  name: "user_info_show",

  mixins: [ls_support],

  props: {
    info: { required: true },
  },

  data() {
    return {
      tab_index: null,
    }
  },

  beforeCreate() {
    window.history.pushState(this.$options.name, null, "")
  },

  watch: {
    tab_index(v) {
      window.history.replaceState(v, null, this.permalink_url)
    },
  },

  beforeDestroy() {
    window.history.back()
  },

  created() {
    if (this.development_p) {
      window.addEventListener('popstate', e => this.debug_alert(e.state))
    }

    if ("tab_index" in this.$route.query) {
      this.tab_index = parseInt(this.$route.query.tab_index)
    }
  },

  methods: {
    delete_click_handle() {
      this.$emit("close") // 昔は this.$parent.close() だった
    },

    battled_at_to_ymd(row) {
      return dayjs(row.battled_at).format(this.battled_at_format(row))
    },

    battled_at_format(row) {
      const date = dayjs(row.battled_at)
      if (date.year() === dayjs().year()) {
        return "M / D"
      } else {
        return "YYYY-MM-DD"
      }
    },

    battled_at_to_wday(row) {
      return dayjs(row.battled_at).format("ddd")
    },

    battled_at_to_class(row) {
      if (row.day_color) {
        return `has-text-${row.day_color}`
      }
    },
  },

  computed: {
    ls_data() {
      return {
        tab_index: 0, // 初期値
      }
    },

    permalink_url() {
      const params = new URLSearchParams()
      params.set("query", this.info.user.key)
      params.set("user_info_show", true)
      params.set("tab_index", this.tab_index)
      return `/w?${params}`
    },
  },
}
</script>

<style lang="sass">
@import "./stylesheets/bulma_init.scss"
.user_info_show
  // @at-root
  //   .development
  //     .user_info_show
  //       .columns
  //         border: 1px solid blue
  //       .column
  //         border: 1px solid red
  //       .tile
  //         border: 1px solid cyan

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
    padding-bottom: 0.3rem
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

    .win_lose_circle
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
        bottom: -0.2rem     // 絵文字は大きいので若干下げる
        margin: auto 0.1rem
      > .icon
        position: relative
        bottom: -0.052rem
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
        .win_lose_circle
          margin-top: 0.25rem

      .is-flex
        flex-direction: column
        justify-content: center
        align-items: center
        .tag_wrapper
          cursor: pointer
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
