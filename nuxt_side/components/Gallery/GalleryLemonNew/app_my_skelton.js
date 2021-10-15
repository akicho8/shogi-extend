import MySkeltonModal from "./MySkeltonModal.vue"

export const app_my_skelton = {
  methods: {
    my_skelton_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      this.modal_card_open({
        component: MySkeltonModal,
        props: { base: this.base },
      })
    },
  },
}
