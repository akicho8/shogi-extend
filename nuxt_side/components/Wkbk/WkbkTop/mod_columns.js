export const mod_columns = {
  data() {
    return {
      visible_hash: {}, //  { a: true, b: false } 形式
    }
  },
  methods: {
    // チェックボックスをトグルする
    cb_toggle_handle(column) {
      this.sfx_play_click()
      this.$set(this.visible_hash, column.key, !this.visible_hash[column.key])
      if (this.visible_hash[column.key]) {
        this.talk(column.name)
      }
    },
  },
}
