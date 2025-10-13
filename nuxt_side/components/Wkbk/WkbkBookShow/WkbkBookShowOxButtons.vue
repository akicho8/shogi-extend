<template lang="pug">
.WkbkBookShowOxButtons.buttons.mb-0.has-addons.is-centered
  template(v-for="e in $GX.ary_reverse(base.AnswerKindInfo.values)")
    b-button.mb-0.is-outlined(:icon-left="e.icon" @click="base.next_handle(e)" type="is-primary")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookShowOxButtons",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"

.WkbkBookShowOxButtons
  .button
    &.is-outlined
      background-color: $white

    +mobile
      min-width: 46%
    +tablet
      min-width: 10rem
</style>
