import MySkeltonModal from "./MySkeltonModal.vue"

export const app_my_skelton = {
  methods: {
    my_skelton_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")

      this.$buefy.modal.open({
        width: "", // width ではなく max-width に設定される
        customClass: "modal_basic MySkeltonModal",
        component: MySkeltonModal,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        canCancel: ["outside", "escape"],
        onCancel: () => {
          this.sound_play("click")
        },
        props: {
          base: this.base,
        },
      })
    },
  },
}
