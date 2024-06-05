// |---------------------------------------------+---------------------------------------------|
// | Method                                      | 意味                                        |
// |---------------------------------------------+---------------------------------------------|
// | room_create_if_exist_room_key_in_url()      | URLに合言葉の指定があればそのまま部屋に入る |
// | rsm_open_handle()                           | モーダル起動                                |
// | room_create_by(new_room_key, new_user_name) | モーダル内で入力したものを渡す              |
// | room_create()                               | 入室                                        |
// | room_destroy()                              | 退室                                        |
// |---------------------------------------------+---------------------------------------------|

import _ from "lodash"
import { Gs } from "@/components/models/gs.js"
import dayjs from "dayjs"

export const mod_room_cable = {
  data() {
    return {
      ac_room: null,      // subscriptions.create のインスタンス
      ac_events_hash: {}, // ACのイベントが発生した回数を記録(デバッグ用)
    }
  },
  mounted() {
    this.room_create_if_exist_room_key_in_url()
  },
  beforeDestroy() {
    this.room_destroy()
  },
  methods: {
    // URLに合言葉の指定があればそのまま部屋に入る
    room_create_if_exist_room_key_in_url() {
      if (true) {
        // URLに合言葉がない場合は何もしない
        if (this.url_room_key_blank_p) {
          return
        }

        // 合言葉が復元できたとしても元々空であれば何もしない
        if (Gs.blank_p(this.room_key)) {
          return
        }

        // 名前が未入力または不正な場合はモーダルを表示する
        if (this.handle_name_invalid_then_toast_warn(this.user_name)) {
          this.rsm_open()
          return
        }
      }

      // 合言葉と名前は問題ないので部屋に入る
      this.room_create()
    },

    ////////////////////////////////////////////////////////////////////////////////

    room_create_by(new_room_key, new_user_name) {
      Gs.assert(new_user_name, "new_user_name")
      Gs.assert(new_room_key, "new_room_key")

      new_room_key = _.trim(new_room_key)
      new_user_name = _.trim(new_user_name)

      if (this.user_name !== new_user_name) {
        this.handle_name_set(new_user_name)
      }

      if (this.ac_room) {
        this.toast_warn("すでに入室しています")
        return
      }

      this.room_key = new_room_key
      this.room_create()
      // this.toast_ok("入室しました")
    },

    room_create() {
      this.tl_alert("room_create")
      Gs.assert(this.user_name, "this.user_name")
      Gs.assert(this.room_key, "this.room_key")
      Gs.assert(this.ac_room == null, "this.ac_room == null")

      this.room_keys_update_and_save_to_storage()

      this.member_infos_init()
      this.member_info_init()
      this.active_level_init()
      this.perpetual_cop.reset()
      this.mh_room_entry()

      // ユーザーの操作に関係なくサーバーの負荷の問題で切断や再起動される場合があるためそれを考慮すること
      this.tl_add("USER", `subscriptions.create ${this.room_key}`)
      this.ac_room = this.ac_subscription_create({channel: "ShareBoard::RoomChannel", room_key: this.room_key}, {
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
          this.acquire_badge_count_share() // 自分のメダル数を伝える(これをしないと元からいる人は新人のメダル数がわからない)
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
        this.ac_room.perform(action, this.ac_room_perform_params_wrap(params)) // --> app/channels/share_board/room_channel.rb
      }
    },
    ac_room_perform_params_wrap(params) {
      return {
        ...this.ac_room_perform_default_params(),
        ...params,
      }
    },
    // 共有時の共通情報
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
        params.session_user_id     = this.g_current_user.id
      }
      return params
    },

    // 自分で送信したものを受信した
    received_from_self(object) {
      Gs.assert("from_connection_id" in object, '"from_connection_id" in object')
      return object.from_connection_id === this.connection_id
    },

    // 他者が送信したものを受信した
    received_from_other(object) {
      return !this.received_from_self(object)
    },

    ////////////////////////////////////////////////////////////////////////////////
    sfen_share_data_receive(params) {
      Gs.assert(Gs.present_p(params), "Gs.present_p(params)")
      Gs.assert("sfen" in params, '"sfen" in params')
      Gs.assert("turn" in params, '"turn" in params')

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
    room_is_empty_p() {
      if (Gs.blank_p(this.ac_room)) {
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
    connectable_p() { return Gs.present_p(this.room_key) && Gs.present_p(this.user_name) },

    url_room_key()            { return this.$route.query["room_key"] ?? this.$route.query["room_code"] }, // 合言葉の値 (URL限定)
    url_room_key_blank_p() { return Gs.blank_p(this.url_room_key)                                 }, // 合言葉の値 (URL限定) が空か？
  },
}
