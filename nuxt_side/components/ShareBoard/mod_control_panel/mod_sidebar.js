export const mod_sidebar = {
  data() {
    return {
      sidebar_p: false,
    }
  },
  methods: {
    sidebar_toggle_handle() {
      this.sfx_click()
      this.sidebar_p = !this.sidebar_p
    },
    sidebar_close() {
      this.sidebar_p = false
    },
    sidebar_open() {
      this.sidebar_p = true
    },
  },
}
