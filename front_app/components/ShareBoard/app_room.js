import _ from "lodash"
import dayjs from "dayjs"

export const app_room = {
  data() {
    return {
      room_code: this.config.record.room_code, // リアルタイム共有合言葉
      user_code: this.config.record.user_code, // 自分と他者を区別するためのコード
    }
  },
  mounted() {
    this.ls_setup() // user_name の復帰

    if (this.room_code) {
      if (this.user_name) {
        // 合言葉設定済みURLから来て名前は設定しているのですぐに共有する
        this.room_setup()
      } else {
        // 合言葉設定済みURLから来て名前は設定していない
        this.toast_ok("リアルタイム共有で使うあなたのハンドルネームを入力してください")
        this.room_code_edit()
      }
    } else {
      // 通常の起動
    }
  },
  beforeDestroy() {
    if (this.room_code) {
      this.toast_ok("共有を解除しました")
    }
    this.room_unsubscribe()
  },
  methods: {
    room_code_set(room_code, user_name) {
      let changed_p = false

      room_code = _.trim(room_code)
      if (this.room_code != room_code) {
        this.room_code = room_code
        changed_p = true
        if (this.room_code) {
          this.toast_ok("合言葉を設定しました")
        } else {
          this.toast_ok("合言葉を削除して退室しました")
        }
      }

      user_name = _.trim(user_name)
      if (this.user_name != user_name) {
        this.user_name = user_name
        if (this.$ac_room) {
          if (this.development_p) {
            this.toast_ok("名前を変更したので次の通知を待たずにすぐブロードキャストする")
          }
          this.member_share()
        }
      }

      if (changed_p) {
        this.room_unsubscribe() // 内容が変更になったかもしれないのでいったん解除
        if (this.room_code) {
          this.room_setup()
        }
      }
    },

    room_setup() {
      this.__assert__(this.user_name, "this.user_name")
      this.__assert__(this.room_code, "this.room_code")

      this.member_infos_clear()
      this.room_unsubscribe()
      this.__assert__(this.$ac_room == null, "this.$ac_room == null")
      this.$ac_room = this.ac_subscription_create({channel: "ShareBoard::RoomChannel", room_code: this.room_code}, {
        connected: () => {
          this.idol_timer_start()
          this.board_info_request()
          this.member_bc_interval_runner.restart()
        },
        disconnected: () => {
          if (this.development_p) {
            this.toast_ok("部屋を解放しました")
          }
        },
      })
    },

    room_unsubscribe() {
      this.ac_unsubscribe("$ac_room")
    },

    // perform のラッパーで共通のパラメータを入れる
    ac_room_perform(action, params = {}) {
      params = Object.assign({}, {
        from_user_code: this.user_code, // 送信者識別子
        from_user_name: this.user_name, // 送信者名
        performed_at: dayjs().unix(),   // 実行日時
        revision: this.$revision,       // 古参レベル
      }, params)

      if (this.$ac_room) {
        this.$ac_room.perform(action, params) // --> app/channels/share_board/room_channel.rb
      }
    },

    ////////////////////////////////////////////////////////////////////////////////
    sfen_share() {
      this.ac_room_perform("sfen_share", {
        title: this.current_title,
        ...this.current_sfen_attrs,
      }) // --> app/channels/share_board/room_channel.rb
    },
    sfen_share_broadcasted(params) {
      if (params.from_user_code === this.user_code) {
        // 自分から自分へ
      } else {
        this.attributes_set(params)
      }
      this.toast_ok(`${params.from_user_name}さんが${params.turn_offset}手目を指しました`)
      this.al_add(params)
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
        this.attributes_set(params)
        this.toast_ok(`タイトルを${params.title}に変更しました`)
      }
    },

    ////////////////////////////////////////////////////////////////////////////////
    attributes_set(params) {
      if (params.title) {
        this.current_title = params.title
      }
      if (params.sfen) {
        this.current_sfen = params.sfen
        this.turn_offset = params.turn_offset
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
  },
  computed: {
    share_p() { return this.room_code != "" },

    ////////////////////////////////////////////////////////////////////////////////
    current_sfen_attrs() {
      return {
        sfen:                        this.current_sfen,
        turn_offset:                 this.current_sfen_info.turn_offset_max,
        performed_last_location_key: this.current_sfen_info.performed_last_location.key,
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
    share_board_with_room_code_url() {
      const url = new URL(this.$config.MY_SITE_URL + `/share-board`)
      if (this.room_code) {
        url.searchParams.set("room_code", this.room_code)
      }
      return url.toString()
    },

  },
}
