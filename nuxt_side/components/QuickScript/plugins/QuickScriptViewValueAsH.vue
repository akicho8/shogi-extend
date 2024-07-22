<template lang="pug">
.QuickScriptViewValueAsH
  template(v-for="value in value")
    QuickScriptViewValue(:value="value")
</template>

<script>
export default {
  props: ["value"],
}
</script>

<style lang="sass">
.QuickScriptViewValueAsH
  display: flex
  flex-wrap: wrap
  gap: 0.5rem
</style>
