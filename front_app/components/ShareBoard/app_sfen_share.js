import _ from "lodash"

export const app_sfen_share = {
  data() {
    return {
      sfen_share_params: null,       // リトライするとき用に送るパラメータを保持しておく
    }
  },
  methods: {
    ////////////////////////////////////////////////////////////////////////////////
    sfen_share_params_set(last_move_info) {
      const lmi = last_move_info

      this.tl_add("SP", lmi.to_kif_without_from, lmi)
      this.__assert__(this.current_sfen, "this.current_sfen")
      this.__assert__(lmi.next_turn_offset === this.current_sfen_turn_offset, "lmi.next_turn_offset === this.current_sfen_turn_offset")

      this.x_retry_count = 0    // 新しい手を指したので再送回数を0にしておく

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

      if (this.clock_box) {
        this.sfen_share_params["elapsed_sec"] = this.clock_box.elapsed_sec
      }

      this.sequence_code_embed()
    },

    sfen_share() {
      this.send_success_p = false // 数ms後に相手から応答があると true になる

      const params = {
        x_retry_count: this.x_retry_count, // 0:初回 1以上:再送回数
        ...this.sfen_share_params,
      }
      this.ac_room_perform("sfen_share", params) // --> app/channels/share_board/room_channel.rb
      this.sfen_share_afetr_check()
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
        this.vibrate(10)
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

        if (this.yomiagable_p) {
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
        }

        this.received_ok_send(params)
      }

      this.al_add(params)
    },
  },
  computed: {
    // 時計が設置されてなくて読み上げOFFのときはダメ
    // 時計が設置されている または 読み上げON はOK
    yomiagable_p() {
      return this.clock_box || this.yomiage_mode === "is_yomiage_mode_on"
    },
  },
}
