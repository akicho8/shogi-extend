import _ from "lodash"
import { Gs } from "@/components/models/gs.js"

const RS_RESEND_FUNCTION  = true // この機能を有効にするか？
const RS_SEQ_IDS_SIZE     = 5    // rs_seq_id は直近N件保持しておく
const RS_RESEND_DELAY     = 3    // 再送モーダル発動までN秒待つ
const RS_RESEND_DELAY_MAX = 8    // 再送モーダル発動まで最大N秒待つ
const RS_RESEND_TOAST_SEC = 6    // 再送のtoastを何秒表示するか？
const RS_SUCCESS_DELAY    = 0    // 受信OKするまでの秒数(本番では0にすること) 再送モーダル発動より長いと再送モーダルをcloseする

export const mod_resend = {
  data() {
    return {
      rs_seq_id: 0,             // sfen_share する度(正確にはsfen_share_params_setする度)にインクリメントしていく(乱数でもいい？)
      rs_seq_ids: [],           // それを最大 RS_SEQ_IDS_SIZE 件保持しておく
      rs_send_success_p: false, // 直近のSFENの同期が成功したか？
      rs_resend_delay_id: null,  // 送信してから RS_RESEND_DELAY 秒後に動かすための setTimeout の戻値
      rs_failed_total: 0, // SFEN送信に失敗した総回数(不具合解析用)
      rs_failed_count: 0,       // 直近の指し手のSFEN送信に失敗して回数(表示用)
      rs_modal: null,  // $buefy.dialog.confirm のインスタンス
    }
  },
  beforeDestroy() {
    this.retry_delay_cancel()
    this.rs_modal_close()
  },
  methods: {
    sequence_code_embed() {
      if (this.RS_RESEND_FUNCTION) {
        this.rs_seq_id += 1
        this.rs_seq_ids.push(this.rs_seq_id)
        this.rs_seq_ids = _.takeRight(this.rs_seq_ids, RS_SEQ_IDS_SIZE)
        this.sfen_share_params.rs_seq_id = this.rs_seq_id
      }
    },
    rs_sfen_share_after_hook() {
      if (this.RS_RESEND_FUNCTION) {
        if (this.order_enable_p && this.order_unit.valid_p) {
          if (this.RS_RESEND_DELAY >= 0) {
            this.retry_delay_cancel()
            this.rs_resend_delay_id = Gs.delay_block(this.rs_retry_check_delay, () => {
              if (this.rs_send_success_p) {
                // 相手から応答があった
                // this.rs_failed_count = 0  // 失敗回数リセット
              } else {
                // 結構待ったけど相手から応答がまだない
                this.rs_modal_open()
              }
            })
          }
        }
      }
    },
    retry_delay_cancel() {
      if (this.rs_resend_delay_id) {
        Gs.delay_stop(this.rs_resend_delay_id)
        this.rs_resend_delay_id = null
      }
    },
    rs_modal_open() {
      this.$sound.play("x")

      this.rs_failed_total += 1
      this.rs_failed_count += 1
      this.rs_failed_notify()

      const next_user_name = this.turn_to_user_name(this.sfen_share_params.turn)
      const message = `
        次の手番の${this.user_call_name(next_user_name)}の通信状況が悪いため再送してください
        <ul class="has-text-grey is-size-7 mx-1 mt-2">
          <li>再送しないと対局を続けられません</li>
          <li>${this.rs_retry_check_delay}秒後に再度確認します</li>
        </ul>
      `
      this.rs_modal_close()
      this.rs_modal = this.dialog_confirm({
        title: `同期失敗 ${this.rs_failed_count}回目`,
        message: message,
        cancelText: "諦める",
        confirmText: "再送する",
        hasIcon: true,
        type: "is-warning",
        focusOn: "confirm",
        onCancel: () => {
          this.$sound.play_click()
        },
        onConfirm: () => {
          this.$sound.play_click()
          this.sfen_share()
        },
      })
    },
    rs_modal_close() {
      if (this.rs_modal) {
        this.rs_modal.close()
        this.rs_modal = null
      }
    },

    //////////////////////////////////////////////////////////////////////////////// 失敗したことをRails側に通知
    rs_failed_notify() {
      const params = {
        rs_failed_total: this.rs_failed_total,
        rs_failed_count: this.rs_failed_count,
      }
      this.ac_room_perform("rs_failed_notify", params) // --> app/channels/share_board/room_channel.rb
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 指し手を受信した次に人が sfen_share_broadcasted のなかで呼ぶ
    rs_receive_success_send(params) {
      if (this.RS_RESEND_FUNCTION) {
        if (this.order_enable_p) {
          // 何で何回も指しているのかわからないので再送していることを伝える(自分も含めて)
          Gs.assert(params.rs_failed_count != null, "params.rs_failed_count != null")
          if (params.rs_failed_count >= 1) {
            const message = `次の手番の${this.user_call_name(params.next_user_name)}の反応がないので${this.user_call_name(params.from_user_name)}が再送しました(${params.rs_failed_count}回目)`
            this.toast_warn(message, {duration: 1000 * RS_RESEND_TOAST_SEC, talk: false})
          }
          if (params.next_user_name === this.user_name) {
            // 自分が下家なので上家に受信したことを伝える
            this.rs_receive_success({
              to_connection_id: params.from_connection_id, // alice さんから来たので alice さんに送信
              to_user_name:     params.from_user_name,
              rs_seq_id:    params.rs_seq_id,
            })
          } else {
            // 自分は下家ではない
          }
        }
      }
    },
    rs_receive_success(params) {
      this.tl_alert("受信OK")
      this.ac_room_perform("rs_receive_success", params) // --> app/channels/share_board/room_channel.rb
    },
    rs_receive_success_broadcasted(params) {
      if (params.to_connection_id === this.connection_id) {       // いろんな人に届くため送信元の確認
        if (this.rs_seq_ids.includes(params.rs_seq_id)) { // 最近送ったものなら
          if (this.RS_SUCCESS_DELAY >= 0) {
            Gs.delay_block(this.RS_SUCCESS_DELAY, () => {     // デバッグ用のウェイト
              this.rs_send_success_p = true                          // 送信成功とする
              this.rs_modal_close()                          // 4秒後の場合ダイアログがすでに出ているので消す
              this.tl_alert("送信OK")
            })
          }
        }
      }
    },

  },

  computed: {
    RS_RESEND_FUNCTION() { return String(this.$route.query.RS_RESEND_FUNCTION ?? RS_RESEND_FUNCTION) === "true" },
    RS_RESEND_DELAY()    { return parseFloat(this.$route.query.RS_RESEND_DELAY ?? RS_RESEND_DELAY)              },
    RS_SUCCESS_DELAY()   { return parseFloat(this.$route.query.RS_SUCCESS_DELAY ?? RS_SUCCESS_DELAY)            },

    rs_retry_check_delay() {
      let v = this.RS_RESEND_DELAY + this.rs_failed_count
      if (v > RS_RESEND_DELAY_MAX) {
        v = RS_RESEND_DELAY_MAX
      }
      return v
    },
  },
}
