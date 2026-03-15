import TurnChangeModal from "./TurnChangeModal.vue"
import _ from "lodash"

export const turn_change = {
  data() {
    return {
    }
  },

  beforeDestroy() {
    this.turn_change_modal_close()
  },

  methods: {
    turn_change_to_zero_modal_open_handle() {
      this.turn_change_to_xxx_modal_open_handle(0) // TODO: to: 0 にしたい
    },

    turn_change_to_previous_modal_open_handle() {
      this.turn_change_to_xxx_modal_open_handle(this.current_turn - 1) // TODO: by: -1 にしたい
    },

    turn_change_to_xxx_modal_open_handle(turn) {
      if (!this.turn_change_modal_instance) {
        this.sidebar_close()
        this.sfx_click()
        this.turn_change_modal_instance = this.modal_card_open({
          component: TurnChangeModal,
          onCancel: () => this.turn_change_modal_close(),
          props: {
            sfen: this.current_sfen,
            turn: turn,
          },
        })
      }
    },

    turn_change_modal_close_handle() {
      if (this.turn_change_modal_instance) {
        this.sfx_click()
        this.turn_change_modal_close()
      }
    },

    turn_change_modal_close() {
      if (this.turn_change_modal_instance) {
        this.turn_change_modal_instance.close()
        this.turn_change_modal_instance = null
        this.debug_alert("TurnChangeModal close")
      }
    },

    turn_change_call_handle(turn) {
      this.turn_change_modal_close()
      this.think_mark_clear_all_action({sfx: false})
      this.reflector_call({turn})
    },
  },
}
