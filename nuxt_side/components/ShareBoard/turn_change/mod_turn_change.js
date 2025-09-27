import TurnChangeModal from "./TurnChangeModal.vue"
import _ from "lodash"

// const CONFIRM_METHOD = false

export const mod_turn_change = {
  data() {
    return {
      turn_change_modal_instance: null,
    }
  },

  beforeDestroy() {
    this.turn_change_modal_close()
  },

  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    turn_change_to_zero_modal_open_handle() {
      if (this.turn_change_modal_instance == null) {
        this.sidebar_p = false
        this.sfx_play_click()
        // if (CONFIRM_METHOD) {
        //   this.turn_change_modal_instance = this.dialog_confirm({
        //     title: "初期配置に戻す (0手目に移動する)",
        //     message: `途中で局面編集した場合は開始局面が変わるため「平手の初期配置」にはなりません。平手の初期配置に変更するのであれば「手合割」で平手を選択してください`,
        //     confirmText: "実行",
        //     type: "is-danger",
        //     focusOn: "cancel",
        //     onCancel: () => this.turn_change_modal_close(),
        //     onConfirm: () => {
        //       this.sfx_play_click()
        //       this.force_sync_turn_zero()
        //     },
        //   })
        // } else {
        this.ac_log({subject: "盤面起動", body: "初期配置に戻す"})
        this.turn_change_modal_instance = this.modal_card_open({
          component: TurnChangeModal,
          onCancel: () => this.turn_change_modal_close(),
          props: {
            sfen: this.current_sfen,
            turn: 0,
            // message: `ここでの操作は<b>最初の局面に戻るだけ</b>です。最初の局面が平手でない場合に平手に戻したときや駒落ちにするには<b>手合割</b>を選択してください。`,
          },
        })
        // }
      }
    },

    turn_change_modal_close() {
      if (this.turn_change_modal_instance) {
        this.turn_change_modal_instance.close()
        this.turn_change_modal_instance = null
        this.debug_alert("TurnChangeModal close")
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    turn_change_to_previous_modal_open_handle() {
      if (this.turn_change_modal_instance == null) {
        this.sidebar_p = false
        this.sfx_play_click()

        // if (CONFIRM_METHOD) {
        //   this.dialog_confirm({
        //     title: "1手戻す",
        //     message: "実行してもよろしいですか？",
        //     confirmText: "実行",
        //     type: "is-danger",
        //     focusOn: "cancel",
        //     onConfirm: () => {
        //       this.sfx_play_click()
        //       this.force_sync_turn_previous()
        //     },
        //   })
        // } else {
        this.ac_log({subject: "盤面起動", body: "1手戻す"})
        this.turn_change_modal_instance = this.modal_card_open({
          component: TurnChangeModal,
          onCancel: () => this.turn_change_modal_close(),
          props: {
            sfen: this.current_sfen,
            turn: _.clamp(this.current_turn - 1, 0, this.current_turn),
          },
        })
        // }
      }
    },
  },
}
