<template lang="pug">
span.XbadgeShow(v-if="xbadge_decorator.exist_p")
  | {{xbadge_decorator.visible_badge_text}}
  template(v-if="!xbadge_decorator.count_lteq_max")
    span.count.has-text-gold
      | {{xbadge_decorator.count}}
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "XbadgeShow",
  mixins: [support_child],
  props: {
    name: { type: String, required: true, },
  },
  computed: {
    xbadge_decorator() { return this.SB.xbadge_decorator_by_name(this.name) },
  },
}
</script>

<style lang="sass">
.XbadgeShow
  display: flex
  align-items: center
  justify-content: center
  gap: 1px
</style>
