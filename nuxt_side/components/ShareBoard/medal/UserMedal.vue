<template lang="pug">
span.UserMedal(v-if="medal_decorator.exist_p")
  | {{medal_decorator.visible_medal_text}}
  template(v-if="!medal_decorator.count_lteq_max")
    span.count.has-text-gold
      | {{medal_decorator.count}}
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "UserMedal",
  mixins: [support_child],
  props: {
    name: { type: String, required: true, },
  },
  computed: {
    medal_decorator() { return this.TheSb.medal_decorator_by_name(this.name) },
  },
}
</script>

<style lang="sass">
.UserMedal
  display: flex
  align-items: center
  justify-content: center
  gap: 1px
</style>
