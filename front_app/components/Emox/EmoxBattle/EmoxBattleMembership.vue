<template lang="pug">
.EmoxBattleMembership.is-flex
  figure.image.mt-2.is-32x32.avatar_image
    img.is-rounded(:src="membership.user.avatar_path")
  .user_name.has-text-weight-bold.is-size-8.is_truncate.has-text-centered
    | {{membership.user.name}}
</template>

<script>
import { support } from "../support.js"

export default {
  name: "EmoxBattleMembership",
  mixins: [
    support,
  ],
  props: {
    base: { type: Object, required: true, },
    membership: { type: Object, required: true, },
  },
  computed: {
    mi() {
      return this.base.member_infos_hash[this.membership.id]
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.EmoxBattleMembership
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
