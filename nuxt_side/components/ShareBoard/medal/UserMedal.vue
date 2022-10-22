<template lang="pug">
span.UserMedal(v-if="medal_vo.exist_p")
  | {{medal_vo.visible_medal_text}}
  template(v-if="!medal_vo.count_lteq_max")
    span.count.has-text-gold
      | {{medal_vo.count}}
</template>

<script>
export default {
  name: "UserMedal",
  props: {
    name: { type: String, required: true, },
  },
  inject: ["TheSb"],
  computed: {
    medal_vo() { return this.TheSb.medal_vo_by_name(this.name) },
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
