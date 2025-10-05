<template lang="pug">
span.XprofileShow(v-if="xprofile_decorator.exist_p")
  | {{xprofile_decorator.visible_badge_text}}
  template(v-if="!xprofile_decorator.win_count_lteq_max")
    span.count.has-text-gold
      | {{xprofile_decorator.win_count}}
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "XprofileShow",
  mixins: [support_child],
  props: {
    name: { type: String, required: true, },
  },
  computed: {
    xprofile_decorator() { return this.SB.xprofile_decorator_by_name(this.name) },
  },
}
</script>

<style lang="sass">
.XprofileShow
  display: flex
  align-items: center
  justify-content: center
  gap: 1px
</style>
