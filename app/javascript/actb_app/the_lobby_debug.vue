<template lang="pug">
.the_lobby_debug.box.is_debug(v-if="app.debug_mode_p")
  .buttons.is-centered.are-small
    template(v-for="row in app.RuleInfo.values")
      b-button(@click="app.debug_matching_add_handle(row.key)") 自分以外を{{row.name}}に参加させる
    b-button(@click="app.matching_delete_all_handle") 全員解散
</template>

<script>
import { support } from "./support.js"

export default {
  name: "the_builder",
  mixins: [
    support,
  ],
}
</script>

<style lang="sass">
@import "support.sass"
.the_lobby_debug
</style>
