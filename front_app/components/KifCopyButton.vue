<template lang="pug">
  b-button.KifCopyButton.is-small(v-bind="$attrs" v-on="$listeners" @click="click_handle") コピー
</template>

<script>

export default {
  name: "KifCopyButton",
  // props: {
  //   icon_only: { default: false, },
  // },
  methods: {
    click_handle() {
      // this.$gtag.event("click", {event_category: "棋譜コピー"})
    },
  },
}
</script>

<style lang="sass">
.KifCopyButton
  font-weight: normal
</style>
