<template lang="pug">
  b-button.KifCopyButton.is-small(v-bind="$attrs" v-on="$listeners" @click="click_handle") コピー
</template>

<script>

export default {
  name: "KifCopyButton",
  methods: {
    click_handle() {
      this.ga_click("コピー")
    },
  },
}
</script>

<style lang="sass">
.KifCopyButton
  font-weight: normal
</style>
