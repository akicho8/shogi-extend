import ColorSelectModal from "./ColorSelectModal.vue"

export const app_color_select = {
  methods: {
    color_select_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")

      this.$buefy.modal.open({
        width: "", // width ではなく max-width に設定される
        customClass: "modal_basic ColorSelectModal",
        component: ColorSelectModal,
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
