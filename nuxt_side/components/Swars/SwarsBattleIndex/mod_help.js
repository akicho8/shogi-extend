import SwarsBattleIndexHelpModal from "./SwarsBattleIndexHelpModal.vue"

export const mod_help = {
  methods: {
    general_help_modal_handle() {
      this.sidebar_p = false
      this.$sound.play_click()
      this.modal_card_open({
        component: SwarsBattleIndexHelpModal,
        props: { base: this.base },
        onCancel: () => { this.kb_shortcut_modal_close() },
      })
    },
  },
}
