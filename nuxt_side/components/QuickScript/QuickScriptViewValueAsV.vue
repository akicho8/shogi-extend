<template lang="pug">
.QuickScriptViewValueAsV(:style="value.style")
  template(v-for="value in value.body")
    QuickScriptViewValue(:value="value")
</template>

<script>
export default {
  props: ["value"],
}
</script>

<style lang="sass">
.QuickScriptViewValueAsV
  display: flex
  flex-direction: column
</style>
