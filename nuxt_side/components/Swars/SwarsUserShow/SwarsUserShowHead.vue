<template lang="pug">
.SwarsUserShowHead
  // 名前
  .is-flex.is-justify-content-center.mt-2
    .user_key.has-text-weight-bold.is-clickable(@click="TheApp.name_click_handle")
      | {{TheApp.info.user.key}}
      span.mx-1(v-if="TheApp.info.user.ban_at") 💀

  // 段級位
  .is-flex.display_rule_container
    template(v-for="row in TheApp.info.display_ranks")
      nuxt-link.display_rule_one.is_decoration_off(
        v-if="row.grade_name"
        :to="TheApp.search_path(row.search_params)"
        :key="row.key"
        @click.native="sfx_play_click()"
        )
        span.display_rule_short_name.is-size-7.has-text-grey
          | {{row.short_name}}
        span.display_rule_grade_name.is-size-5
          template(v-if="row.grade_name")
            | {{row.grade_name}}
          template(v-else)
            span.has-text-grey-lighter
              | ？

  // 勝率
  WinLoseCircle(:info="TheApp.info" :to_fn="params => TheApp.search_path(params)")

  // 勝敗列挙
  .ox_container.has-text-centered.is_line_break_on
    template(v-for="judge_key in TheApp.info.judge_keys")
      span.has-text-danger(v-if="judge_key === 'win'")
        b-icon(icon="checkbox-blank-circle" size="is-small" type="is-danger")
      span.has-text-success(v-if="judge_key === 'lose'")
        b-icon(icon="close" size="is-small" type="is-success")
      span.has-text-success(v-if="judge_key === 'draw'")
        b-icon(icon="minus" size="is-small" type="is-success")

  SwarsUserShowHeadBadge
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

  .display_rule_container
    justify-content: center
    // 一つのルール
    .display_rule_one
      &:hover
        background-color: $white-ter
        border-radius: 3px
      padding: 0 0.5rem
      font-weight: bold
      .display_rule_short_name
        __css_keep__: 0
      .display_rule_grade_name
        margin-left: 0.2rem

  .WinLoseCircle
    margin-top: 0.5rem

  .ox_container
    font-size: 0.8rem
    margin-top: 0.5rem
</style>
