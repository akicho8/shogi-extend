<template lang="pug">
.SbDebugPanelsMedal.column.is-2
  .panel
    .panel-heading
      | メダル
    .panel-block
      b-button(size="is-small" @click="TheSb.medal_add_to_self_if_win('black', 1)") ☗+1
      b-button(size="is-small" @click="TheSb.medal_add_to_self_if_win('black', -1)") ☗-1
      b-button(size="is-small" @click="TheSb.medal_add_to_self_if_win('white', 1)") ☖+1
      b-button(size="is-small" @click="TheSb.medal_add_to_self_if_win('white', -1)") ☖-1
    .panel-block
      b-button(size="is-small" @click="TheSb.medal_add_to_user(TheSb.user_name, 1)") 俺+1
      b-button(size="is-small" @click="TheSb.medal_add_to_user(TheSb.user_name, -1)") 俺-1
    .panel-block
      pre {{TheSb.medal_counts_hash}}
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbDebugPanelsMedal",
  mixins: [support_child],
  computed: {
    Howler() { return window.Howler },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.SbDebugPanelsMedal
  __css_keep__: 0
</style>
