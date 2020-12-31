export const app_debug = {
  methods: {
    async reset_all_handle() {
      await this.$axios.$post("/api/ts_master/time_records", {command: "reset_all"})
      await this.time_records_hash_update()
    },

    async rebuild_handle() {
      await this.$axios.$post("/api/ts_master/time_records", {command: "rebuild"})
      await this.time_records_hash_update()
    },
  },
}
