import { ColumnInfo } from "./models/column_info.js"

export const app_columns = {
  methods: {
    cb_toggle_handle(info) {
      this.sound_play_click()
      this.$set(this.visible_hash, info.key, !this.visible_hash[info.key])
      if (this.visible_hash[info.key]) {
        this.talk(info.name)
      }
    },
  },
  computed: {
    ColumnInfo() { return ColumnInfo },
  },
}
