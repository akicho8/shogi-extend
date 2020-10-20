<script>
export default {
  async asyncData({ $axios, query, redirect }) {
    // http://0.0.0.0:3000/api/tsl_user_newest.json
    const record = await $axios.$get("/api/tsl_user_newest", {params: query})
    return redirect(301, {name: "three-stage-league-players-name", params: {name: record.name}, query})
  },
}
</script>
