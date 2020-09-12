<template lang="pug">
.yesno_test
  nuxt-link(:to="{name:'index'}" exact-active-class="is-active") TOP
  hr
  pre {{yesno_params}}
  hr
  b-image(:src="yesno_params.image")
</template>

<script>

export default {
  name: "yesno_test",
  async asyncData({ $axios }) {
    const yesno_params = await $axios.$get("https://yesno.wtf/api")
    return { yesno_params }
  },
}
</script>

<style lang="sass">
</style>
