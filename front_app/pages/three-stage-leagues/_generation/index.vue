<template lang="pug">
.three-stage-league-generation
  ThreeStageLeagueApp(:config="config")
</template>

<script>
export default {
  name: "three-stage-league-generation",
  async asyncData({ $axios, params }) {
    // http://localhost:3000/api/three_stage_league?generation=28
    const config = await $axios.$get("/api/three_stage_league", {params: params})
    return { config }
  },
  computed: {
    meta() {
      return {
        title: this.config.page_title,
        description: `奨励会三段リーグの結果を見やすく表示します`,
        og_image_key: "three-stage-leagues",
      }
    },
  },
}
</script>

<style lang="sass">
.three-stage-league-generation
</style>
