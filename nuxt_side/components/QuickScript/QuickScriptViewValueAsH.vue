<template lang="pug">
.QuickScriptViewValueAsH
  template(v-for="value in value.body")
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
  gap: 0.5rem
</style>
