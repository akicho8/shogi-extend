import { GX } from "@/components/models/gx.js"
import _ from "lodash"
import { turn_change } from "./turn_change.js"
import { ReflectorNotifyScopeInfo } from "./reflector_notify_scope_info.js"
import { TurnProgress } from "./turn_progress.js"

export const mod_reflector = {
  mixins: [
    turn_change,
  ],

  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    // 「初期配置に戻す」
    reflector_turn_zero_handle() {
      this.reflector_turn_change({to: 0})
    },
    // reflector_turn_zero() {
    //   this.reflector_turn_change({to: 0})
    // },

    // 「一手戻す」
    reflector_turn_previous_handle() {
      this.reflector_turn_change({by: -1})
    },
    // reflector_turn_previous() {
    //   this.reflector_turn_change({by: -1})
    // },

    reflector_turn_change(options = {}) {
      // if (options.sfx) {
      //   this.sfx_click()
      // }
      const turn_progress = TurnProgress.create({current: this.current_turn, ...options})
      this.reflector_call({turn: turn_progress.new_value, think_mark_clear_all: true})
    },

    ////////////////////////////////////////////////////////////////////////////////

    reflector_slider_trailing() {
      // turn を指定した場合: 「|←」を押してすぐに1手目を指しても1秒後に0手目に戻ってしまう
      // スライダーで指定した turn が重要なのではなくスライダーを動かした1秒後の状態が必要なだけなので turn は見なくてよい
      this.reflector_call({
        talk: false,                                                        // マサさんがやかましいというので静かにする https://twitter.com/Sushikuine_24/status/1522370383131062272
        reflector_notify_scope_key: this.slider_reflector_notify_scope_key, // さらに、そもそも通知は自分には行なわない
        set_except_me: true,                                                // (自分側は更新済みなので)自分は更新するな
      })
    },

    ////////////////////////////////////////////////////////////////////////////////

    reflector_call(params = {}) {
      this.reflector_action(params)
    },
    reflector_action(params = {}) {
      GX.assert_kind_of_hash(params)
      params = {
        __standalone_mode__: true,
        reflector_notify_scope_key: "rns_all", // 全員に通知する
        talk: true,                            // しゃべる
        sfx: true,                             // 設定音を出す
        set_except_me: false,                  // sfen, turn の更新: true→全員 false→自分自身に対してはしない
        ...this.current_sfen_and_turn,
        think_mark_clear_all: false,           // ブロードキャストのタイミングで思考印を消すか？
        ...params,
      }
      this.ac_room_perform("reflector_action", params) // --> app/channels/share_board/room_channel.rb
    },
    reflector_action_broadcasted(params) {
      const turn_progress = TurnProgress.create({current: this.current_turn, to: params.turn})
      const reflector_notify_scope_info = ReflectorNotifyScopeInfo.fetch(params.reflector_notify_scope_key)
      this.reflector_notify({params, turn_progress, reflector_notify_scope_info})
      this.reflector_set({params})
      this.reflector_label({params, turn_progress})
      this.reflector_chore({params})
    },
    reflector_notify({params, turn_progress, reflector_notify_scope_info}) {
      let message = params.message ?? turn_progress.past_message
      if (message != null) {
        if (this.ac_room) {
          if (params.from_user_name) {
            message = [this.user_call_name(params.from_user_name), "が", message].join("")
          }
        }
        if (reflector_notify_scope_info.condition_fn(this, params)) {
          this.toast_primary(message, {talk: params.talk})
        }
      }
    },
    reflector_set({params}) {
      if (params.set_except_me && this.received_from_self(params)) {
        this.debug_alert(`REFLECT: #${params.turn} SKIP`)
        return
      }
      this.debug_alert(`REFLECT: #${params.turn} SET`)
      if (params.sfx) {
        this.se_reflector()
      }
      this.sfen_sync_dto_receive(params)       // これで current_location が更新される
      if (this.clock_box) {
        this.clock_box.location_to(this.current_location)
      }

      this.perpetual_cop.reset$() // ここでいいのか？？？
    },
    reflector_label({params, turn_progress}) {
      const label = params.label ?? turn_progress.label
      this.xhistory_add({...params, label})
    },
    reflector_chore({params}) {
      if (params.think_mark_clear_all) {
        this.think_mark_clear_all()
      }
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
    ReflectorNotifyScopeInfo() { return ReflectorNotifyScopeInfo },
  },
}
