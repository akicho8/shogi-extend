export const scroll_auto_disable = {
  mounted() {
    this.scroll_set(true)
  },
  beforeDestroy() {
    this.scroll_set(false)
  },
}
