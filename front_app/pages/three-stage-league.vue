<template lang="pug">
client-only
  .three-stage-league
    ThreeStageLeagueApp(:config="config")
</template>

<script>
export default {
  name: "three-stage-league",
  head() {
    return {
      title: "三段リーグ成績早見表",
      meta: [
        { hid: "og:title",       property: "og:title",       content: "三段リーグ成績早見表"                                  },
        { hid: "twitter:card",   property: "twitter:card",   content: "summary_large_image"                                   },
        { hid: "og:image",       property: "og:image",       content: this.$config.MY_OGP_URL + "/ogp/three-stage-league.png" },
        { hid: "og:description", property: "og:description", content: ""                                                      },
      ],
    }
  },
  watch: {
    "$route.query": function(params) {
      this.$axios.$get("/api/three_stage_league", {params: params}).then(e => this.config = e)
    }
  },
  async asyncData({ $axios, query }) {
    // http://0.0.0.0:3000/api/three_stage_league
    const config = await $axios.$get("/api/three_stage_league", {params: query})
    return { config }
  },
}
</script>

<style lang="sass">
.three-stage-league
</style>
