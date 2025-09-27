export const mod_sidebar = {
  data() {
    return {
      sidebar_p: false,
    }
  },
  methods: {
    sidebar_toggle() {
      this.sidebar_set(!this.sidebar_p)
    },
    sidebar_set(v) {
      this.sfx_click()
      this.sidebar_p = v
      this.interval_counter_pause(this.sidebar_p)
    },
    sidebar_off() {
      if (this.sidebar_p) {
        this.sidebar_set(false)
      }
    },
  },
}
