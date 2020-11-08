<template lang="pug">
.the_battle_membership.is-flex
  //////////////////////////////////////////////////////////////////////////////// ○×
  .mdi.mdi-checkbox-blank-circle-outline.maru_batu.maru(v-if="mi.latest_ox === 'correct'")
  .mdi.mdi-close.maru_batu.batu(v-if="mi.latest_ox === 'timeout'")

  //////////////////////////////////////////////////////////////////////////////// ○連勝
  .straight_win_straight_lose.is-size-8.has-text-weight-bold(v-if="base.debug_read_p")
    template(v-if="xrecord.straight_win_count >= 1")
      .straight_win_count {{xrecord.straight_win_count}}連勝中！
    template(v-else-if="xrecord.straight_lose_count >= 1")
      .straight_lose_count {{xrecord.straight_lose_count}}連敗中！
    template(v-else)
        | &nbsp;

  //////////////////////////////////////////////////////////////////////////////// アバターと名前
  figure.image.mt-2.is-32x32.avatar_image
    img.is-rounded(:src="membership.user.avatar_path")
  .user_name.has-text-weight-bold.is-size-8.is_truncate.has-text-centered
    | {{membership.user.name}}

  //////////////////////////////////////////////////////////////////////////////// ルール毎に異なる
  template(v-if="base.current_strategy_key === 'sy_marathon' || base.current_strategy_key === 'sy_singleton' || base.current_strategy_key === 'sy_hybrid'")
    .question_progress.is-size-7.has-text-weight-bold
      | {{mi.b_score}} / {{base.b_score_max_for_win}}
    .question_progress_detail(v-if="base.current_strategy_key === 'sy_marathon' || base.current_strategy_key === 'sy_hybrid' || base.debug_read_p")
      template(v-if="droped_ox_list.length === 0")
        | &nbsp;
      template(v-for="ox_mark_key in droped_ox_list")
        template(v-if="ox_mark_key === 'correct'")
          b-icon(icon="checkbox-blank-circle-outline" type="is-danger" size="is-small")
        template(v-if="ox_mark_key === 'mistake'")
          b-icon(icon="close" size="is-small" type="is-success")
        template(v-if="ox_mark_key === 'timeout'")
          b-icon(icon="close" size="is-small" type="is-success")
          //- b-icon(icon="timer-sand-empty" size="is-small")
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "the_battle_membership",
  mixins: [
    support_child,
  ],
  props: {
    membership: { type: Object, required: true, },
  },
  computed: {
    mi() {
      return this.base.member_infos_hash[this.membership.id]
    },
    xrecord() {
      return this.membership.user.actb_main_xrecord
    },
    droped_ox_list() {
      return this.mi.droped_ox_list(this.base.config.ox_status_line_take_n)
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_battle_membership
  // 縦配置
  flex-direction: column
  justify-content: center
  align-items: center

  // 左右大きさがぶれないように大きさを共通にする
  // ここが大きすぎるとPCでは問題なくてもスマホで画面が左右に揺れる
  width: 10rem
  .user_name
    width: 7rem

  .straight_win_straight_lose
    .straight_win_count
      color: $danger
    .straight_lose_count
      color: $success

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
