export const autoexec_methods = {
  methods: {
    autoexec() {
      this.$nextTick(() => {
        const s = this.$route.query.autoexec
        if (s) {
          s.split(/[,\s]+/).forEach(e => {
            const func = this[e]
            this.$gs.assert(this.$gs.present_p(func), `存在しないメソッドです : ${e}`)
            func()
          })
        }
      })
    },
  },
}
