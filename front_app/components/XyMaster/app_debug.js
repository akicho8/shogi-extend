export const app_debug = {
  methods: {
    async reset_all_handle() {
      await this.command_send("reset_all")
      await this.xy_records_hash_update()
    },

    async rebuild_handle() {
      await this.command_send("rebuild")
      await this.xy_records_hash_update()
    },

    // private

    command_send(command, args = {}) {
      return this.$axios.post("/api/xy", {command: command})
    },
  },
}
