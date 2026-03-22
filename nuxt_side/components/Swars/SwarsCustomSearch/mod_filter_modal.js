import SwarsCustomSearchModal from "./SwarsCustomSearchModal.vue"

export const mod_filter_modal = {
  beforeDestroy() {
    this.filter_modal_close()
  },
  methods: {
    filter_modal_handle() {
      this.sfx_click()
      this.filter_modal_close()
      this.modal_card_open2("filter_modal_instance", {
        component: SwarsCustomSearchModal,
      })
    },
    filter_modal_close() {
      if (this.filter_modal_instance) {
        this.modal_card_close2("filter_modal_instance")
      }
    },
  },
}
