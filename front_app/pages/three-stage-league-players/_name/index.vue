<template lang="pug">
ThreeStageLeaguePlayerApp(:config="config")
</template>

<script>
export default {
  name: "three-stage-league-player",
  head() {
    return {
      title: this.page_title,
      meta: [
        { hid: "og:title",       property: "og:title",       content: this.page_title,                                                 },
        { hid: "og:image",       property: "og:image",       content: this.$config.MY_NUXT_URL + "/ogp/three-stage-league-players.png" },
        { hid: "og:description", property: "og:description", content: ""                                                               },
      ],
    }
  },
  async asyncData({ $axios, params }) {
    // http://0.0.0.0:3000/api/three_stage_league
    const config = await $axios.$get("/api/three_stage_league_player", {params: params})
    return { config }
  },
  computed: {
    page_title() {
      return `${this.config.main_user.name}の成績 | 奨励会三段リーグ`
    },
  },
}
</script>

<style lang="sass">
.three-stage-league-player
</style>
