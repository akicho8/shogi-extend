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
  inheritAttrs: false,
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
        setting_button_show: this.development_p,
        sound_effect: true,
        volume: 0.5,
      }
    },
  },
}
</script>

<style lang="sass">
// TODO: ShogiPlayer.sass からの相対パスで画像が参照できるはずだけど謎のエラーがでる。
// なので仕方なく $sp_assets_dir にここからの相対パスを設定して向こう側で参照するようにしている。
// どうにかしたい。
// $sp_assets_dir: "../node_modules/shogi-player/assets"
// @import "../node_modules/shogi-player/components/ShogiPlayer.sass"

.CustomShogiPlayer
  width: 100%

// bulma の .table のなかにあると td の padding が影響してしまう
.table
  .detail-container
    .shogi-player
      td, th
        padding: 0

.STAGE-development
  .CustomShogiPlayer
    // border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
