export const app_sidebar = {
  data() {
    return {
      sidebar_p: false,
    }
  },
  methods: {
    sidebar_toggle() {
      this.sound_play_click()
      this.sidebar_p = !this.sidebar_p
    },
    sidebar_close() {
      this.sound_play_click()
      this.sidebar_p = false
    },
  },
}
