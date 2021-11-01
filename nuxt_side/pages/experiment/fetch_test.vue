<template lang="pug">
.fetch_test
  .block
    b fetch_test.vue
    pre {{list}}
  .block
    b FetchTest.vue
    FetchTest
</template>

<script>
export default {
  name: "fetch_test",
  data() {
    return {
      list: ["init"],
    }
  },
  fetch() {
    console.log(this.$fetchState)
    console.log(this.$isServer)
    this.list.push(`fetch SSR:${this.$isServer}`)
  },
}
</script>

<style lang="sass">
</style>
