import _ from "lodash"
import dayjs from "dayjs"
import RoomSetupModal              from "./RoomSetupModal.vue"

export const app_room_setup = {
  data() {
    return {
      // room_code: this.config.record.room_code, // リアルタイム共有合言葉
      room_code: null, // リアルタイム共有合言葉
      ac_room: null,
    }
  },
  mounted() {
    this.ls_setup() // user_name の復帰

    if (this.$route.query.room_code) {
      this.room_code = this.$route.query.room_code
    }

    if (this.$route.query.force_user_name) {
      this.user_name = this.$route.query.force_user_name
    }

    if (this.room_code) {
      if (this.user_name) {
        // 合言葉設定済みURLから来て名前は設定しているのですぐに共有する
        this.room_create()
      } else {
        // 合言葉設定済みURLから来て名前は設定していない
        this.toast_ok("ハンドルネームを入力してください")
        this.room_setup_modal_handle()
      }
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
      this.sound_play("click")

      this.$buefy.modal.open({
        component: RoomSetupModal,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        canCancel: true,
        onCancel: () => { this.sound_play("click") },
        props: { base: this.base },
      })
    },

    room_code_set(room_code, user_name) {
      this.__assert__(user_name, "user_name")
      this.__assert__(room_code, "room_code")

      room_code = _.trim(room_code)
      user_name = _.trim(user_name)

      if (this.user_name !== user_name) {
        this.user_name = user_name
        if (this.ac_room) {
          this.member_info_bc_restart() // ハンドルネームの変更すぐに反映するため
        }
      }

      if (this.ac_room) {
        this.toast_warn("すでに入室しています")
        return
      }

      this.room_code = room_code
      this.room_create()
      this.toast_ok("入室しました")
    },

    room_create() {
      this.debug_alert("room_create")
      this.__assert__(this.user_name, "this.user_name")
      this.__assert__(this.room_code, "this.room_code")
      this.__assert__(this.ac_room == null, "this.ac_room == null")

      this.ga_click(`共有将棋盤 [${this.room_code}] 入室`)

      this.member_infos_init()
      this.member_info_init()
      this.active_level_init()

      // ユーザーの操作に関係なくサーバーの負荷の問題で切断や再接続される場合があるためそれを考慮すること
      this.tl_add("USER", `subscriptions.create ${this.room_code}`)
      this.ac_room = this.ac_subscription_create({channel: "ShareBoard::RoomChannel", room_code: this.room_code}, {
        connected: (e) => {
          this.tl_add("HOOK", "connected", e)
          this.active_level_increment_timer.restart()
          this.setup_info_request()
          this.member_info_bc_restart()
        },
        disconnected: () => {
          this.tl_add("HOOK", "disconnected")
          this.active_level_increment_timer.stop() // 切断されているときはアクティブなレベルを上げないようにする
        },
        rejected: () => {
          this.tl_add("HOOK", "rejected")
        },
        received: e => {
          // this.tl_add("HOOK", `received: ${e.bc_action}`, e)
          this.api_version_valid(e.bc_params.API_VERSION)
        },
      })
    },

    room_destroy() {
      if (this.ac_room) {
        this.debug_alert("room_destroy")

        this.ac_unsubscribe("ac_room")
        this.tl_add("USER", "unsubscribe")

        this.member_infos_init()
        this.active_level_init()
        this.active_level_increment_timer.stop()
      }
    },

    // perform のラッパーで共通のパラメータを入れる
    ac_room_perform(action, params = {}) {
      params = {
        from_user_code: this.user_code,         // 送信者識別子
        from_user_name: this.user_name,         // 送信者名
        performed_at:   this.time_current_ms(), // 実行日時(ms)
        active_level:   this.active_level,      // 先輩度(高い方が信憑性のある情報)
        ...params,
      }
      if (this.ac_room) {
        this.ac_room.perform(action, params) // --> app/channels/share_board/room_channel.rb
        // this.tl_add("USER", action)
      }
    },

    ////////////////////////////////////////////////////////////////////////////////
    title_share(share_sfen) {
      this.ac_room_perform("title_share", {
        title: this.current_title,
      }) // --> app/channels/share_board/room_channel.rb
    },
    title_share_broadcasted(params) {
      if (params.from_user_code === this.user_code) {
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
      if ("order_func_p" in params) {
        this.om_vars_copy_from(params)
      }
    },

    ////////////////////////////////////////////////////////////////////////////////
    room_code_url_copy_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      if (!this.room_code) {
        this.toast_warn("まだ合言葉を設定してません")
        return
      }
      this.clipboard_copy({text: this.share_board_with_room_code_url})
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
  },
  computed: {
    // 自分と他者を区別するためのコード(タブが2つあればそれぞれ異なる)
    user_code() { return this.config.record.user_code },

    // 合言葉と名前が入力済みなので共有可能か？
    connectable_p() { return this.present_p(this.room_code) && this.present_p(this.user_name) },

    ////////////////////////////////////////////////////////////////////////////////
    current_sfen_attrs() {
      return {
        sfen:              this.current_sfen,
        turn_offset:       this.current_sfen_info.turn_offset_max, // これを入れない方が早い？
        last_location_key: this.current_sfen_info.last_location.key,
      }
    },
    current_sfen_info() {
      return this.sfen_parse(this.current_sfen)
    },
    current_sfen_turn_offset() {
      return this.current_sfen_info.turn_offset_max
    },
    ////////////////////////////////////////////////////////////////////////////////

    // 合言葉だけを付与したURL
    // といいつつタイトルあれば含める
    share_board_with_room_code_url() {
      const url = new URL(this.$config.MY_SITE_URL + `/share-board`)
      if (this.room_code) {
        url.searchParams.set("room_code", this.room_code)
        if (this.present_p(this.current_title)) {
          url.searchParams.set("title", this.current_title)
        }
      }
      return url.toString()
    },
  },
}
