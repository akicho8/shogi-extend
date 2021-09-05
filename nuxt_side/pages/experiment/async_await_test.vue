<template lang="pug">
.async_await_test
  .section
    .container
      .buttons
        b-button(tag="nuxt-link" :to="{name: 'index'}") TOP
        b-button(@click="func2") func2
      .block
        pre
          | list: {{list}}
</template>

<script>

export default {
  name: "async_await_test",

  data() {
    return {
      list: [],
    }
  },

  methods: {
    async func1() {
      this.list.push(await this.$axios.$get("/api/sleep.json", {params: {sleep: 0.1, retval: 1}}))
      this.list.push(await this.$axios.$get("/api/sleep.json", {params: {sleep: 0.0, retval: 2}}))
      this.list.push(3)
    },

    func2() {
      this.func1()
      this.list.push(4) // ←どうしてこれが先に呼ばれる？？？
    },
  },
}
</script>

<style lang="sass">
</style>
