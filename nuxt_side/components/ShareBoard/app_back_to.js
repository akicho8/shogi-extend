import TurnChangeModal from "./TurnChangeModal.vue"

export const app_back_to = {
  data() {
    return {
    }
  },
  methods: {
    back_to_click_handle() {
      this.sound_play_click()
      this.modal_card_open({
        component: TurnChangeModal,
        props: {
          base: this.base,
        },
      })
    },
    
  },
}
