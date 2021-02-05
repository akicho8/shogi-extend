export const app_sidebar = {
  data() {
    return {
      sidebar_p: false,
    }
  },
  methods: {
    sidebar_toggle() {
      this.sound_play('click')
      this.sidebar_p = !this.sidebar_p
    },
  },
}
