<script>
export default {
  name: "script-index",
  async asyncData(c) {
    return c.redirect(303, {name: "script-id", params: {id: "index"}, query: c.query})
  },
}
</script>
