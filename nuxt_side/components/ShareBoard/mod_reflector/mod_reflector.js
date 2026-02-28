import { GX } from "@/components/models/gx.js"
import _ from "lodash"
import { turn_change } from "./turn_change.js"
import { FooInfo } from "./foo_info.js"
import { TurnProgress } from "./turn_progress.js"

export const mod_reflector = {
  mixins: [
    turn_change,
  ],

  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    reflector_turn_zero_handle() {
      this.reflector_turn_change({to: 0, sfx: true})
    },
    reflector_turn_zero() {
      this.reflector_turn_change({to: 0})
    },
    reflector_turn_previous_handle() {
      this.reflector_turn_change({by: -1, sfx: true})
    },
    reflector_turn_previous() {
      this.reflector_turn_change({by: -1})
    },

    reflector_turn_change(options = {}) {
      const turn_progress = TurnProgress.create({current: this.current_turn, ...options})
      if (options.sfx) {
        this.sfx_click()
      }
      this.ac_log({subject: "局面操作", body: turn_progress.diff})
      const message = `${this.my_call_name}が${turn_progress.message}`
      const reflector_options = {
        turn: turn_progress.new_value,
      }
      this.reflector_call(message, reflector_options)
    },

    ////////////////////////////////////////////////////////////////////////////////

    reflector_call(...args) {
      this.reflector_action(...args)
    },
    reflector_action(message = "", options = {}) {
      const params = {
        __standalone_mode__: true,
        message: message,
        ...this.current_sfen_and_turn,
        notify_mode: "fs_notify_all",
        ...options,
      }
      // this.perpetual_cop.reset$()
      this.ac_room_perform("reflector_action", params) // --> app/channels/share_board/room_channel.rb
    },
    reflector_action_broadcasted(params) {
      {
        this.think_mark_all_clear()              // 思考印消去
        this.perpetual_cop.reset$()
        this.sfen_sync_dto_receive(params)       // これで current_location が更新される
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
          this.se_reflector()
          this.toast_primary(params.message, {talk: false})
        } else if (params.notify_mode === "fs_notify_without_self") { // 自分を除く
          if (!this.received_from_self(params)) {
            this.se_reflector()
            this.toast_primary(params.message, {talk: false}) // 大勢で検討しているときにうるさいのでしゃべらない
          }
        } else {
          throw new Error("must not happen")
        }
      }

      this.al_add({...params, label: `局面転送 #${params.turn}`})
    },

    ////////////////////////////////////////////////////////////////////////////////
    sfen_sync_dto_receive(params) {
      GX.assert(GX.present_p(params), "GX.present_p(params)")
      GX.assert("sfen" in params, '"sfen" in params')
      GX.assert("turn" in params, '"turn" in params')

      this.current_sfen_set(params)

      if (this.debug_mode_p) {
        this.ac_log({subject: "局面受信", body: `${params.turn}手目の局面を受信`})
      }
    },
  },

  computed: {
    FooInfo() { return FooInfo },
  },
}
