export default {
  data() {
    return {
      visible_hash: null, //  { xxx: true, yyy: false } 形式
    }
  },
  methods: {
    cb_toggle_handle(column) {
      this.sound_play('click')
      this.$set(this.visible_hash, column.key, !this.visible_hash[column.key])
    },
  },
}
