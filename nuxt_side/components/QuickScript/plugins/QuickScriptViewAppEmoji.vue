<template lang="pug">
.QuickScriptViewAppEmoji
  XemojiWrap(:str="value.body")
  QuickScriptViewValueAsTable(:value="{rows: entries}")
</template>

<script>
export default {
  name: "QuickScriptViewAppEmoji",
  inject: ["QS"],
  props: ["value"],
  data() {
    return {
      entries: [],
    }
  },
  mounted() {
    this.entries = TwitterEmojiParser(this.value.body)
  },
}
</script>

<style lang="sass">
.QuickScriptViewAppEmoji
  __css_keep__: 0
</style>
