export const support = {
  methods: {
    api_get(command, params, block) {
      return this.$axios.$get("/api/wbook.json", {params: {remote_action: command, ...params}}).then(e => block(e))
    },

    silent_api_get(command, params, block) {
      return this.$axios.$get("/api/wbook.json", {params: {remote_action: command, ...params}}, {progress: false}).then(e => block(e))
    },

    api_put(command, params, block) {
      return this.$axios.$put("/api/wbook.json", {remote_action: command, ...params}).then(e => block(e))
    },

    silent_api_put(command, params, block) {
      return this.$axios.$put("/api/wbook.json", {remote_action: command, ...params}, {progress: false}).then(e => block(e))
    },
  },
}
