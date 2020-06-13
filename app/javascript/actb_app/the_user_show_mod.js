import the_user_show from "./the_user_show.vue"

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
          this.ov_user_show_modal(e.ov_user_info)
        }
      })
    },

    ov_user_info_close() {
      this.sound_play("click")
      this.ov_user_info = null
    },

    ov_user_show_modal(ov_user_info) {
      const modal_instance = this.$buefy.modal.open({
        parent: this,
        hasModalCard: true,
        props: { ov_user_info },
        animation: "",
        component: the_user_show,
      })
    },
  },
}
