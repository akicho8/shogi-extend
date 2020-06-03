<template lang="pug">
.the_battle_membership.is-flex
  .mdi.mdi-checkbox-blank-circle-outline.maru_batu.maru(v-if="mi.latest_ox === 'correct'")
  .mdi.mdi-close.maru_batu.batu(v-if="mi.latest_ox === 'mistake'")

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
  .question_progress
    | {{mi.b_score}} / {{app.config.b_score_max_for_win}}
  .question_progress_detail
    template(v-if="droped_ox_list.length === 0")
      | &nbsp;
    template(v-for="ox_mark_key in droped_ox_list")
      template(v-if="ox_mark_key === 'correct'")
        b-icon(icon="checkbox-blank-circle-outline" type="is-danger" size="is-small")
      template(v-if="ox_mark_key === 'mistake'")
        b-icon(icon="close" size="is-small" type="is-success")
      template(v-if="ox_mark_key === 'timeout'")
        b-icon(icon="timer-sand-empty" size="is-small")
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
    mi() {
      return this.app.member_infos_hash[this.membership.id]
    },
    droped_ox_list() {
      return this.mi.droped_ox_list(this.app.config.progress_list_take_display_count)
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
