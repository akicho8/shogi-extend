<template lang="pug">
.user_info_show.modal-card
  //- .modal-card-head
  //-   .modal-card-title {{membership.user.key}}
  .modal-card-body
    // 自分で閉じるボタン設置。組み込みのはもともとフルスクリーンを考慮しておらず、白地に白いボタンで見えないため。
    .delete.is-medium(aria-label="close" @click="delete_click_handle")

    .top_container
      .user_key.has-text-weight-bold.has-text-centered
        | {{info.user.key}}
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

      win_lose_circle(:info="info")

      .has-text-centered.ox_container.line_break_on
          template(v-for="judge_key in info.judge_keys")
            template(v-if="judge_key === 'win'")
              | ○
            template(v-if="judge_key === 'lose'")
              | ●

      hr

    tactic_modal(:tactic_modal_p.sync="tactic_modal_p" :tactic_name="tactic_name")
    template(v-for="row in info.day_list")
      .box.day_list
        .columns.is-mobile
          .column
            .battled_at_human.has-text-weight-bold.is-size-5
              | {{battled_at_human(row.battled_at)}}
            .columns.is-mobile
              .column
                win_lose_circle(:info="row" size="is-small")
              .column
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

  //- pre
  //-   | {{info}}
  //- .modal-card-foot
  //-    button.button(type="button" @click="$parent.close()") 閉じる
</template>

<script>
import dayjs from "dayjs"
import "dayjs/locale/ja.js"
dayjs.locale('ja')

export default {
  props: {
    info: { required: true },
  },

  data() {
    return {
      tactic_name: null,
      tactic_modal_p: false,
    }
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
}
</script>

<style lang="sass">
@import "./stylesheets/bulma_init.scss"
.user_info_show
  .rule_container
    justify-content: center
    // 一つのルール
    .rule_one
      margin: 0 0.5rem
      font-weight: bold
      .rule_name
      .grade_name
        margin-left: 0.2rem

  .day_list
    .tags.has-addons
      cursor: pointer

  .ox_container
    margin: 1rem 2rem
</style>
