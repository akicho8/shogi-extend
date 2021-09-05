export const scroll_auto_disable = {
  created() {
    this.scroll_set(false)
  },
  beforeDestroy() {
    this.scroll_set(true)
  },
}
