<template lang="pug">
ShogiPlayer.MyShogiPlayer(
  v-bind="{...default_params, ...$attrs}"
  v-on="$listeners"
  ref="pure_sp"
  )
</template>

<script>
import ShogiPlayer from "shogi-player/components/ShogiPlayer.vue"

export default {
  name: "MyShogiPlayer",
  inheritAttrs: false,
  components: {
    ShogiPlayer,
  },
  computed: {
    default_params() {
      return {
        sound_effect: true,
        volume: 0.5,
      }
    }
  },
}
</script>

<style lang="sass">
// TODO: ShogiPlayer.sass からの相対パスで画像が参照できるはずだけど謎のエラーがでる。
// なので仕方なく $sp_assets_dir にここからの相対パスを設定して向こう側で参照するようにしている。
// どうにかしたい。
$sp_assets_dir: "../node_modules/shogi-player/assets"
@import "../node_modules/shogi-player/components/ShogiPlayer.sass"

.MyShogiPlayer
  // --sp_body_width: 35vw
  --sp_dimension: 9
  // 背景
  --sp_ground_color: transparent
  --sp_ground_image: none
  --sp_ground_blur: 0
  --sp_ground_grayscale: 0
  --sp_ground_hue: 0
  --sp_ground_saturate: 1
  --sp_ground_brightness: 1
  // 盤
  --sp_board_color: rgba(0, 0, 0, 0.2)
  --sp_board_image: none
  --sp_board_blur: 0
  --sp_board_grayscale: 0
  --sp_board_hue: 0
  --sp_board_saturate: 1
  --sp_board_brightness: 1
  --sp_board_opacity: 1
  // 盤 - 装飾
  --sp_board_padding: 1.5
  --sp_board_radius: 5
  --sp_board_aspect_ratio: 109.7%
  --sp_board_piece_rate: 90%
  --sp_board_piece_position: center
  // グリッド
  --sp_grid_color: rgba(0, 0, 0, 0.5)
  --sp_grid_stroke: 1
  --sp_grid_outer_stroke: 0
  --sp_grid_star: 10%
  // 駒数
  --sp_piece_count_gap_right: 62%
  --sp_piece_count_gap_bottom: 47%
  --sp_piece_count_font_size: 8px
  --sp_piece_count_font_color: rgba(0, 0, 0, 0.75)
  --sp_piece_count_bg_color: rgba(255, 255, 255, 0.75)
  --sp_piece_count_padding: 2px
  // 駒台
  --sp_stand_piece_rate: 80%
  --sp_stand_hover_border_color: rgba(0, 0, 0, 0.2)
  --sp_stand_piece_w: 47px
  --sp_stand_piece_h: 50px
  // 駒箱
  --sp_piece_box_margin_top: 10px
  --sp_piece_box_piece_w: 38px
  --sp_piece_box_piece_h: 46px
  --sp_piece_box_piece_rate: 90%
  --sp_piece_box_color: rgba(0, 0, 0, 0.2)
  // 影
  --sp_shadow_offset: 2
  --sp_shadow_blur: 3
  --sp_shadow_color: rgba(0, 0, 0, 0.4)

// bulma の .table のなかにあると td の padding が影響してしまう
.table
  .detail-container
    .shogi-player
      td, th
        padding: 0

// // 左右キーが効くように常にスライダーにフォーカスさせているけど、
// // これがスマホだととても目立つし、スマホだと役にたたないため、色を消す(重要)
// // ただフォーカスが効いているのかわからなため production のみとする
// .NODE_ENV-production
//   .shogi-player
//     .turn_slider
//       &:focus
//         outline: none

////////////////////////////////////////////////////////////////////////////// 囲い・戦型 用
// $cell_blank_bg:      $grey
// $something_exist_bg: $green
// $any_exist_soldiers: $grey-light
//
// .shogi-player
//   table
//     .cell_blank
//       background: $cell_blank_bg
//     .something_exist
//       background: $something_exist_bg
//     .any_exist_soldiers
//       color: $any_exist_soldiers

</style>
