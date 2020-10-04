<template lang="pug">
a.SwarsBattleIndexMembershipUserLinkTo(@click="click_handle" :class="css_class")
  | {{membership.user.key}} {{membership.grade_info.name}}
</template>

<script>
export default {
  props: {
    membership: { required: true },
  },
  methods: {
    click_handle() {
      this.$router.push({name: "swars-users-key", params: {key: this.membership.user.key}})
    },
  },
  computed: {
    css_class() {
      if (this.membership.judge) {
        return `is-${this.membership.judge.key}`
      }
    },
  },
}
</script>

<style lang="sass">
.SwarsBattleIndexMembershipUserLinkTo
  &.is-win
    font-weight: bold
</style>
