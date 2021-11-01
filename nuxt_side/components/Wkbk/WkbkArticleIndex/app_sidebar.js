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
  },
  computed: {
    detail_p: {
      get()  { return this.detailed_keys.length >= 1 },
      set(v) { this.detail_set(v)                    },
    },
    display_option_disabled() {
      return (this.articles ?? []).length === 0
    },
  },
}
