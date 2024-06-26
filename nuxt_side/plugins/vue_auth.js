import NuxtLoginContainer from "@/components/NuxtLoginContainer.vue"

export const vue_auth = {
  methods: {
    nuxt_login_modal_open() {
      this.$buefy.modal.open({
        customClass: "my-modal-background-background-color-dark",
        width: "20rem",
        parent: this,
        component: NuxtLoginContainer,
        animation: "",
        // canCancel: [],
        onCancel: () => this.$sound.play_click(),
      })
    },

    nuxt_login_modal_handle() {
      this.$sound.play_click()
      this.nuxt_login_modal_open()
    },
  },
}
