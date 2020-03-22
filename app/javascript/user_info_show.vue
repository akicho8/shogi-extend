<template lang="pug">
.user_info_show.modal-card
  //- .modal-card-head
  //-   .modal-card-title {{membership.user.key}}
  .modal-card-body
    // 自分で閉じるボタン設置。組み込みのはもともとフルスクリーンを考慮しておらず、白地に白いボタンで見えないため。
    .delete.is-medium(aria-label="close" @click="delete_click_handle")

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
      .has-text-centered.ox_container.line_break_on
          template(v-for="judge_key in info.judge_keys")
            template(v-if="judge_key === 'win'")
              | ○
            template(v-if="judge_key === 'lose'")
              | ●

    hr

    // ここにあるのおかしくね？
    tactic_modal(:tactic_modal_p.sync="tactic_modal_p" :tactic_name="tactic_name")

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    b-tabs(type="is-toggle" size="is-small" v-model="main_tab_index" position="is-centered")
      b-tab-item(label="日付")
      b-tab-item(label="戦法")

    //- b-field(position="is-centered")
    //-   b-radio-button(v-model="main_tab_index" native-value="0" size="is-small") 日付
    //-   b-radio-button(v-model="main_tab_index" native-value="1" size="is-small") 戦法

    template(v-if="main_tab_index === 0")
      .box.one_box.two_column(v-for="row in info.day_list" :key="row.battled_at")
        .columns.is-mobile
          .column.is-paddingless
            .one_box_title.has-text-weight-bold.is-size-6
              | {{battled_at_human(row.battled_at)}}
        .columns.is-mobile
          .column.is-paddingless
            win_lose_circle(:info="row" size="is-small" narrowed)
          .column.is-paddingless
            .is-flex
              b-field(grouped group-multiline)
                template(v-for="tag in row.all_tags")
                  .control
                    b-taglist.is-marginless(attached @click.native="tactic_modal_start(tag)")
                      b-tag(type="is-light")
                        | {{tag.name}}
                      template(v-if="tag.count >= 2")
                        b-tag(type="is-primary")
                          | {{tag.count}}

    template(v-if="main_tab_index === 1")
      .box.one_box.one_column(v-for="row in info.buki_list" :key="row.tag.name")
        .columns.is-mobile
          .column.is-paddingless
            .one_box_title.has-text-weight-bold.is-size-6
              | {{row.tag.name}}
          .column.is-paddingless
            .has-text-right
              span.has-text-grey-light.is-size-7.use_rate_label
                | 使用率
              span.use_rate
                | {{number_to_percentage2(row.use_ratio, 1)}}
              span.has-text-grey-light.is-size-7.use_rate_unit
                | %
        .columns
          .column.is-paddingless
            win_lose_circle(:info="row" size="is-small")

  //- pre
  //-   | {{info}}
  //- .modal-card-foot
  //-    button.button(type="button" @click="$parent.close()") 閉じる
</template>

<script>
import dayjs from "dayjs"
import "dayjs/locale/ja.js"
dayjs.locale('ja')

import ls_support from "ls_support.js"

export default {
  name: "foo",

  mixins: [ls_support],

  props: {
    info: { required: true },
  },

  data() {
    return {
      main_tab_index: null,

      tactic_name: null,
      tactic_modal_p: false,
    }
  },

  created() {
  },

  methods: {
    delete_click_handle() {
      this.$emit("close") // 昔は this.$parent.close() だった
    },

    battled_at_human(v) {
      if (v) {
        return dayjs(v).format("YYYY-MM-DD (ddd)")
      }
    },

    tactic_modal_start(tag) {
      this.tactic_name = tag.name
      this.tactic_modal_p = true
    },
  },

  computed: {
    ls_data() {
      return {
        main_tab_index: 0, // 初期値
      }
    },
  },
}
</script>

<style lang="sass">
@import "./stylesheets/bulma_init.scss"
.user_info_show
  @at-root
    .development
      .user_info_show
        .columns
          border: 1px solid blue
        .column
          border: 1px solid red
        .tile
          border: 1px solid cyan

  .top_container
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

  .one_box
    margin: 1rem 0.5rem
    padding: 1.5rem
    .one_box_title
    .tags.has-addons
      cursor: pointer
    .use_rate_label
      vertical-align: 5%
    .use_rate
      margin-left: 0.3rem
    .use_rate_unit
      margin-left: 0.3rem
      vertical-align: 5%
    &.two_column
      .win_lose_circle
        margin-top: 0.25rem

  .ox_container
    margin: 1rem 2rem

  .b-tabs, .tab-content
    padding: 0

</style>
