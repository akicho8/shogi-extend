<script>
export default {
  async asyncData(c) {
    return c.redirect(303, {path: "/bin/chore/index", query: c.query})
  },
}
</script>
