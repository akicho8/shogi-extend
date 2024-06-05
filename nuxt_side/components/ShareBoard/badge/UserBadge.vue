<template lang="pug">
span.UserBadge(v-if="badge_decorator.exist_p")
  | {{badge_decorator.visible_badge_text}}
  template(v-if="!badge_decorator.count_lteq_max")
    span.count.has-text-gold
      | {{badge_decorator.count}}
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "UserBadge",
  mixins: [support_child],
  props: {
    name: { type: String, required: true, },
  },
  computed: {
    badge_decorator() { return this.SB.badge_decorator_by_name(this.name) },
  },
}
</script>

<style lang="sass">
.UserBadge
  display: flex
  align-items: center
  justify-content: center
  gap: 1px
</style>
