import MySkeltonModal from "./MySkeltonModal.vue"

export const mod_my_skelton = {
  methods: {
    my_skelton_modal_handle() {
      this.sidebar_p = false
      this.sfx_click()
      this.modal_card_open({
        component: MySkeltonModal,
        props: { base: this.base },
      })
    },
  },
}
