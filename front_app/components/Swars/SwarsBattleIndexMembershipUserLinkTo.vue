<template lang="pug">
nuxt-link.SwarsBattleIndexMembershipUserLinkTo(
  :to="{name: 'swars-users-key', params: {key: this.membership.user.key}}"
  @click.native="sound_play('click')"
  :class="css_class"
  )
  | {{membership.user.key}} {{membership.grade_info.name}}
</template>

<script>
export default {
  props: {
    membership: { required: true },
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
