import GalleryLemonNewHelpModal from "./GalleryLemonNewHelpModal.vue"

export const app_help = {
  methods: {
    general_help_modal_handle() {
      this.sidebar_p = false
      this.sound_play_click()
      this.modal_card_open({
        component: GalleryLemonNewHelpModal,
        props: { base: this.base },
      })
    },
  },
}
