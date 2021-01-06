import _ from "lodash"

export const app_room = {
  data() {
    return {
      room_code: "",                           // リアルタイム共有合言葉
      user_code: this.config.record.user_code, // 自分と他者を区別するためのコード
      // $ac_room: null,
    }
  },
  mounted() {
    this.ls_setup()
    this.room_code_set(this.config.record.room_code, {noify_skip: true})
  },
  methods: {
    room_code_set(room_code, options = {}) {
      options = {
        noify_skip: false,
        ...options,
      }

      room_code = _.trim(room_code)
      const changed_p = this.room_code != room_code
      this.room_code = room_code

      if (options.noify_skip) {
        // mounted でのタイミングでは skip する
      } else {
        if (changed_p) {
          if (this.room_code) {
            this.toast_ok(`合言葉を設定しました`)
          } else {
            this.toast_ok("合言葉を削除しました")
          }
        }
      }

      if (changed_p) {
        this.room_unsubscribe() // 内容が変更になったかもしれないのでいったん解除
        if (this.room_code) {
          this.room_setup(options)
        }
      }
    },

    room_setup(options = {}) {
      this.room_unsubscribe()
      this.__assert__(this.$ac_room == null, "this.$ac_room == null")
      this.$ac_room = this.ac_subscription_create({channel: "ShareBoard::RoomChannel", room_code: this.room_code}, {
        connected: () => {
          this.idol_timer_start()
          this.board_info_request()
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
      }, params)

      if (this.$ac_room) {
        this.$ac_room.perform(action, params) // --> app/channels/share_board/room_channel.rb
      }
    },

    ////////////////////////////////////////////////////////////////////////////////
    sfen_share() {
      this.ac_room_perform("sfen_share", {
        title: this.current_title,
        ...this.current_sfen_info,
      }) // --> app/channels/share_board/room_channel.rb
    },
    sfen_share_broadcasted(params) {
      if (params.from_user_code === this.user_code) {
        // 自分から自分へ
      } else {
        this.attributes_set(params)
      }
      this.toast_ok(`${params.from_user_name}さんが${params.turn_offset}手目を指しました`)
      this.al_push(params)
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
  },
  computed: {
    current_sfen_info() {
      return {
        turn_offset: this.current_sfen_turn_offset,
        sfen: this.current_sfen,
      }
    },
    current_sfen_turn_offset() {
      return this.sfen_parse(this.current_sfen).moves.length
    },
  },
}
