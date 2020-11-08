<template lang="pug">
.the_result_membership.is-flex
  //////////////////////////////////////////////////////////////////////////////// ○連勝
  .straight_win_straight_lose.is-size-8.has-text-weight-bold(v-if="!base.room.bot_user_id")
    template(v-if="xrecord.straight_win_count >= 1")
      .straight_win_count {{xrecord.straight_win_count}}連勝中！
    template(v-else-if="xrecord.straight_lose_count >= 1")
      .straight_lose_count {{xrecord.straight_lose_count}}連敗中！
    template(v-else)
        | &nbsp;

  //////////////////////////////////////////////////////////////////////////////// アバターと名前
  figure.image.is-64x64.avatar_image
    img.is-rounded(:src="membership.user.avatar_path")
  .user_name.has-text-weight-bold.mt-1.is_truncate.has-text-centered
    | {{membership.user.name}}

  ////////////////////////////////////////////////////////////////////////////////
  .user_quest_index.has-text-weight-bold.is-size-4(v-if="base.debug_read_p && false")
    | {{mi.b_score}} / {{base.b_score_max_for_win}}

  ////////////////////////////////////////////////////////////////////////////////
  template(v-if="!base.room.bot_user_id")
    .user_rating.has-text-weight-bold(v-if="base.config.rating_display_p")
      | {{rating_format(xrecord.rating)}}
      span.skill_last_diff.has-text-danger(v-if="xrecord.skill_last_diff > 0")
        | (+{{rating_format(xrecord.skill_last_diff)}})
      span.skill_last_diff.has-text-success(v-if="xrecord.skill_last_diff < 0")
        | ({{rating_format(xrecord.skill_last_diff)}})

  the_result_membership_progress(:xrecord="xrecord")

  .battle_continue_container.has-text-weight-bold.mt-1
    b-tag(type="is-warning" v-if="base.continue_tap_counts[membership.id]") 再戦希望
</template>

<script>
import { support_child } from "../support_child.js"
import the_result_membership_progress from "./the_result_membership_progress"

export default {
  mixins: [
    support_child,
  ],
  components: {
    the_result_membership_progress,
  },
  props: {
    membership: { type: Object, required: true, },
  },
  created() {
  },
  computed: {
    mi() {
      return this.base.member_infos_hash[this.membership.id]
    },
    xrecord() {
      return this.membership.user.actb_main_xrecord
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_result_membership
  // 縦配置
  flex-direction: column
  justify-content: center
  align-items: center

  // 左右大きさがぶれないように大きさを共通にする
  min-width: 12rem

  .straight_win_count
    color: $danger
  .straight_lose_count
    color: $success

  .user_name
    max-width: 12rem

  .skill_last_diff
    margin-left: 0.1rem

  .battle_continue_container
    min-height: 1.75rem
</style>
