<template lang="pug">
  b-button.KifCopyButton.is-small(
    title="棋譜をクリップボードにコピーする"
    v-bind="$attrs"
    v-on="$listeners"
    @click="click_handle"
    )
    | {{name}}
</template>

<script>

export default {
  name: "KifCopyButton",
  props: {
    name: { type: String, default: "コピー", },
  },
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
