<template lang="pug">
.EmoxLobbyDebug.box(v-if="base.debug_write_p")
  .buttons.are-small
    template(v-for="row in base.RuleInfo.values")
      b-button(@click="base.debug_matching_add_handle(row)") 自分以外を{{row.name}}に参加させる
    b-button(@click="base.matching_users_clear_handle") 全員解散
</template>

<script>
import { support } from "./support.js"

export default {
  mixins: [
    support,
  ],
  props: {
    base: { type: Object, required: true, },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.EmoxLobbyDebug
  .image
    img
</style>
