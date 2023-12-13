// |---------------------------------------------+---------------------------------------------|
// | Method                                      | 意味                                        |
// |---------------------------------------------+---------------------------------------------|
// | room_create_if_exist_room_code_in_url()     | URLに合言葉の指定があればそのまま部屋に入る |
// | room_setup_modal_open_handle()              | モーダル起動                                |
// | room_create_by(new_room_coe, new_user_name) | モーダル内で入力したものを渡す              |
// | room_create()                               | 入室                                        |
// | room_destroy()                              | 退室                                        |
// |---------------------------------------------+---------------------------------------------|

import _ from "lodash"
import dayjs from "dayjs"
import RoomSetupModal from "./RoomSetupModal.vue"
import { HandleNameValidator } from "@/components/models/handle_name/handle_name_validator.js"

export const mod_room_setup = {
  data() {
    return {
      ac_room: null,      // subscriptions.create のインスタンス
      ac_events_hash: {}, // ACのイベントが発生した回数を記録(デバッグ用)
      room_setup_modal_instance: null,
    }
  },
  mounted() {
    // this.name_setup()
    this.room_create_if_exist_room_code_in_url()
  },
  beforeDestroy() {
    this.room_setup_modal_close()
    this.room_destroy()
  },
  methods: {
    // URLに合言葉の指定があればそのまま部屋に入る
    room_create_if_exist_room_code_in_url() {
      // URLに合言葉がない場合は何もしない
      if (this.$gs.blank_p(this.$route.query.room_code)) {
        return
      }
      // 合言葉が復元できたとしても元々空であれば何もしない
      if (this.$gs.blank_p(this.room_code)) {
        return
      }
      // 名前が未入力または不正な場合はモーダルを表示する
      if (this.handle_name_invalid_then_toast_warn(this.user_name)) {
        this.room_setup_modal_open()
        return
      }
      // 合言葉と名前は問題ないので部屋に入る
      this.room_create()
    },

    ////////////////////////////////////////////////////////////////////////////////

    room_setup_modal_toggle_handle() {
      if (this.room_setup_modal_instance == null) {
        this.sidebar_p = false
        this.$sound.play_click()
        this.room_setup_modal_open()
        return true
      }
    },

    room_setup_modal_open_handle() {
      this.sidebar_p = false
      this.$sound.play_click()
      this.room_setup_modal_open()
    },

    room_setup_modal_close_handle() {
      this.sidebar_p = false
      this.$sound.play_click()
      this.room_setup_modal_close()
    },

    room_setup_modal_open() {
      this.room_setup_modal_close()
      this.room_setup_modal_instance = this.modal_card_open({
        component: RoomSetupModal,
        onCancel: () => {
          this.$sound.play_click()
          this.room_setup_modal_close()
        },
      })
    },

    room_setup_modal_close() {
      if (this.room_setup_modal_instance) {
        this.room_setup_modal_instance.close()
        this.room_setup_modal_instance = null
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    room_create_by(new_room_coe, new_user_name) {
      this.$gs.assert(new_user_name, "new_user_name")
      this.$gs.assert(new_room_coe, "new_room_coe")

      new_room_coe = _.trim(new_room_coe)
      new_user_name = _.trim(new_user_name)

      if (this.user_name !== new_user_name) {
        this.handle_name_set(new_user_name)
      }

      if (this.ac_room) {
        this.toast_warn("すでに入室しています")
        return
      }

      this.room_code = new_room_coe
      this.room_create()
      // this.toast_ok("入室しました")
    },

    room_create() {
      this.tl_alert("room_create")
      this.$gs.assert(this.user_name, "this.user_name")
      this.$gs.assert(this.room_code, "this.room_code")
      this.$gs.assert(this.ac_room == null, "this.ac_room == null")

      this.ga_click(`共有将棋盤 [${this.room_code}] 入室`)

      this.member_infos_init()
      this.member_info_init()
      this.active_level_init()
      this.perpetual_cop.reset()
      this.mh_room_entry()

      // ユーザーの操作に関係なくサーバーの負荷の問題で切断や再起動される場合があるためそれを考慮すること
      this.tl_add("USER", `subscriptions.create ${this.room_code}`)
      this.ac_room = this.ac_subscription_create({channel: "ShareBoard::RoomChannel", room_code: this.room_code}, {
        initialized: e => {
          this.ac_events_hash_inc("initialized")
          this.tl_add("HOOK", "initialized", e)
        },
        connected: e => {       // FIXME: 初回チェック
          this.ac_events_hash_inc("connected")
          this.tl_add("HOOK", "connected", e)
          this.ua_notify_once()                       // USER_AGENT を記録
          this.active_level_increment_timer.restart() // 切断後にアクティブレベルを上げないようにしているから復帰する
          this.setup_info_request()
          this.member_bc_restart()
          this.acquire_medal_count_share() // 自分のメダル数を伝える(これをしないと元からいる人は新人のメダル数がわからない)
        },
        disconnected: e => {
          this.ac_events_hash_inc("disconnected")
          this.tl_add("HOOK", "disconnected", e)
          this.active_level_increment_timer.stop() // 切断後にアクティブレベルを上げないようにする
        },
        rejected: e => {
          this.ac_events_hash_inc("rejected")
          this.tl_add("HOOK", "rejected", e)
        },
        received: e => {
          this.ac_events_hash_inc("received")
          // this.tl_add("HOOK", `received: ${e.bc_action}`, e)
          this.api_version_valid(e.bc_params.API_VERSION)
        },
      })
    },

    // 退室
    room_destroy() {
      if (this.ac_room) {
        this.tl_alert("room_destroy")

        this.mh_room_leave()

        this.room_leave()
        this.ac_unsubscribe("ac_room")
        this.tl_add("USER", "unsubscribe")

        this.perpetual_cop.reset()
        this.member_infos_init()
        this.active_level_init()
        this.active_level_increment_timer.stop()
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // perform のラッパーで共通のパラメータを入れる
    ac_room_perform(action, params = {}) {
      if (this.ac_room) {
        this.ac_room.perform(action, {
          ...this.ac_room_perform_default_params(),
          ...params,
        }) // --> app/channels/share_board/room_channel.rb
        // this.tl_add("USER", action)
      }
    },
    ac_room_perform_default_params() {
      const params = {
        from_connection_id: this.connection_id,      // 送信者識別子
        from_user_name:     this.user_name,          // 送信者名
        performed_at:       this.$time.current_ms(), // 実行日時(ms)
        ua_icon_key:        this.ua_icon_key,        // 端末の種類を表すアイコン文字列
        ac_events_hash:     this.ac_events_hash,     // イベント数(デバッグ用)
        debug_mode_p:       this.debug_mode_p,
      }
      if (this.g_current_user) {
        params.from_avatar_path = this.g_current_user.avatar_path
        params.real_user_id     = this.g_current_user.id
      }
      return params
    },

    // 自分で送信したものを受信した
    received_from_self(params) {
      return params.from_connection_id === this.connection_id
    },

    // 他者が送信したものを受信した
    received_from_other(params) {
      return !this.received_from_self(params)
    },

    ////////////////////////////////////////////////////////////////////////////////
    sfen_share_data_receive(params) {
      this.$gs.assert(this.$gs.present_p(params), "this.$gs.present_p(params)")
      this.$gs.assert("sfen" in params, '"sfen" in params')
      this.$gs.assert("turn" in params, '"turn" in params')

      this.current_sfen = params.sfen
      this.current_turn = params.turn

      if (this.debug_mode_p) {
        this.ac_log({subject: "局面受信", body: `${params.turn}手目の局面を受信`})
      }
    },

    // this.ac_log({subject: "a", body: "b", emoji: "c", level: "critical"})
    ac_log(params = {}) {
      this.ac_room_perform("ac_log", params)
    },

    ////////////////////////////////////////////////////////////////////////////////
    fake_error() {
      this.ac_room_perform("fake_error", {
        value: null,
      }) // --> app/channels/share_board/room_channel.rb
    },
    fake_error_broadcasted(params) {
    },

    ////////////////////////////////////////////////////////////////////////////////
    ac_events_hash_inc(key) {
      this.$set(this.ac_events_hash, key, (this.ac_events_hash[key] || 0) + 1)
    },

    ////////////////////////////////////////////////////////////////////////////////
    if_room_is_empty() {
      if (this.$gs.blank_p(this.ac_room)) {
        this.$sound.play_click()
        this.toast_warn("まず部屋を立てよう")
        return true
      }
    },
  },
  computed: {
    connection_id()   { return this.config.record.connection_id   }, // 自分と他者を区別するためのコード(タブが2つあればそれぞれ異なる)
    session_id()      { return this.config.record.session_id      }, // 同じタブから再度入ったとき同じになる
    session_counter() { return this.config.record.session_counter }, // セッションが動いていればリロードで+1される

    // 合言葉と名前が入力済みなので共有可能か？
    connectable_p() { return this.$gs.present_p(this.room_code) && this.$gs.present_p(this.user_name) },
  },
}
