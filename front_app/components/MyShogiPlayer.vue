<template lang="pug">
ShogiPlayer.MyShogiPlayer(
  v-bind="component_params"
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
  methods: {
    sp_object() {
      return this.$refs.pure_sp
    },
  },
  computed: {
    component_params() {
      return {
        sp_layout: "is_horizontal",
        setting_button_show: this.development_p,
        sound_effect: true,
        volume: 0.5,
        ...this.$attrs,
      }
    }
  },
}
</script>

<style lang="sass">
// TODO: ShogiPlayer.sass からの相対パスで画像が参照できるはずだけど謎のエラーがでる。
// なので仕方なく $sp_assets_dir にここからの相対パスを設定して向こう側で参照するようにしている。
// どうにかしたい。
// $sp_assets_dir: "../node_modules/shogi-player/assets"
// @import "../node_modules/shogi-player/components/ShogiPlayer.sass"

.MyShogiPlayer
  width: 100%

// bulma の .table のなかにあると td の padding が影響してしまう
.table
  .detail-container
    .shogi-player
      td, th
        padding: 0

.STAGE-development
  .MyShogiPlayer
    // border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
