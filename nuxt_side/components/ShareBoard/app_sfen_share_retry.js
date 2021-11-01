import _ from "lodash"

const RETRY_FUNCTION     = true // この機能を有効にするか？
const SEQUENCE_CODES_MAX = 5    // sequence_code は直近N件保持しておく
const RETRY_DELAY        = 3    // 再送ダイアログ発動までN秒待つ
const RETRY_DELAY_MAX    = 8    // 再送ダイアログ発動まで最大N秒待つ
const RETRY_TOAST_SEC    = 6    // 再送のtoastを何秒表示するか？
const SEND_SUCCESS_DELAY = 0    // 受信OKするまでの秒数(本番では0にすること) 再送ダイアログ発動より長いと再送ダイアログをcloseする

export const app_sfen_share_retry = {
  data() {
    return {
      sequence_code: 0,             // sfen_share する度(正確にはsfen_share_params_setする度)にインクリメントしていく(乱数でもいい？)
      sequence_codes: [],           // それを最大 SEQUENCE_CODES_MAX 件保持しておく
      send_success_p: false,        // 直近のSFENの同期が成功したか？
      retry_delay_id: null,         // 送信してから RETRY_DELAY 秒後に動かすための setTimeout の戻値
      x_retry_count_total: 0,       // SFEN送信に失敗した総回数(不具合解析用)
      x_retry_count: 0,             // 直近の指し手のSFEN送信に失敗して回数(表示用)
      retry_confirm_instance: null, // $buefy.dialog.confirm のインスタンス
    }
  },
  beforeDestroy() {
    this.retry_delay_cancel()
    this.retry_confirm_close()
  },
  methods: {
    sequence_code_embed() {
      if (RETRY_FUNCTION) {
        this.sequence_code += 1
        this.sequence_codes.push(this.sequence_code)
        this.sequence_codes = _.takeRight(this.sequence_codes, SEQUENCE_CODES_MAX)
        this.sfen_share_params.sequence_code = this.sequence_code
      }
    },
    sfen_share_callback_set() {
      if (RETRY_FUNCTION) {
        if (this.order_func_p && this.ordered_members_present_p) {
          if (this.RETRY_DELAY >= 0) {
            this.retry_delay_cancel()
            this.retry_delay_id = this.delay_block(this.retry_check_delay, () => {
              if (this.send_success_p) {
                // 相手から応答があった
                // this.x_retry_count = 0  // 失敗回数リセット
              } else {
                // 結構待ったけど相手から応答がまだない
                this.retry_confirm()
              }
            })
          }
        }
      }
    },
    retry_delay_cancel() {
      if (this.retry_delay_id) {
        this.delay_stop(this.retry_delay_id)
        this.retry_delay_id = null
      }
    },
    retry_confirm() {
      this.sound_play("x")

      this.x_retry_count_total += 1
      this.x_retry_count += 1
      this.sfen_share_not_reach()

      const next_user_name = this.user_name_by_turn(this.sfen_share_params.turn_offset)
      const message1 = `次の手番の${this.user_call_name(next_user_name)}の反応がないので再送しますか？`
      const message2 = `<span class="has-text-grey is-size-7 mx-1">${this.retry_check_delay}秒後に再度確認します</span>`
      const message3 = `${message1}${message2}`
      // this.talk(message1)

      this.retry_confirm_close()
      this.retry_confirm_instance = this.dialog_confirm({
        title: `同期失敗 ${this.x_retry_count}回目`,
        message: message3,
        cancelText: "諦める",
        confirmText: "再送する",
        hasIcon: true,
        type: "is-warning",
        focusOn: "confirm",
        onCancel: () => {
          this.sound_stop_all()
          this.sound_play_click()
        },
        onConfirm: () => {
          this.sound_stop_all()
          this.sound_play_click()
          this.sfen_share()
        },
      })
    },
    retry_confirm_close() {
      if (this.retry_confirm_instance) {
        this.retry_confirm_instance.close()
        this.retry_confirm_instance = null
      }
    },

    //////////////////////////////////////////////////////////////////////////////// 失敗したことをRails側に通知
    sfen_share_not_reach() {
      const params = {
        x_retry_count_total: this.x_retry_count_total,
        x_retry_count:       this.x_retry_count,
      }
      this.ac_room_perform("sfen_share_not_reach", params) // --> app/channels/share_board/room_channel.rb
    },
    sfen_share_not_reach_broadcasted(params) {
      alert("must not happen")
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 指し手を受信した次に人が sfen_share_broadcasted のなかで呼ぶ
    received_ok_send(params) {
      if (RETRY_FUNCTION) {
        if (this.order_func_p) {
          // 何で何回も指しているのかわからないので再送していることを伝える(自分も含めて)
          if (params.x_retry_count >= 1) {
            this.toast_warn(`次の手番の${this.user_call_name(params.next_user_name)}の反応がないので${this.user_call_name(params.from_user_name)}が再送しました(${params.x_retry_count}回目)`, {duration: 1000 * RETRY_TOAST_SEC, toast_only: true})
          }
          if (params.next_user_name === this.user_name) {
            // 自分が下家なので上家に受信したことを伝える
            this.received_ok({
              to_connection_id: params.from_connection_id, // alice さんから来たので alice さんに送信
              to_user_name:     params.from_user_name,
              sequence_code:    params.sequence_code,
            })
          } else {
            // 自分は下家ではない
          }
        }
      }
    },
    received_ok(params) {
      this.tl_alert("受信OK")
      this.ac_room_perform("received_ok", params) // --> app/channels/share_board/room_channel.rb
    },
    received_ok_broadcasted(params) {
      if (params.to_connection_id === this.connection_id) {       // いろんな人に届くため送信元の確認
        if (this.sequence_codes.includes(params.sequence_code)) { // 最近送ったものなら
          if (this.SEND_SUCCESS_DELAY >= 0) {
            this.delay_block(this.SEND_SUCCESS_DELAY, () => {     // デバッグ用のウェイト
              this.send_success_p = true                          // 送信成功とする
              this.retry_confirm_close()                          // 4秒後の場合ダイアログがすでに出ているので消す
              this.tl_alert("送信OK")
            })
          }
        }
      }
    },

  },

  computed: {
    RETRY_DELAY() { return parseFloat(this.$route.query.RETRY_DELAY || RETRY_DELAY) },
    SEND_SUCCESS_DELAY()  { return parseFloat(this.$route.query.SEND_SUCCESS_DELAY || SEND_SUCCESS_DELAY) },

    retry_check_delay() {
      let v = this.RETRY_DELAY + this.x_retry_count
      if (v > RETRY_DELAY_MAX) {
        v = RETRY_DELAY_MAX
      }
      return v
    },
  },
}
