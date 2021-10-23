import ColorSelectModal from "./ColorSelectModal.vue"

export const app_color_select = {
  methods: {
    color_select_modal_handle() {
      this.sidebar_p = false
      this.sound_play_click()
      this.modal_card_open({
        component: ColorSelectModal,
        props: { base: this.base },
      })
    },
  },
}
