export const support = {
  methods: {
    say(str, options = {}) {
      this.talk(str, {rate: 1.5, ...options})
    },
  },
}
