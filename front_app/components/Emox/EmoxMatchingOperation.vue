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
</style>
