import SwarsBattleIndexHelpModal from "./SwarsBattleIndexHelpModal.vue"

export const mod_help = {
  methods: {
    general_help_modal_handle() {
      this.sidebar_p = false
      this.$sound.play_click()
      this.modal_card_open({
        component: SwarsBattleIndexHelpModal,
        props: { APP: this.APP },
      })
    },
  },
}
