<template lang="pug">
.the_battle_membership.is-flex
  .mdi.mdi-checkbox-blank-circle-outline.maru_batu.maru(v-if="app.sub_mode === 'correct_mode'")
  .mdi.mdi-close.maru_batu.batu(v-if="app.sub_mode === 'mistake_mode'")

  //////////////////////////////////////////////////////////////////////////////// ○連勝
  template(v-if="membership.user.actb_current_xrecord.rensho_count >= 1")
    .rensho_count {{membership.user.actb_current_xrecord.rensho_count}}連勝中！
  template(v-else-if="membership.user.actb_current_xrecord.renpai_count >= 1")
    .renpai_count {{membership.user.actb_current_xrecord.renpai_count}}連敗中！
  template(v-else)
      | &nbsp;

  //////////////////////////////////////////////////////////////////////////////// アバターと名前
  figure.image
    img.is-rounded(:src="membership.user.avatar_path")
  .user_name.has-text-weight-bold
    | {{membership.user.name}}

  //////////////////////////////////////////////////////////////////////////////// ルール毎に異なる
  template(v-if="app.battle.rule.key === 'marathon_rule'")
    .question_progress
      | {{ox_list.length}} / {{app.battle.best_questions.length}}
    .question_progress_detail
      template(v-if="droped_ox_list.length === 0")
        | &nbsp;
      template(v-for="ox_mark_key in droped_ox_list")
        template(v-if="ox_mark_key === 'correct'")
          b-icon(icon="checkbox-blank-circle-outline" type="is-danger" size="is-small")
        template(v-if="ox_mark_key === 'mistake'")
          b-icon(icon="close" size="is-small" type="is-success")

  template(v-if="app.battle.rule.key === 'singleton_rule' || app.battle.rule.key === 'hybrid_rule'")
    .question_progress
      | {{x_score}}
    .question_progress_detail
      template(v-if="droped_ox_list.length === 0")
        | &nbsp;
      template(v-for="ox_mark_key in droped_ox_list")
        template(v-if="ox_mark_key === 'correct'")
          b-icon(icon="checkbox-blank-circle-outline" type="is-danger" size="is-small")
        template(v-if="ox_mark_key === 'mistake'")
          b-icon(icon="close" size="is-small" type="is-success")
</template>

<script>
import { support } from "./support.js"

export default {
  name: "the_battle_membership",
  mixins: [
    support,
  ],
  props: {
    membership: { type: Object, required: true, },
  },
  computed: {
    ox_list() {
      return this.app.members_hash[this.membership.id].ox_list
    },
    droped_ox_list() {
      return _.takeRight(this.ox_list, this.app.config.progress_list_take_display_count)
    },
    x_score() {
      return this.app.members_hash[this.membership.id].x_score
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_battle_membership
  // 縦配置
  flex-direction: column
  justify-content: center
  align-items: center

  // 左右大きさがぶれないように大きさを共通にする
  min-width: 12rem

  .rensho_count
    color: $danger
  .renpai_count
    color: $success

  // avatar
  img
    width: 32px
    height: 32px

  // オーバーレイ○×
  position: relative
  .maru_batu
    position: absolute
    top: -3rem
    left: 0%
    right: 0%

    text-align: center
    font-size: 8rem
    width: 100%
    z-index: 1
    opacity: 0.3
    &.maru
      color: $danger
    &.batu
      color: $success
</style>
