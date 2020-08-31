<template lang="pug">
.ip-show
  | {{ip}}
  nuxt-link(:to="{name:'index'}" exact-active-class="is-active") TOP
</template>

<script>

export default {
  name: "ip-show",
  async asyncData({ $axios }) {
    const ip = await $axios.$get("http://icanhazip.com")
    return { ip }
  },
}
</script>

<style lang="sass">
</style>
