<template lang="pug">
.SbSidebar(v-if="value")
  .sidebar-background(@click="click_handle")
  .sidebar-content(@click.stop)
    slot
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbSidebar",
  mixins: [support_child],
  props: {
    value: { type: Boolean, required: true, default: false, },
  },
  methods: {
    click_handle(e) {
      this.sfx_click()
      this.$emit("input", false)
    },
  },
}
</script>

<style lang="sass">
@import "../scss/support"

.SbSidebar
  .sidebar-background
    position: fixed
    top: 0
    bottom: 0
    left: 0
    right: 0
    background-color: rgba(10, 10, 10, 0.4)
    z-index: 38

  .sidebar-content
    position: fixed
    top: 0
    bottom: 0
    left: auto
    right: 0
    z-index: 39
    width: 50%

    height: 100%
    max-height: 100%
    background-color: hsl(0, 0%, 96%)
    z-index: 39

    overflow: hidden
    overflow-y: auto
    overscroll-behavior: contain // 親がスクロールしてしまうのを抑制する

    display: flex
    flex-direction: column

  //////////////////////////////////////////////////////////////////////////////// 中に入れるコンポーネントで指定してもよさそうなもの

  .sidebar-content
    min-width: 20rem
    +mobile
      width: 90%
    +tablet
      width: 80%
    +desktop
      width: 70%
    +widescreen
      width: 60%
    +fullhd
      width: 50%

  .sidebar-content
    padding: 1rem
    gap: 1rem

  .box
    margin: 0

.STAGE-development
  .SbSidebar
    .sidebar-content > *
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
