<template lang="pug">
.bulma_test
  .has-background-primary .has-background-primary
  .has-background-twitter .has-background-twitter
  .has-background-orange  .has-background-orange
</template>

<script>
export default {
  name: 'bulma_test',
}
</script>

<style lang="sass">
.bulma_test
  +mobile
    background-color: $orange
</style>

