import SwarsCustomSearchModal from "./SwarsCustomSearchModal.vue"

export const mod_filter_modal = {
  beforeDestroy() {
    this.filter_modal_close()
  },
  methods: {
    filter_modal_handle() {
      this.sfx_click()
      this.filter_modal_close()
      this.$filter_modal_instance = this.modal_card_open({
        component: SwarsCustomSearchModal,
      })
    },
    filter_modal_close() {
      if (this.$filter_modal_instance) {
        this.$filter_modal_instance.close()
        this.$filter_modal_instance = null
      }
    },
  },
}
