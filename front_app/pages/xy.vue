<template lang="pug">
client-only
  .xy
    XyMasterApp(:config="config" v-if="config")
</template>

<script>

export default {
  name: "xy",
  async asyncData({ $axios }) {
    const config = await $axios.$get("/api/xy", {params: {config_fetch: true}})
    return { config }
  },
}
</script>

<style lang="sass">
.xy
</style>
