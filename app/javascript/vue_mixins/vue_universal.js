// server側でも使いたいもの

export default {
  methods: {
  },
  computed: {
    development_p() {
      return process.env.NODE_ENV === "development"
    },
  },
}
