<template lang="pug">
.WkbkBookShowGoal
  .columns.is-gapless
    .column
      .buttons.is-centered(v-if="development_p")
        b-button(@click="base.restart_handle") リスタート
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookShowGoal",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkBookShowGoal
  margin: $wkbk_share_gap
</style>
