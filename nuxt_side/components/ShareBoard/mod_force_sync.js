import ForceSyncModal from "./ForceSyncModal.vue"
import TurnChangeModal from "./TurnChangeModal.vue"
import _ from "lodash"

const CONFIRM_METHOD = false

export const mod_force_sync = {
  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    board_init_modal_handle() {
      this.sidebar_p = false
      this.$sound.play_click()

      if (CONFIRM_METHOD) {
        this.dialog_confirm({
          title: "初期配置に戻す (0手目に移動する)",
          message: `途中で局面編集した場合は開始局面が変わるため「平手の初期配置」にはなりません。平手の初期配置に変更するのであれば「手合割」で平手を選択してください`,
          confirmText: "実行",
          type: "is-danger",
          focusOn: "cancel",
          onConfirm: () => {
            this.$sound.play_click()
            this.force_sync_turn_zero()
          },
        })
      } else {
        this.ac_log({subject: "盤面起動", body: "初期配置に戻す"})
        this.modal_card_open({
          component: TurnChangeModal,
          props: {
            sfen: this.current_sfen,
            turn: 0,
          },
        })
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    force_sync_turn_previous_modal_handle() {
      this.sidebar_p = false
      this.$sound.play_click()

      if (CONFIRM_METHOD) {
        this.dialog_confirm({
          title: "1手戻す",
          message: "実行してもよろしいですか？",
          confirmText: "実行",
          type: "is-danger",
          focusOn: "cancel",
          onConfirm: () => {
            this.$sound.play_click()
            this.force_sync_turn_previous()
          },
        })
      } else {
        this.ac_log({subject: "盤面起動", body: "1手戻す"})
        this.modal_card_open({
          component: TurnChangeModal,
          props: {
            sfen: this.current_sfen,
            turn: _.clamp(this.current_turn - 1, 0, this.current_turn),
          },
        })
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    force_sync_modal_handle() {
      if (this.if_room_is_empty()) { return }
      this.sidebar_p = false
      this.$sound.play_click()
      this.modal_card_open({
        component: ForceSyncModal,
      })
    },

    ////////////////////////////////////////////////////////////////////////////////

    force_sync_direct() {
      this.ac_log({subject: "局面操作", body: `直接${this.current_turn}手目`})
      this.force_sync(`${this.user_call_name(this.user_name)}が現在の局面(${this.current_turn}手目)の局面を転送しました`)
    },

    force_sync_turn_zero() {
      this.ac_log({subject: "局面操作", body: "初期配置に戻す"})
      this.current_turn = 0
      this.force_sync(`${this.user_call_name(this.user_name)}が初期配置に戻しました`)
    },

    force_sync_turn_previous() {
      this.ac_log({subject: "局面操作", body: "1手戻す"})
      if (this.current_turn >= 1) {
        this.current_turn -= 1
      }
      this.force_sync(`${this.user_call_name(this.user_name)}が1手戻しました`)
    },

    force_sync_handicap() {
      this.current_turn = 0
      this.current_sfen = this.board_preset_info.sfen
      this.ac_log({subject: "駒落適用", body: this.board_preset_info.name})
      this.force_sync(`${this.user_call_name(this.user_name)}が${this.board_preset_info.name}に変更しました`)
    },

    new_turn_set_and_sync(e) {
      if (false) {
        if (this.current_sfen === e.sfen && this.current_turn === e.turn) {
          this.toast_ok("同じ局面です")
          return
        }
      }

      const diff = e.turn - this.current_turn

      this.current_sfen = e.sfen
      this.current_turn = e.turn

      let message = null
      if (diff < 0) {
        message = `${this.user_call_name(this.user_name)}が${-diff}手戻しました`
      } else {
        message = `${this.user_call_name(this.user_name)}が${diff}手進めました`
      }
      this.force_sync(message)
    },

    ////////////////////////////////////////////////////////////////////////////////

    quick_sync(...args) {
      if (this.quick_sync_info.key === "is_quick_sync_on") {
        this.force_sync(...args)
      }
    },

    force_sync(message = "", options = {}) {
      const params = {
        message: message,
        sfen: this.current_sfen,
        turn: this.current_turn,
        silent_notify: false,   // 読み上げないようにする
        ...options,
      }
      this.perpetual_cop.reset()
      this.ac_room_perform("force_sync", params) // --> app/channels/share_board/room_channel.rb
    },
    force_sync_broadcasted(params) {
      {
        this.perpetual_cop.reset()
        this.sfen_share_data_receive(params)       // これで current_location が更新される
        this.se_force_sync()             // 他者は盤面変化に気付かないため音を出す→自分も含めて音出した方が自分にも親切だった
        if (this.received_from_self(params)) {
        } else {
        }
      }
      if (this.clock_box) {
        this.clock_box.location_to(this.current_location)
      }
      if (params.message) {
        if (params.silent_notify) {
          this.debug_alert("silent_notify")
          this.toast_ok(params.message, {talk: false, duration: 1000})
        } else {
          this.toast_ok(params.message)
        }
      }
      this.al_add({...params, label: `局面転送 #${params.turn}`})
    },
  },
}
