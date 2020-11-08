import the_user_show from "./the_user_show.vue"

export const application_user_show = {
  methods: {
    ov_user_url(id) {
      const params = new URLSearchParams()
      params.set("user_id", id)
      return `/training?${params}`
    },

    ov_user_info_set(user_id) {
      this.sound_play("click")
      this.api_get("user_single_fetch", {user_id: user_id}, e => {
        if (e.ov_user_info) {
          this.ov_user_show_modal(e.ov_user_info)
        }
      })
    },

    ov_user_show_modal(ov_user_info) {
      this.$ov_user_modal = this.$buefy.modal.open({
        parent: this,
        hasModalCard: true,
        props: {
          ov_user_info: ov_user_info,
          base: this.base,
        },
        animation: "",
        onCancel: () => this.sound_play("click"),
        canCancel: ["escape", "outside"],
        component: the_user_show,
      })
    },

    ov_user_modal_close() {
      if (this.$ov_user_modal) {
        this.$ov_user_modal.close()
        this.$ov_user_modal = null
      }
    },
  },
}
