<template lang="pug">
ShogiPlayer.CustomShogiPlayer(
  v-bind="component_params"
  v-on="$listeners"
  ref="sp_object"
  )
</template>

<script>
import ShogiPlayer from "shogi-player/components/ShogiPlayer.vue"

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
    component_params() {
      return {...this.default_params, ...this.$attrs}
    },
    default_params() {
      return {
        sp_layout: "is_horizontal",
        // setting_button_show: this.development_p,
        sound_effect: true,
        volume: 0.5,
      }
    },
  },
}
</script>

<style lang="sass">
.CustomShogiPlayer
  width: 100%
  +mobile
    --sp_stand_piece_w:     28px // 駒台のセル(W)
    --sp_stand_piece_h:     32px // 駒台のセル(H)
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

// bulma の .table のなかにあると td の padding が影響してしまう
.table
  .detail-container
    .CustomShogiPlayer
      td, th
        padding: 0
</style>
