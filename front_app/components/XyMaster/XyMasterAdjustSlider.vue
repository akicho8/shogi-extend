<template lang="pug">
.XyMasterAdjustSlider.is-hidden-desktop(v-if="base.idol_p")
  b-slider(v-model="base.touch_board_width" :min="0" :max="1" :step="0.001" size="is-small")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XyMasterAdjustSlider",
  mixins: [support_child],
}
</script>

<style lang="sass">
.STAGE-development
  .XyMasterAdjustSlider
    border: 1px dashed change_color($primary, $alpha: 0.5)

.XyMasterAdjustSlider
  display: flex
  justify-content: center
  align-items: center
  .b-slider
    width: 50%
</style>
