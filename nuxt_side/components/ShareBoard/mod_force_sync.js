import { Gs } from "@/components/models/gs.js"
import ForceSyncModal from "./ForceSyncModal.vue"
import _ from "lodash"

// const CONFIRM_METHOD = false

export const mod_force_sync = {
  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    force_sync_modal_handle() {
      if (this.room_is_empty_p()) { return }
      this.sidebar_p = false
      this.sfx_click()
      this.modal_card_open({
        component: ForceSyncModal,
      })
    },

    ////////////////////////////////////////////////////////////////////////////////

    force_sync_direct() {
      this.ac_log({subject: "局面操作", body: `直接${this.current_turn}手目`})
      this.force_sync(`${this.user_call_name(this.user_name)}が局面を共有しました`)
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

    force_sync_preset() {
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

      if (this.ac_room) {
        let message = null
        if (diff < 0) {
          message = `"${this.user_call_name(this.user_name)}が${-diff}手戻しました`
        } else {
          message = `"${this.user_call_name(this.user_name)}が${diff}手進めました`
        }
        this.force_sync(message)
      }
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
        notify_mode: "fs_notify_all",
        ...options,
      }
      this.perpetual_cop.reset()
      this.ac_room_perform("force_sync", params) // --> app/channels/share_board/room_channel.rb
    },
    force_sync_broadcasted(params) {
      {
        this.perpetual_cop.reset()
        this.sfen_share_data_receive(params)       // これで current_location が更新される
      }
      if (this.clock_box) {
        this.clock_box.location_to(this.current_location)
      }

      // 他者は盤面変化に気付かないため音を出す？
      // →自分も含めて音出した方が自分にも親切だった
      // →やっぱやめ
      // →自分で操作した場合、自分はわかっているので通知しない
      // if (this.received_from_self(params)) {
      //   // 自分→自分
      // } else {
      //   // 自分→他者
      // }

      // if (this.received_from_self(params)) {
      //   // 自分→自分
      // } else {
      //   // 自分→他者
      if (params.message) {
        if (params.notify_mode === "fs_notify_all") { // 全員
          this.se_force_sync()
          this.toast_ok(params.message, {talk: false})
        } else if (params.notify_mode === "fs_notify_without_self") { // 自分を除く
          if (!this.received_from_self(params)) {
            this.se_force_sync()
            this.toast_ok(params.message, {talk: false}) // 大勢で検討しているときにうるさいのでしゃべらない
          }
          // this.debug_alert("fs_notify_without_self")
          // this.toast_ok(params.message, {talk: false, duration: 1000})
        } else {
          throw new Error("must not happen")
        }
      }

      this.al_add({...params, label: `局面転送 #${params.turn}`})
    },
  },
}
