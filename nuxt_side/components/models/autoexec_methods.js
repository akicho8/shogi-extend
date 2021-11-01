export const autoexec_methods = {
  methods: {
    autoexec() {
      this.$nextTick(() => {
        const s = this.$route.query.autoexec
        if (s) {
          s.split(/[,\s]+/).forEach(e => this[e]())
        }
      })
    },
  },
}
