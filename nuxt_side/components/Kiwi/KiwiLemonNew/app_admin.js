export const app_admin = {
  data() {
    return {
      admin_info: null,
    }
  },

  methods: {
    all_info_reload() {
      this.sound_play_click()
      this.$axios.$post("/api/kiwi/lemons/all_info_reload.json", {})
    },

    kiwi_all_info_singlecasted(data) {
      this.admin_info = data
      this.admin_info.lemons = this.admin_info.lemons.map(e => new this.Lemon(this, e))
    },
  },
}
