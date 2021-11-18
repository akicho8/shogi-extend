export const app_debug = {
  methods: {
    // 全削除
    async reset_all_handle() {
      await this.$axios.$post("/api/xy_master/time_records", {command: "reset_all"})
      this.time_records_hash_update()
    },

    async rebuild_handle() {
      await this.$axios.$post("/api/xy_master/time_records", {command: "rebuild"})
      this.time_records_hash_update()
    },
  },
}
