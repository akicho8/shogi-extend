import SwarsBattleIndexHelpModal from "./SwarsBattleIndexHelpModal.vue"

export const app_help = {
  methods: {
    general_help_modal_handle() {
      this.sidebar_p = false
      this.$sound.play_click()
      this.modal_card_open({
        component: SwarsBattleIndexHelpModal,
        props: { base: this.base },
      })
    },
  },
}
