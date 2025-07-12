<template lang="pug">
.SbDebugPanelsBadge.column.is-2
  .panel
    .panel-heading
      | バッジ
    .panel-block
      b-button(size="is-small" @click="SB.badge_add_to_self_if_win('black', 1)") ☗+1
      b-button(size="is-small" @click="SB.badge_add_to_self_if_win('black', -1)") ☗-1
      b-button(size="is-small" @click="SB.badge_add_to_self_if_win('white', 1)") ☖+1
      b-button(size="is-small" @click="SB.badge_add_to_self_if_win('white', -1)") ☖-1
    .panel-block
      b-button(size="is-small" @click="SB.badge_add_to_user(SB.user_name, 1)") 俺+1
      b-button(size="is-small" @click="SB.badge_add_to_user(SB.user_name, -1)") 俺-1
    .panel-block
      pre {{SB.badge_counts_hash}}
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbDebugPanelsBadge",
  mixins: [support_child],
  computed: {
    Howler() { return window.Howler },
  },
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbDebugPanelsBadge
  __css_keep__: 0
</style>
