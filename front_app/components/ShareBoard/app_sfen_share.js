import _ from "lodash"

const RETRY_FUNCTION_ENABLED = true // この機能を有効にするか？
const SEQUENCE_CODES_MAX     = 5    // sequence_code は直近N件保持しておく
const RETRY_CHECK_DELAY      = 3    // N秒後に相手からの通知の結果(send_success_p)を確認する

export const app_sfen_share = {
  data() {
    return {
      sequence_code: 0,             // sfen_share する度(正確にはsfen_share_params_setする度)にインクリメントしていく(乱数でもいい？)
      sequence_codes: [],           // それを最大 SEQUENCE_CODES_MAX 件保持しておく
      send_success_p: false,        // 直近のSFENの同期が成功したか？
      sfen_share_params: null,      // リトライするとき用に送るパラメータを保持しておく
      retry_check_delay_id: null,   // 送信してから RETRY_CHECK_DELAY 秒後に動かすための setTimeout の戻値
    }
  },
  beforeDestroy() {
    this.retry_confirm_cancel()
  },
  methods: {
    ////////////////////////////////////////////////////////////////////////////////
    sfen_share_params_set(params) {
      this.__assert__(this.current_sfen, "this.current_sfen")
      this.sfen_share_params = {
        ...params,
        ...this.current_sfen_attrs, // turn_offset は含まれる
      }

      if (RETRY_FUNCTION_ENABLED) {
        this.sequence_code += 1
        this.sequence_codes.push(this.sequence_code)
        this.sequence_codes = _.takeRight(this.sequence_codes, SEQUENCE_CODES_MAX)
        this.sfen_share_params.sequence_code = this.sequence_code
      }
    },

    sfen_share() {
      this.send_success_p = false
      this.ac_room_perform("sfen_share", this.sfen_share_params) // --> app/channels/share_board/room_channel.rb

      if (RETRY_FUNCTION_ENABLED) {
        if (this.order_func_p && this.ordered_members_present_p) {
          this.retry_confirm_cancel()
          if (this.RETRY_CHECK_DELAY >= 0) {
            this.retry_check_delay_id = this.delay_block(this.RETRY_CHECK_DELAY, () => {
              if (!this.send_success_p) {
                this.retry_confirm()
              }
            })
          }
        }
      }
    },

    retry_confirm_cancel() {
      if (this.retry_check_delay_id) {
        this.delay_stop(this.retry_check_delay_id)
        this.retry_check_delay_id = null
      }
    },

    retry_confirm() {
      this.sound_play("click")

      const next_user_name = this.user_name_by_turn(this.sfen_share_params.turn_offset)
      const message = `次の手番の${this.user_call_name(next_user_name)}の反応がないため再送しますか？`
      this.talk(message)

      this.$buefy.dialog.confirm({
        title: "同期失敗",
        message: message,
        cancelText: "諦める",
        confirmText: "再送する",
        hasIcon: true,
        type: "is-warning",
        focusOn: "confirm",
        onCancel: () => {
          this.talk_stop()
          this.sound_play("click")
        },
        onConfirm: () => {
          this.talk_stop()
          this.sound_play("click")
          this.sfen_share()
        },
      })
    },

    sfen_share_broadcasted(params) {
      // ここでの params は current_sfen_attrs を元にしているので 1 が入っている
      if (params.from_user_code === this.user_code) {
        // 自分から自分へ
      } else {
        // もし edit_mode に入っている場合は強制的に解除する
        if (this.edit_mode_p) {
          this.debug_alert("指し手のブロードキャストにより編集を解除")
          this.sp_run_mode = "play_mode"
        }
        // 受信したSFENを盤に反映
        this.setup_by_params(params)
      }
      if (false) {
        this.toast_ok(`${this.user_call_name(params.from_user_name)}が${params.turn_offset}手目を指しました`)
      }
      if (false) {
        this.toast_ok(`${this.user_call_name(params.from_user_name)}が指しました`)
      }
      if (true) {
        const prev_user_name = this.user_name_by_turn(params.turn_offset - 1)
        const next_user_name = this.user_name_by_turn(params.turn_offset)
        const next_user_received_p = this.user_name === next_user_name

        if (next_user_received_p) {
          this.tn_notify()
        }

        if (prev_user_name) {
          if (params.from_user_name !== prev_user_name) {
            this.debug_alert(`${this.user_call_name(prev_user_name)}の手番でしたが${this.user_call_name(params.from_user_name)}が指しました`)
          }
        }

        // 「alice ▲76歩」と表示しながら
        this.toast_ok(`${params.from_user_name} ${params.last_move_kif}`, {toast_only: true})

        // 「aliceさん」の発声後に「7 6 ふー！」を発声する
        this.talk(this.user_call_name(params.from_user_name), {
          onend: () => this.talk(params.yomiage, {
            onend: () => {
              if (next_user_name) {
                this.toast_ok(`次は${this.user_call_name(next_user_name)}の手番です`)
              }
            },
          }),
        })

        if (RETRY_FUNCTION_ENABLED) {
          if (this.order_func_p) {
            if (next_user_received_p) {
              this.received_ok({
                received_params: {
                  sequence_code: params.sequence_code,
                  from_user_code: params.from_user_code,
                },
              })
            }
          }
        }
      }

      this.al_add(params)
    },

    //////////////////////////////////////////////////////////////////////////////// share_sfen した人に受信したこと通知する
    received_ok(params) {
      this.debug_alert("受信OK")
      this.ac_room_perform("received_ok", {
        ...params,
      }) // --> app/channels/share_board/room_channel.rb
    },
    received_ok_broadcasted(params) {
      const { received_params } = params                                   // 自分が送って相手が受信した内容
      if (received_params.from_user_code === this.user_code) {             // いろんな人に届くため送信元の確認
        if (this.sequence_codes.includes(received_params.sequence_code)) { // 最近送ったものなら
          if (this.development_p && this.$route.query.send_success_skip === "true") {
            // 送信成功としない
          } else {
            this.send_success_p = true                                    // 送信成功とする
            this.debug_alert("送信OK")
          }
        }
      }
    },
  },
  computed: {
    RETRY_CHECK_DELAY() { return parseFloat(this.$route.query.RETRY_CHECK_DELAY ?? RETRY_CHECK_DELAY) }
  },
}
