// server側でも使いたいもの

export default {
  methods: {
  },
  computed: {
    development_p() {
      return process.env.NODE_ENV === "development"
    },
    debug_p() {
      return this.development_p || !!this.$route.query.debug
    },
  },
}
