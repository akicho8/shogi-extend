import _ from "lodash"
import dayjs from "dayjs"
import RoomSetupModal              from "./RoomSetupModal.vue"

export const app_room_setup = {
  data() {
    return {
      // room_code: this.config.record.room_code, // リアルタイム共有合言葉
      room_code: null,         // 合言葉
      ac_room: null,           // subscriptions.create のインスタンス
      ac_events_hash: {},      // ACのイベントが発生した回数を記録(デバッグ用)
    }
  },
  mounted() {
    if (true) {
      this.room_code = this.$route.query.room_code || this.room_code

      // 名前の優先順位
      // 1. query.user_name         (URL引数)
      // 2. query.default_user_name (URL引数)
      // 3. g_current_user_name     (ログイン名)
      this.user_name = this.$route.query.force_user_name || this.user_name
    }

    if (this.room_code) {
      if (!this.base.handle_name_validate(this.user_name)) {
        // 合言葉設定済みURLから来て名前は設定していない
        this.room_setup_modal_handle()
        return
      }
      // 合言葉設定済みURLから来て名前は設定しているのですぐに共有する
      this.room_create()
    } else {
      // 通常の起動
      if (this.development_p) {
        // this.room_code_set("__room_code__", "alice")
      }
    }
  },
  beforeDestroy() {
    this.room_destroy()
  },
  methods: {
    room_setup_modal_handle() {
      this.sidebar_p = false
      this.sound_play_click()
      this.modal_card_open({
        component: RoomSetupModal,
        props: { base: this.base },
      })
    },

    room_code_set(room_code, user_name) {
      this.__assert__(user_name, "user_name")
      this.__assert__(room_code, "room_code")

      room_code = _.trim(room_code)
      user_name = _.trim(user_name)

      if (this.user_name !== user_name) {
        this.handle_name_set(user_name)
      }

      if (this.ac_room) {
        this.toast_warn("すでに入室しています")
        return
      }

      this.room_code = room_code
      this.room_create()
      // this.toast_ok("入室しました")
    },

    room_create() {
      this.tl_alert("room_create")
      this.__assert__(this.user_name, "this.user_name")
      this.__assert__(this.room_code, "this.room_code")
      this.__assert__(this.ac_room == null, "this.ac_room == null")

      this.ga_click(`共有将棋盤 [${this.room_code}] 入室`)

      this.member_infos_init()
      this.member_info_init()
      this.active_level_init()

      // ユーザーの操作に関係なくサーバーの負荷の問題で切断や再起動される場合があるためそれを考慮すること
      this.tl_add("USER", `subscriptions.create ${this.room_code}`)
      this.ac_room = this.ac_subscription_create({channel: "ShareBoard::RoomChannel", room_code: this.room_code}, {
        initialized: e => {
          this.ac_events_hash_inc("initialized")
          this.tl_add("HOOK", "initialized", e)
        },
        connected: e => {
          this.ac_events_hash_inc("connected")
          this.tl_add("HOOK", "connected", e)
          this.ua_notify_once()                       // USER_AGENT を記録
          this.active_level_increment_timer.restart() // 切断後にアクティブレベルを上げないようにしているから復帰する
          this.setup_info_request()
          this.member_info_bc_restart()
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

    room_destroy() {
      if (this.ac_room) {
        this.tl_alert("room_destroy")

        this.room_leave()
        this.ac_unsubscribe("ac_room")
        this.tl_add("USER", "unsubscribe")

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
        from_connection_id: this.connection_id,     // 送信者識別子
        from_user_name:     this.user_name,         // 送信者名
        performed_at:       this.time_current_ms(), // 実行日時(ms)
        active_level:       this.active_level,      // 先輩度(高い方が信憑性のある情報)
        ua_icon_key:            this.ua_icon_key,           // 端末の種類を表すアイコン文字列
        ac_events_hash:     this.ac_events_hash,    // イベント数(デバッグ用)
      }
      if (this.g_current_user) {
        params.from_avatar_path = this.g_current_user.avatar_path
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
    title_share(share_sfen) {
      this.ac_room_perform("title_share", {
        title: this.current_title,
      }) // --> app/channels/share_board/room_channel.rb
    },
    title_share_broadcasted(params) {
      if (this.received_from_self(params)) {
        // 自分から自分へ
      } else {
        this.setup_by_params(params)
      }
      this.toast_ok(`${this.user_call_name(params.from_user_name)}がタイトルを${params.title}に変更しました`)
    },

    ////////////////////////////////////////////////////////////////////////////////
    setup_by_params(params) {
      if ("title" in params) {
        this.current_title = params.title
      }
      if ("sfen" in params) {
        this.current_sfen = params.sfen
        this.turn_offset = params.turn_offset
      }
      if ("ordered_p" in params) {
        this.om_vars_copy_all_from(params)
      }
    },

    ////////////////////////////////////////////////////////////////////////////////
    ac_log(subject = "", body = "") {
      this.ac_room_perform("ac_log", { subject, body })
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
      this.ac_events_hash[key] = (this.ac_events_hash[key] || 0) + 1
    },
  },
  computed: {
    // 自分と他者を区別するためのコード(タブが2つあればそれぞれ異なる)
    connection_id() { return this.config.record.connection_id },

    // 合言葉と名前が入力済みなので共有可能か？
    connectable_p() { return this.present_p(this.room_code) && this.present_p(this.user_name) },
  },
}
