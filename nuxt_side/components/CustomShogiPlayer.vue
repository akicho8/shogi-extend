<template lang="pug">
ShogiPlayer.CustomShogiPlayer(v-bind="component_params" v-on="$listeners" ref="sp_object")
</template>

<script>
import ShogiPlayer from "shogi-player/components/ShogiPlayer.vue"

export default {
  name: "CustomShogiPlayer",
  inheritAttrs: false, // すべて $attrs に入れるため
  components: { ShogiPlayer },
  methods: {
    sp_object() {
      const v = this.$refs.sp_object
      this.$gs.assert(v)
      return v
    },
  },
  computed: {
    component_params() {
      return {
        ...this.default_params,
        ...this.$attrs,
      }
    },
    default_params() {
      return {
        sp_layout: "horizontal",
      }
    },
  },
}
</script>

<style lang="sass">
.CustomShogiPlayer
  width: 100%   // ←これいる？

  &.is_mode_edit
    +setvar(sp_board_color, hsla(149.57,38.12%,35.49%,0.53))

  +mobile
    +setvar(sp_grid_outer_color, hsla(0, 0%, 0%, 0.4)) // スマホだと少し薄すくる
    +setvar(sp_grid_inner_color, hsla(0, 0%, 0%, 0.3)) // スマホだと少し薄すくる
    +setvar(sp_board_radius, 0)                        // 角丸を取る

  // リアル駒は小さめに作られているため100%にする
  &.is_piece_variant_portella
    +setvar(sp_board_piece_size, 1.0)

// bulma の .table のなかにあると td の padding が影響してしまうのを防ぐ
.table
  .detail-container
    .CustomShogiPlayer
      td, th
        padding: 0
</style>
