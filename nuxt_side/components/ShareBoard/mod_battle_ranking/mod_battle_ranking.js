import SbBattleRankingModal from "./SbBattleRankingModal.vue"

export const mod_battle_ranking = {
  beforeDestroy() {
    this.battle_ranking_modal_close()
  },

  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    battle_ranking_modal_open_handle() {
      if (this.room_required_warn_message()) { return }

      if (!this.battle_ranking_modal_instance) {
        this.sfx_click()
        this.battle_ranking_modal_open()
      }
    },

    battle_ranking_modal_close_handle() {
      if (this.battle_ranking_modal_instance) {
        this.sfx_click()
        this.battle_ranking_modal_close()
      }
    },

    ////////////////////////////////////////

    battle_ranking_modal_open() {
      if (!this.battle_ranking_modal_instance) {
        this.modal_card_open2("battle_ranking_modal_instance", {
          component: SbBattleRankingModal,
          onCancel: () => {
            this.sfx_click()
            this.battle_ranking_modal_close()
          },
        })
      }
    },

    battle_ranking_modal_close() {
      if (this.battle_ranking_modal_instance) {
        this.modal_card_close2("battle_ranking_modal_instance")
      }
    },

    ////////////////////////////////////////////////////////////////////////////////
  },
}
