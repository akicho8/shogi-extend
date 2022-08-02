<template lang="pug">
ShogiPlayer.CustomShogiPlayer(
  v-bind="component_params"
  v-on="$listeners"
  ref="sp_object"
  )
</template>

<script>
import ShogiPlayer from "shogi-player/components/ShogiPlayer.vue"

// :sp_sound_howl="Howl"
// import { Howl, Howler } from "howler"

export default {
  name: "CustomShogiPlayer",
  inheritAttrs: false, // すべて $attrs に入れるため
  components: {
    ShogiPlayer,
  },
  methods: {
    sp_object() {
      const v = this.$refs.sp_object
      this.__assert__(v)
      return v
    },
  },
  computed: {
    // Howl() { return Howl },

    component_params() {
      return {
        ...this.default_params,
        ...this.$attrs,
      }
    },
    default_params() {
      return {
        sp_layout: "is_horizontal",
        // sp_setting: this.development_p,
        sp_sound_enabled: !!this.$route.query.__system_test_now__,
        sp_sound_volume: 0.5,
        // sp_play_effect_type: this.development_p ? "fw_type_3" : null,
        sp_play_effect_type: null,
      }
    },
  },
}
</script>

<style lang="sass">
.CustomShogiPlayer
  width: 100%

  &.is_run_mode_edit_mode
    --sp_board_color: hsla(149.57,38.12%,35.49%,0.53)
    // --sp_board_color: hsla(141, 71%, 35%, 1.0)
    // --sp_board_color: hsla(348.71,65.89%,74.71%,1)

  // ↓この部分は shogi-player に取り込み
  // +touch
  //   --sp_lifted_origin_bg_color: #{$danger}
  //   --sp_lifted_origin_opacity: 1.0
  // +desktop
  //   --sp_lifted_origin_bg_color: hsla(0, 0%, 0%, 0.1)
  //   --sp_lifted_origin_opacity: 0.5

  // shogi-player に取り込む
  .Membership
    &.is_turn_inactive
      .MembershipLocationPlayerInfo
        font-weight: normal
    &.is_turn_active
      .MembershipLocationPlayerInfo
        font-weight: bold

  +mobile
    --sp_stand_piece_w:     40px // 駒台のセル(W)
    --sp_stand_piece_h:     40px // 駒台のセル(H)
    --sp_piece_box_piece_w: 28px // 駒箱のセル(W)
    --sp_piece_box_piece_h: 32px // 駒箱のセル(H)
    --sp_piece_count_gap_right: 40%
    --sp_grid_outer_color: rgba(0, 0, 0, 0.4) // スマホだと少し薄すくる
    --sp_grid_color:       rgba(0, 0, 0, 0.3) // スマホだと少し薄すくる
    --sp_board_radius: 0 // 角丸を取る

    // モバイルで縦並びになっているとき駒とコントローラーが重なるのを防ぐ
    .is_mobile_vertical_on
      .NavigateBlock
        margin-top: 14px ! important

  &.is_mobile_vertical_good_style
    +mobile
      --sp_stand_piece_w: 40px // 駒台のセル(W) iPhoneXで玉を除く7個の駒が表示できる最大
      --sp_stand_piece_h: 40px // 駒台のセル(H)
      --sp_piece_count_gap_bottom: 58%
      --sp_piece_count_font_size: 8px

  // リアル駒は元々gapを考慮して小さめに作られているため100%にしないとかなり小さく見えてしまう
  .is_pi_variant_d
    --sp_board_piece_rate: 100%

// bulma の .table のなかにあると td の padding が影響してしまう
.table
  .detail-container
    .CustomShogiPlayer
      td, th
        padding: 0
</style>
