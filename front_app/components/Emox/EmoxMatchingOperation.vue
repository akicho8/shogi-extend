<template lang="pug">
.EmoxMatchingOperation.box(v-if="base.info && development_p")
  | 自分以外を
  .buttons.are-small.is-inline-block.mx-1
    template(v-for="row in base.RuleInfo.values")
      b-button(@click="base.debug_matching_add_handle(row)") {{row.name}}
  | に参加させる
  .buttons.are-small
    b-button(@click="base.matching_users_clear_handle") 全員解散
</template>

<script>
import { child } from "./support_child.js"

export default {
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "support.sass"
</style>
