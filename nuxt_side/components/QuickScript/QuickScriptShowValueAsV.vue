<template lang="pug">
.QuickScriptShowValueAsV
  template(v-for="value in value.body")
    QuickScriptShowValue(:value="value")
</template>

<script>
export default {
  props: ["value"],
}
</script>

<style lang="sass">
.QuickScriptShowValueAsV
  display: flex
  flex-direction: column
</style>
