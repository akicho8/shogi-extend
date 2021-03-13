export const app_columns = {
  data() {
    return {
    }
  },
  methods: {
    cb_toggle_handle(column) {
      this.sound_play('click')
      this.$set(this.visible_hash, column.key, !this.visible_hash[column.key])
    },
  },
}
