export const app_debug = {
  methods: {
    async reset_all_handle() {
      await this.$axios.post("/api/xy", {command: "reset_all"})
      await this.xy_records_hash_update()
    },

    async rebuild_handle() {
      await this.$axios.post("/api/xy", {command: "rebuild"})
      await this.xy_records_hash_update()
    },
  },
}
