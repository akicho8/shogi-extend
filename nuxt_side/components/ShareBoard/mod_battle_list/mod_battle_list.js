import SbBattleListModal from "./SbBattleListModal.vue"

export const mod_battle_list = {
  beforeDestroy() {
    this.battle_list_modal_close()
  },

  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    battle_list_modal_toggle_handle() {
      if (this.battle_list_modal_instance) {
        this.battle_list_modal_close_handle()
      } else {
        this.battle_list_modal_open_handle()
      }
    },

    battle_list_modal_open_handle() {
      if (this.room_required_warn_message()) { return }

      if (!this.battle_list_modal_instance) {
        this.sfx_click()
        this.battle_list_modal_open()
      }
    },

    battle_list_modal_close_handle() {
      if (this.battle_list_modal_instance) {
        this.sfx_click()
        this.battle_list_modal_close()
      }
    },

    ////////////////////////////////////////

    battle_list_modal_open() {
      if (!this.battle_list_modal_instance) {
        this.modal_card_open2("battle_list_modal_instance", {
          component: SbBattleListModal,
          onCancel: () => {
            this.sfx_click()
            this.battle_list_modal_close()
          },
        })
      }
    },

    battle_list_modal_close() {
      if (this.battle_list_modal_instance) {
        this.modal_card_close2("battle_list_modal_instance")
      }
    },

    ////////////////////////////////////////////////////////////////////////////////
  },
}
