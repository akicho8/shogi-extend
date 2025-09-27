export const mod_admin = {
  data() {
    return {
      admin_info: null,
    }
  },

  methods: {
    all_info_reload_handle() {
      this.sfx_play_click()
      this.$axios.$post("/api/kiwi/lemons/all_info_reload.json", {}).then(e => this.success_proc(e))
    },

    zombie_kill_now_handle() {
      this.sfx_play_click()
      this.$axios.$post("/api/kiwi/lemons/zombie_kill_now.json", {}).then(e => this.success_proc(e))
    },

    background_job_kick_handle() {
      this.sfx_play_click()
      this.$axios.$post("/api/kiwi/lemons/background_job_kick.json", {}).then(e => this.success_proc(e))
    },

    kiwi_admin_info_singlecasted(data) {
      this.admin_info = data
      this.admin_info.lemons = this.admin_info.lemons.map(e => new this.Lemon(this, e))
    },
  },
}
