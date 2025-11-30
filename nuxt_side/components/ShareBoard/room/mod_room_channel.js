// |-----------------------------------------------------+-----------------------------------------|
// | Method                                              | 意味                                    |
// |-----------------------------------------------------+-----------------------------------------|
// | room_create_if_exist_room_key_in_url()              | URLに合言葉の指定があればそのまま入退室 |
// | room_create_from_modal(new_room_key, new_user_name) | モーダル内で入力したものを渡す          |
// | room_create()                                       | 入室                                    |
// | room_destroy()                                      | 退室                                    |
// |-----------------------------------------------------+-----------------------------------------|

import _ from "lodash"
import { GX } from "@/components/models/gx.js"
import dayjs from "dayjs"
import { HandleNameNormalizer } from "@/components/models/handle_name/handle_name_normalizer.js"

export const mod_room_channel = {
  data() {
    return {
      ac_room: null,      // subscriptions.create のインスタンス
      ac_events_hash: {}, // ACのイベントが発生した回数を記録(デバッグ用)
      offline_check_show: false,
    }
  },
  mounted() {
    this.room_create_if_exist_room_key_in_url()
  },
  beforeDestroy() {
    this.room_destroy()
  },
  methods: {
    // URLに合言葉の指定があればそのまま入退室
    async room_create_if_exist_room_key_in_url() {
      // URLに合言葉がない場合は何もしない
      if (!this.url_room_key_exist_p) {
        return
      }

      // 合言葉が復元できたとしても元々空であれば何もしない
      if (GX.blank_p(this.room_key)) {
        return
      }

      // 名前が未入力または不正な場合はモーダルを表示する
      if (this.handle_name_invalid_then_show(this.user_name)) {
        this.gate_modal_open()
        return
      }

      if (this.url_room_key_exist_behavior === "modal_open") {
        this.gate_modal_open()
        return
      }

      // 合言葉と名前は問題ないので入退室
      await this.room_restore_call()
      this.room_create()
    },

    ////////////////////////////////////////////////////////////////////////////////

    async room_create_from_modal(new_room_key, new_user_name) {
      GX.assert(this.ac_room == null)
      GX.assert(new_user_name, "new_user_name")
      GX.assert(new_room_key, "new_room_key")

      new_room_key = _.trim(new_room_key)
      new_user_name = HandleNameNormalizer.normalize(new_user_name)

      this.room_key = new_room_key
      this.user_name = new_user_name

      // if (this.ac_room) {
      //   this.toast_warn("すでに入室しています")
      //   return
      // }

      await this.room_restore_call()
      this.room_create()
      // this.toast_primary("入室しました")
    },

    // ~/src/shogi-extend/app/channels/share_board/room_channel.rb
    async room_create() {
      this.tl_p("--> room_create")
      GX.assert(this.user_name, "this.user_name")
      GX.assert(this.room_key, "this.room_key")
      GX.assert(this.ac_room == null, "this.ac_room == null")

      await GX.sleep(this.room_create_delay)

      this.room_keys_update_and_save_to_storage()

      this.member_infos_init()
      this.member_info_init()
      this.active_level_init()
      this.perpetual_cop.reset()
      this.mh_room_entry()
      this.xprofile_entry()

      // ユーザーの操作に関係なくサーバーの負荷の問題で切断や再起動される場合があるためそれを考慮すること
      this.tl_add("USER", `subscriptions.create ${this.room_key}`)
      this.ac_room = this.ac_subscription_create({channel: "ShareBoard::RoomChannel", room_key: this.room_key}, {
        initialized: e => {
          this.ac_events_hash_inc("initialized")
          this.tl_add("HOOK", "initialized", e)
        },
        connected: e => {
          if (!e.reconnected) {
            // 初回
            this.ac_events_hash_inc("connected")
            this.tl_add("HOOK", "connected", e)
          } else {
            // 次から
            this.ac_events_hash_inc("reconnected")
            this.tl_add("HOOK", "reconnected", e)
          }
          this.xprofile_load()
          this.ua_notify_once()                       // USER_AGENT を記録
          this.active_level_increment_timer.restart() // 切断後にアクティブレベルを上げないようにしているから復帰する
          this.setup_info_request()
          this.member_bc_restart()
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
          this.api_version_validate(e.bc_params.SERVER_SIDE_API_VERSION)
        },
      })
      this.autoexec({key: "room_after_create"})
      this.tl_p("<-- room_create")
    },

    room_destroy_handle() {
      if (this.ac_room) {
        this.room_destroy()
        this.toast_primary("退室しました")
      }
    },

    // 退室
    room_destroy() {
      if (this.ac_room) {
        this.tl_p("room_destroy")

        this.mh_room_leave()

        this.room_leave_share()
        this.ac_unsubscribe("ac_room")
        this.tl_add("USER", "unsubscribe")

        this.perpetual_cop.reset()
        this.member_infos_leave()
        this.active_level_init()
        this.active_level_increment_timer.stop()
        this.xprofile_leave()
        this.order_leave()
        this.cc_destroy()
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
        client_token:         this.client_token,         // 同じブラウザで何度アクセスしても同じ
        from_connection_id: this.connection_id,      // 同じブラウザで来訪するたびに変わる
        from_user_name:     this.user_name,          // 送信者名
        performed_at:       this.$time.current_ms(), // 実行日時(ms)
        ua_icon_key:        this.ua_icon_key,        // 端末の種類を表すアイコン文字列
        ac_events_hash:     this.ac_events_hash,     // イベント数(デバッグ用)
        debug_mode_p:       this.debug_mode_p,
        user_selected_avatar:        this.user_selected_avatar,
      }
      if (this.g_current_user) {
        params.session_user_id  = this.g_current_user.id
      }
      if (this.selfie_image_path) {
        params.from_avatar_path = this.selfie_image_path
      }
      return params
    },

    // 自分で送信したものを受信した
    received_from_self(object) {
      GX.assert("from_connection_id" in object, '"from_connection_id" in object')
      return object.from_connection_id === this.connection_id
    },

    // 他者が送信したものを受信した
    received_from_other(object) {
      return !this.received_from_self(object)
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
      if (GX.blank_p(this.ac_room)) {
        this.sfx_click()
        this.toast_warn("まず部屋を立てよう")
        return true
      }
    },

    ////////////////////////////////////////////////////////////////////////////////
  },
  computed: {
    connection_id()   { return this.config.record.connection_id   }, // 自分と他者を区別するためのコード(タブが2つあればそれぞれ異なる)
    client_token()      { return this.config.record.client_token      }, // 同じタブから再度入ったとき同じになる
    session_counter() { return this.config.record.session_counter }, // セッションが動いていればリロードで+1される

    // 合言葉と名前が入力済みなので共有可能か？ (未使用)
    connectable_p() { return GX.present_p(this.room_key) && GX.present_p(this.user_name) },

    url_room_key()         { return this.$route.query["room_key"] },   // URL 上の合言葉
    url_room_key_exist_p() { return GX.present_p(this.url_room_key) }, // URL 上の合言葉があるか？

    // プロフィール画像
    selfie_image_path() {
      if (this.g_current_user) {
        if (this.AppConfig.avatar.profile_image_first_use) {
          return this.g_current_user.avatar_path
        }
      }
    },
  },
}
