<template lang="pug">
.TsMasterSlider.is-hidden-desktop(v-if="base.is_mode_idol")
  b-slider(v-model="base.touch_board_width" :min="0" :max="1" :step="0.001" size="is-small")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "TsMasterSlider",
  mixins: [support_child],
}
</script>

<style lang="sass">
.STAGE-development
  .TsMasterSlider
    border: 1px dashed change_color($primary, $alpha: 0.5)

.TsMasterSlider
  display: flex
  justify-content: center
  align-items: center
  .b-slider
    width: 50%
</style>
