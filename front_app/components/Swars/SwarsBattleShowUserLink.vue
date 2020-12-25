<template lang="pug">
nuxt-link.SwarsBattleShowUserLink(
  :to="{name: 'swars-users-key', params: {key: membership.user.key}}"
  @click.native.stop="sound_play('click')"
  )
  //- :class="css_class"
  span(:class="`has-text-${membership.location.key}`") ☗
  span {{membership.user.key}} {{membership.grade_info.name}}
  span.mx-1(v-if="membership.judge.name !== '負け'") ({{membership.judge.name}})
</template>

<script>
export default {
  props: {
    membership: { required: true },
  },
  computed: {
    // css_class() {
    //   if (this.membership.judge) {
    //     return `is-${this.membership.judge.key}`
    //   }
    // },
  },
}
</script>

<style lang="sass">
.SwarsBattleShowUserLink
  // &.is-win
  //   font-weight: bold
</style>
