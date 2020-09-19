<template lang="pug">
client-only
  .three-stage-league-player
    ThreeStageLeaguePlayerApp(:config="config")
</template>

<script>
export default {
  name: "three-stage-league-player",
  head() {
    return {
      title: `${this.config.main_user.name}の個人成績`,
      meta: [
        { hid: "og:title",       property: "og:title",       content: `${this.config.main_user.name}の個人成績`               },
        { hid: "twitter:card",   property: "twitter:card",   content: "summary_large_image"                                   },
        { hid: "og:image",       property: "og:image",       content: this.$config.MY_OGP_URL + "/ogp/three-stage-league-player.png" },
        { hid: "og:description", property: "og:description", content: ""                                                      },
      ],
    }
  },
  watch: {
    "$route.query": function(params) {
      this.$axios.$get("/api/three_stage_league_player", {params: params}).then(e => this.config = e)
    }
  },
  async asyncData({ $axios, query }) {
    // http://0.0.0.0:3000/api/three_stage_league
    const config = await $axios.$get("/api/three_stage_league_player", {params: query})
    return { config }
  },
}
</script>

<style lang="sass">
.three-stage-league-player
</style>
