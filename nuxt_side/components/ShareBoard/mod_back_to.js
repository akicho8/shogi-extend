import TurnChangeModal from "./turn_change/TurnChangeModal.vue"

export const mod_back_to = {
  methods: {
    back_to_click_handle() {
      this.$sound.play_click()
      this.modal_card_open({
        component: TurnChangeModal,
      })
    },
  },
}
