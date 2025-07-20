<template lang="pug">
  b-button.KifCopyButton.is-small(
    :title="title"
    v-bind="$attrs"
    v-on="$listeners"
    @click="click_handle"
    v-text="name"
    )
</template>

<script>

export default {
  name: "KifCopyButton",
  props: {
    name:  { type: String, default: "コピー",                           },
    title: { type: String, default: "棋譜をクリップボードにコピーする", },
  },
  methods: {
    click_handle() {
      this.app_log("棋譜コピー")
    },
  },
}
</script>

<style lang="sass">
.KifCopyButton
  font-weight: normal
</style>
