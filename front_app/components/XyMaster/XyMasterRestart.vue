<template lang="pug">
b-button.XyMasterRestart(
  @click="base.restart_handle"
  size="is-medium"
  icon-left="restart"
  type="is-text"
  )
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XyMasterRestart",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "./support.sass"

.XyMasterRestart
  position: absolute
  top: 0
  right: 0
</style>
