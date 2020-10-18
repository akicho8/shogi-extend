<template lang="pug">
.three-stage-league-generation
  ThreeStageLeagueApp(:config="config")
</template>

<script>
export default {
  name: "three-stage-league-generation",
  head() {
    return {
      title: this.config.page_title,
      meta: [
        { hid: "og:title",       property: "og:title",       content: this.config.page_title,                                 },
        { hid: "og:image",       property: "og:image",       content: this.$config.MY_NUXT_URL + "/ogp/three-stage-leagues.png" },
        { hid: "og:description", property: "og:description", content: ""                                                      },
      ],
    }
  },
  // FIXME: generation があるURLにリダイレクトしたい
  async asyncData({ $axios, params }) {
    // http://0.0.0.0:3000/api/three_stage_league
    const config = await $axios.$get("/api/three_stage_league", {params: params})
    return { config }
  },
}
</script>

<style lang="sass">
.three-stage-league-generation
</style>
