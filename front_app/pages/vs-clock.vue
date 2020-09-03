<template lang="pug">
.vs-clock
  XclockApp
</template>

<script>
export default {
  name: "Xclock",

  head() {
    return {
      title: "対局時計",
      meta: [
        { hid: "og:title",       property: "og:title",       content: "対局時計"                                                       },
        { hid: "twitter:card",   property: "twitter:card",   content: "summary"                                                        },
        { hid: "og:image",       property: "og:image",       content: this.$config.OGP_SITE_URL + "/ogp/vs-clock-1200x630.png"         },
        { hid: "og:description", property: "og:description", content: "ネット対局と同じような持ち時間のプリセットが入った対局時計です" },
      ],
    }
  },
  mounted() {
    console.log("process.env.NUXT_ENV_KEY1", process.env.NUXT_ENV_KEY1)
    console.log("$config", this.$config)
    // const url = "https://qiita.com/api/v2/items"
    // const response = await this.$axios.$get(url)
    // console.log(response)
    // const url = "/api"
    // const response = await this.$axios.$get(url)
    // console.log(response)
    // this.talk("てすと")
  },
}
</script>

<style lang="sass">
</style>
