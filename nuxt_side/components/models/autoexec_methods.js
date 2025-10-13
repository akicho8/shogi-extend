import { GX } from "@/components/models/gs.js"

export const autoexec_methods = {
  methods: {
    autoexec(options = {}) {
      options = {
        key: "autoexec",
        next_tick: true,
        sleep: null,
        ...options,
      }

      const callback = () => {
        const str = this.$route.query[options.key]
        if (str) {
          str.split(/[,\s]+/).forEach(e => {
            const func = this[e]
            GX.assert(func, `存在しないメソッドです : ${e}`)
            func()
          })
        }
      }

      if (options.next_tick) {
        this.$nextTick(callback)
      } else if (options.sleep) {
        setTimeout(callback, options.sleep * 1000)
      } else {
        callback()
      }
    },
  },
}
