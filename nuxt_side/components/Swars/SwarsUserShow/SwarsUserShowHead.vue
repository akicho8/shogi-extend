<template lang="pug">
.SwarsUserShowHead
  // 名前
  .is-flex.is-justify-content-center.mt-2
    .user_key.has-text-weight-bold.is-clickable(@click="base.name_click_handle")
      | {{base.info.user.key}}

  // 段級位
  .is-flex.rule_container
    template(v-for="(row, key) in base.info.rules_hash")
      template(v-if="blank_p(base.current_rule) || base.current_rule === row.rule_name")
        nuxt-link.rule_one.is-clickable(tag="span" :to="{name: 'swars-search', query: {query: `${base.info.user.key} rule:${row.rule_name}`}}" :key="key" @click.native="sound_play_click()")
          span.rule_name.is-size-7.has-text-grey
            | {{row.rule_name}}
          span.grade_name.is-size-5
            template(v-if="row.grade_name")
              | {{row.grade_name}}
            template(v-else)
              span.has-text-grey-lighter
                | ？

  // 勝率
  WinLoseCircle(:info="base.info" :click_func="base.win_lose_click_handle")

  // 勝敗列挙
  .ox_container.has-text-centered.is_line_break_on
    template(v-for="judge_key in base.info.judge_keys")
      span.has-text-danger(v-if="judge_key === 'win'")
        b-icon(icon="checkbox-blank-circle" size="is-small" type="is-danger")
      span.has-text-success(v-if="judge_key === 'lose'")
        b-icon(icon="close" size="is-small" type="is-success")

  SwarsUserShowHeadMedal(:base="base")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsUserShowHead",
  mixins: [support_child],
}
</script>

<style lang="sass">
.SwarsUserShowHead
  padding-bottom: 0.2rem // アイコンの下の隙間
  border-bottom: 1px solid $grey-lighter

  .user_key
    &:hover
      background-color: $white-ter
      border-radius: 3px
      padding: 0 0.5rem

  .rule_container
    justify-content: center
    // 一つのルール
    .rule_one
      &:hover
        background-color: $white-ter
        border-radius: 3px
      padding: 0 0.5rem
      font-weight: bold
      .rule_name
      .grade_name
        margin-left: 0.2rem

  .WinLoseCircle
    margin-top: 0.5rem

  .ox_container
    font-size: 0.8rem
    margin-top: 0.5rem
</style>
