<template lang="pug">
client-only
  .cpu-battle
    CpuBattleApp(:config="config")
</template>

<script>
export default {
  name: "cpu-battle",
  async asyncData({ $axios }) {
    const config = await $axios.$get("/api/cpu_battle", {params: {config_fetch: true}})
    return { config }
  },
  computed: {
    meta() {
      return {
        title: "CPU対戦",
        description: "ネット将棋で心をやられたときにどうぞ",
        og_image_key: "cpu-battle",
      }
    },
  },
}
</script>

<style lang="sass">
.cpu-battle
  __css_keep__: 0
</style>
