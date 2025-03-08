<template lang="pug">
.QuickScriptViewValueAsBox.box
  QuickScriptViewValue(:value="value")
</template>

<script>
export default {
  props: ["value"],
}
</script>

<style lang="sass">
.QuickScriptViewValueAsBox
  __css_keep__: 0
</style>
