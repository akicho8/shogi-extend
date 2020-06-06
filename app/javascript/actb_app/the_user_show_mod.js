export const the_user_show_mod = {
  data() {
    return {
      ov_user_info: null,
    }
  },

  methods: {
    ov_user_info_set(user_id) {
      this.sound_play("click")
      this.remote_get(this.app.info.put_path, { remote_action: "user_single_fetch", user_id: user_id }, e => {
        if (e.ov_user_info) {
          this.ov_user_info = e.ov_user_info
        }
      })
    },

    ov_user_info_close() {
      this.sound_play("click")
      this.ov_user_info = null
    },
  },
}
