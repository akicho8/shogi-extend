<template lang="pug">
.QuickScriptViewValueAsV
  template(v-for="value in value")
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
