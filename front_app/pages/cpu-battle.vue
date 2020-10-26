<template lang="pug">
client-only
  .cpu-battle
    CpuBattleApp(:config="config")
</template>

<script>
export default {
  name: "cpu-battle",
  head() {
    return {
      title: "CPU対戦",
      meta: [
        { hid: "og:title",       property: "og:title",       content: "CPU対戦"                                       },
        { hid: "og:image",       property: "og:image",       content: this.$config.MY_NUXT_URL + "/ogp/cpu-battle.png" },
        { hid: "og:description", property: "og:description", content: "めっちゃ弱いです"                              },
      ],
    }
  },
  async asyncData({ $axios }) {
    const config = await $axios.$get("/api/cpu_battle", {params: {config_fetch: true}})
    return { config }
  },
}
</script>

<style lang="sass">
.cpu-battle
</style>
