export const mod_sidebar = {
  data() {
    return {
      sidebar_p: false,
    }
  },
  methods: {
    sidebar_toggle() {
      // this.$sound.play_click()
      this.sidebar_p = !this.sidebar_p
    },
  },
}
