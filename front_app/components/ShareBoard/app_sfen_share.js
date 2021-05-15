import _ from "lodash"

const RETRY_FUNCTION_ENABLED = true // この機能を有効にするか？
const SEQUENCE_CODES_MAX     = 5    // sequence_code は直近N件保持しておく
const RETRY_CHECK_DELAY      = 3    // N秒後に相手からの通知の結果(send_success_p)を確認する

export const app_sfen_share = {
  data() {
    return {
      sequence_code: 0,              // sfen_share する度(正確にはsfen_share_params_setする度)にインクリメントしていく(乱数でもいい？)
      sequence_codes: [],            // それを最大 SEQUENCE_CODES_MAX 件保持しておく
      send_success_p: false,         // 直近のSFENの同期が成功したか？
      sfen_share_params: null,       // リトライするとき用に送るパラメータを保持しておく
      retry_check_delay_id: null,    // 送信してから RETRY_CHECK_DELAY 秒後に動かすための setTimeout の戻値
      sfen_share_not_reach_count: 0, // SFEN送信に失敗した回数(不具合解析用)
    }
  },
  beforeDestroy() {
    this.retry_confirm_cancel()
  },
  methods: {
    ////////////////////////////////////////////////////////////////////////////////
    sfen_share_params_set(last_move_info) {
      const lmi = last_move_info

      this.tl_add("SP", lmi.to_kif_without_from, lmi)
      this.__assert__(this.current_sfen, "this.current_sfen")
      this.__assert__(lmi.next_turn_offset === this.current_sfen_turn_offset, "lmi.next_turn_offset === this.current_sfen_turn_offset")

      this.sfen_share_params = {
        lmi: {
          kif_without_from:    lmi.to_kif_without_from, // "☗7六歩"
          next_turn_offset:    lmi.next_turn_offset,    // 1
          player_location_key: lmi.player_location.key, // "black"
          yomiage:             lmi.to_yomiage,          // "ななろくふ"
        },
        ...this.current_sfen_attrs, // turn_offset が含まれる
      }

      const next_user_name = this.user_name_by_turn(lmi.next_turn_offset) // alice, bob がいて初手を指したら bob
      if (next_user_name) {
        this.sfen_share_params["next_user_name"] = next_user_name
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

      this.sfen_share_not_reach()

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
      if (params.from_connection_id === this.connection_id) {
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
        this.toast_ok(`${this.user_call_name(params.from_user_name)}が${params.lmi.next_turn_offset}手目を指しました`)
      }
      if (false) {
        this.toast_ok(`${this.user_call_name(params.from_user_name)}が指しました`)
      }
      if (true) {
        const prev_user_name = this.user_name_by_turn(params.lmi.next_turn_offset - 1) // alice, bob がいて初手を指したら alice
        // const next_user_name = this.user_name_by_turn(params.lmi.next_turn_offset)     // alice, bob がいて初手を指したら bob
        const next_user_name = params.next_user_name
        const next_user_received_p = this.user_name === next_user_name                 // コンテキストが bob なら true

        if (next_user_received_p) {
          this.tn_notify()
        }

        if (this.development_p) {
          if (prev_user_name) {
            if (params.from_user_name !== prev_user_name) {
              this.debug_alert(`${this.user_call_name(prev_user_name)}の手番でしたが${this.user_call_name(params.from_user_name)}が指しました`)
            }
          }
        }

        // 「alice ▲76歩」と表示しながら
        this.toast_ok(`${params.from_user_name} ${params.lmi.kif_without_from}`, {toast_only: true})

        // 「aliceさん」の発声後に「7 6 ふー！」を発声する
        this.talk(this.user_call_name(params.from_user_name), {
          onend: () => this.talk(params.lmi.yomiage, {
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
                to_connection_id: params.from_connection_id, // alice さんから来たので alice さんに送信
                to_user_name: params.from_user_name,
                sequence_code: params.sequence_code,
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
      if (params.to_connection_id === this.connection_id) {             // いろんな人に届くため送信元の確認
        if (this.sequence_codes.includes(params.sequence_code)) { // 最近送ったものなら
          if (this.development_p && this.$route.query.send_success_skip === "true") {
            // 送信成功としない
          } else {
            this.send_success_p = true                                    // 送信成功とする
            this.debug_alert("送信OK")
          }
        }
      }
    },

    //////////////////////////////////////////////////////////////////////////////// 失敗したことをRails側に通知
    sfen_share_not_reach() {
      this.sfen_share_not_reach_count += 1
      const params = {
        sfen_share_not_reach_count: this.sfen_share_not_reach_count,
      }
      this.ac_room_perform("sfen_share_not_reach", params) // --> app/channels/share_board/room_channel.rb
    },
    sfen_share_not_reach_broadcasted(params) {
      alert("must not happen")
    },
  },
  computed: {
    RETRY_CHECK_DELAY() { return parseFloat(this.$route.query.RETRY_CHECK_DELAY ?? RETRY_CHECK_DELAY) }
  },
}
