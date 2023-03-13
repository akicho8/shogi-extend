import SwarsCustomSearchModal from "../SwarsCustomSearch/SwarsCustomSearchModal.vue"

export const mod_filter_modal = {
  data() {
    return {
      filter_modal_p: false,
    }
  },
  beforeDestroy() {
    this.filter_modal_close()
  },
  methods: {
    filter_modal_handle() {
      this.sidebar_p = false
      this.$sound.play_click()
      this.filter_modal_close()
      this.$filter_modal_instance = this.modal_card_open({
        component: SwarsCustomSearchModal,
        onCancel: () => this.filter_modal_p = false,
        events: {
          close: () => this.filter_modal_p = false,
        },
      })
      this.filter_modal_p = true
    },
    filter_modal_close() {
      if (this.$filter_modal_instance) {
        this.$filter_modal_instance.close()
        this.$filter_modal_instance = null
      }
    },
  },
}
