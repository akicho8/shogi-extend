<template lang="pug">
//- new_info を更新(最大100件タップ)したときに円が更新されるようにするために key が必要
.user_info_show.modal-card(:key="new_info.key")
  //- .modal-card-head
  //-   .modal-card-title {{membership.user.key}}
  .modal-card-body
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

      b-dropdown-item(:href="`/w?query=${new_info.user.key}`" @click="$buefy.loading.open()")
        b-icon(icon="magnify" size="is-small")
        | 棋譜検索

      b-dropdown-item(separator)

      b-dropdown-item(:href="`https://twitter.com/search?q=将棋 ${new_info.user.key}`")
        b-icon(icon="twitter" size="is-small" type="is-info")
        | Twitter検索

      b-dropdown-item(:href="`https://shogiwars.heroz.jp/users/mypage/${new_info.user.key}`")
        b-icon(icon="link" size="is-small")
        | ウォーズ

      b-dropdown-item(:href="`https://www.google.co.jp/search?q=${new_info.user.key}`")
        b-icon(icon="google" size="is-small")
        | ぐぐる

      template(v-if="development_p")
        b-dropdown-item(:href="permalink_url")
          b-icon(icon="link-variant" size="is-small")
          | パーマリンク

        b-dropdown-item(:href="`${permalink_url}&debug=true`")
          b-icon(icon="link-variant" size="is-small")
          | パーマリンク(DEBUGモード)

        b-dropdown-item(:href="`/w.json?query=${new_info.user.key}&format_type=user`")
          b-icon(icon="link-variant" size="is-small")
          | json

        b-dropdown-item(:href="`/w.json?query=${new_info.user.key}&format_type=user&debug=true`" v-if="development_p")
          b-icon(icon="link-variant" size="is-small")
          | json (debug)

        b-dropdown-item.is-paddingless(custom)
          pre
            | {{new_info.debug_hash}}

    .top_container
      ////////////////////////////////////////////////////////////////////////////////
      // 名前
      .user_key.has-text-weight-bold.has-text-centered
        | {{new_info.user.key}}
      // 段級位
      .is-flex.rule_container
        .rule_one(v-for="(row, key) in new_info.rules_hash")
          span.rule_name.is-size-7.has-text-grey
            | {{row.rule_name}}
          span.grade_name.is-size-5
            template(v-if="row.grade_name")
              | {{row.grade_name}}
            template(v-else)
              span.has-text-grey-lighter
                | ？

      ////////////////////////////////////////////////////////////////////////////////
      win_lose_circle(:info="new_info")

      ////////////////////////////////////////////////////////////////////////////////
      .ox_container.has-text-centered.is_line_break_on
        template(v-for="judge_key in new_info.judge_keys")
          span.has-text-danger(v-if="judge_key === 'win'")
            b-icon(icon="checkbox-blank-circle" size="is-small" type="is-danger")
          span.has-text-success(v-if="judge_key === 'lose'")
            b-icon(icon="close" size="is-small" type="is-success")

      .medal_container.has-text-centered.has-text-weight-bold(v-if="new_info.medal_list.length >= 1")
        template(v-for="(row, i) in new_info.medal_list")
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
      b-tab-item(label="段級")
      b-tab-item(label="戦法")
      b-tab-item(label="対抗")

    //- b-field(position="is-centered")
    //-   b-radio-button(v-model="tab_index" native-value="0" size="is-small") 日付
    //-   b-radio-button(v-model="tab_index" native-value="1" size="is-small") 戦法

    .tab_content
      template(v-if="tab_index === 0")
        .box.one_box.two_column.is_clickable(v-for="(row, i) in new_info.every_day_list" :key="`every_day_list/${i}`" @click="every_day_click_handle(row)")
          .columns.is-mobile
            .column.is-paddingless
              .one_box_title.has-text-weight-bold.is-size-5
                | {{date_to_custom_format(row.battled_on) + " "}}
                span(:class="battled_on_to_class(row)")
                  | {{date_to_wday(row.battled_on)}}
          .columns.is-mobile
            .column.is-paddingless
              win_lose_circle(:info="row" size="is-small" narrowed)
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
        .box.one_box.is_clickable(v-for="(row, i) in new_info.every_grade_list" :key="`every_grade_list/${i}`" @click="every_grade_click_handle(row)")
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
              win_lose_circle(:info="row" size="is-small")
      template(v-if="tab_index === 2")
        .box.one_box.is_clickable(v-for="(row, i) in new_info.every_my_attack_list" :key="`every_my_attack_list/${i}`" @click="every_my_attack_click_handle(row)")
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
              win_lose_circle(:info="row" size="is-small")

      template(v-if="tab_index === 3")
        .box.one_box.is_clickable(v-for="(row, i) in new_info.every_vs_attack_list" :key="`every_vs_attack_list/${i}`" @click="every_vs_attack_click_handle(row)")
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
              win_lose_circle(:info="row" size="is-small")

  template(v-if="development_p")
    //- pre
    //-   | {{new_info}}
    .modal-card-foot
      b-button(@click="$parent.close()" size="is-small" v-if="false") 閉じる
      b-button(tag="a" :href="permalink_url" size="is-small" icon-left="link-variant") パーマリンク
      b-button(tag="a" :href="`${permalink_url}&debug=true`" size="is-small" icon-left="link-variant") パーマリンク(DEBUGモード)
</template>

<script>
import ls_support from "./ls_support.js"

export default {
  name: "user_info_show",

  mixins: [ls_support],

  props: {
    info:         { required: true },
  },

  data() {
    return {
      new_info: this.info,
      tab_index: null,
    }
  },

  mounted() {
    // https://developers.google.com/analytics/devguides/collection/gtagjs/pages?hl=ja
    this.$gtag.pageview({page_title: "プレイヤー情報", page_location: this.permalink_url})
  },

  beforeCreate() {
    window.history.pushState(this.$options.name, null, "")
  },

  beforeDestroy() {
  },

  watch: {
    tab_index(v) {
      this.$gtag.event("open", {event_category: `プレイヤー情報(${this.tab_name})`})

      window.history.replaceState(v, null, this.permalink_url)
    },
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
    every_day_click_handle(row) {
      this.$emit("close")
      GVI.$emit("query_search", `${this.new_info.user.key} sample:${this.new_info.sample_max} date:${this.date_to_ymd(row.battled_on)}`)
    },

    every_my_attack_click_handle(row) {
      this.$emit("close")
      GVI.$emit("query_search", `${this.new_info.user.key} sample:${this.new_info.sample_max} tag:${row.tag.name}`)
    },

    every_vs_attack_click_handle(row) {
      this.$emit("close")
      GVI.$emit("query_search", `${this.new_info.user.key} sample:${this.new_info.sample_max} vs-tag:${row.tag.name}`)
    },

    every_grade_click_handle(row) {
      this.$emit("close")
      GVI.$emit("query_search", `${this.new_info.user.key} sample:${this.new_info.sample_max} vs-grade:${row.grade_name}`)
    },

    update_handle(options = {}) {
      this.remote_get("/w.json", { query: this.new_info.user.key, format_type: "user", debug: this.$route.query.debug, ...options}, data => this.new_info = data)
    },

    delete_click_handle() {
      this.$emit("close")
      window.history.back()
    },

    battled_on_to_class(row) {
      if (row.day_type) {
        return `has-text-${row.day_type}`
      }
    },
  },

  computed: {
    tab_name() {
      return ["日付", "段級", "戦法", "対抗"][this.tab_index]
    },

    ls_data() {
      return {
        tab_index: 0, // 初期値
      }
    },

    permalink_url() {
      const params = new URLSearchParams()
      params.set("query", this.new_info.user.key)
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
        .win_lose_circle
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
