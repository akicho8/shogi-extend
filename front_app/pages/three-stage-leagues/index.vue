<script>
export default {
  async asyncData({ $axios, query, redirect }) {
    // http://localhost:3000/api/tsl_league_newest.json
    const record = await $axios.$get("/api/tsl_league_newest", {params: query})
    return redirect(301, {name: "three-stage-leagues-generation", params: {generation: record.generation}, query})
  },
}
</script>
