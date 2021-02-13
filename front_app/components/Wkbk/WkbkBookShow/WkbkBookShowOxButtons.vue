<template lang="pug">
.WkbkBookShowOxButtons.buttons.mb-0.has-addons.is-centered
  template(v-for="e in base.OxInfo.values.slice().reverse()")
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
    min-width: 10rem
</style>
