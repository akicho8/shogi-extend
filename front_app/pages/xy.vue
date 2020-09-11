<template lang="pug">
client-only
  .xy
    XyMasterApp(:config="config")
</template>

<script>
export default {
  name: "xy",
  head() {
    return {
      title: "符号の鬼",
      meta: [
        { hid: "og:title",       property: "og:title",       content: "符号の鬼"                                                       },
        { hid: "twitter:card",   property: "twitter:card",   content: "summary"                                                        },
        { hid: "og:image",       property: "og:image",       content: this.$config.BASE_URL_OGP + "/ogp/xy.png"                  },
        { hid: "og:description", property: "og:description", content: this.config.description },
      ],
    }
  },
  async asyncData({ $axios }) {
    const config = await $axios.$get("/api/xy", {params: {config_fetch: true}})
    return { config }
  },
}
</script>

<style lang="sass">
.xy
</style>
