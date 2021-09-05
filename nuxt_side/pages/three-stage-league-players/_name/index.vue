<template lang="pug">
ThreeStageLeaguePlayerApp(:config="config")
</template>

<script>
export default {
  name: "three-stage-league-player",
  async asyncData({ $axios, params }) {
    // http://localhost:3000/api/three_stage_league
    const config = await $axios.$get("/api/three_stage_league_player", {params: params})
    return { config }
  },
  computed: {
    meta() {
      return {
        title: [`${this.config.main_user.name}の成績`, "奨励会三段リーグ"],
        og_image_key: "three-stage-league-players",
      }
    },
  },
}
</script>

<style lang="sass">
.three-stage-league-player
</style>
