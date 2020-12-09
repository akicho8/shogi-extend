<template lang="pug">
ShogiPlayer(
  v-bind="{...default_params, ...$attrs}"
  v-on="$listeners"
  ref="pure_sp"
  )
</template>

<script>
import ShogiPlayer from "shogi-player/src/components/ShogiPlayer.vue"

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
$sp_assets_dir: "../node_modules/shogi-player/src/assets"
@import "../node_modules/shogi-player/src/components/ShogiPlayer.sass"

// bulma の .table のなかにあると td の padding が影響してしまう
.table
  .detail-container
    .shogi-player
      td, th
        padding: 0

// 左右キーが効くように常にスライダーにフォーカスさせているけど、
// これがスマホだととても目立つし、スマホだと役にたたないため、色を消す(重要)
// ただフォーカスが効いているのかわからなため production のみとする
.NODE_ENV-production
  .shogi-player
    .turn_slider
      &:focus
        outline: none

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
