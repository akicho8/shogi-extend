<template lang="pug">
.QuickScriptShowValueAsH
  template(v-for="value in value.body")
    QuickScriptShowValue(:value="value")
</template>

<script>
export default {
  props: ["value"],
}
</script>

<style lang="sass">
.QuickScriptShowValueAsH
  display: flex
  gap: 0.5rem
</style>
