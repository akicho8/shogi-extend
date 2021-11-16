export const app_admin = {
  data() {
    return {
      admin_info: null,
    }
  },

  methods: {
    all_info_reload_handle() {
      this.sound_play_click()
      this.$axios.$post("/api/kiwi/lemons/all_info_reload.json", {})
    },

    zombie_kill_now_handle() {
      this.sound_play_click()
      this.$axios.$post("/api/kiwi/lemons/zombie_kill_now.json", {})
    },

    kiwi_admin_info_singlecasted(data) {
      this.admin_info = data
      this.admin_info.lemons = this.admin_info.lemons.map(e => new this.Lemon(this, e))
    },
  },
}
