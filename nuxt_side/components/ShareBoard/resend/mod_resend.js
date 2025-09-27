import _ from "lodash"
import { Gs } from "@/components/models/gs.js"
import SbResendModal from "./SbResendModal.vue"

const RS_ENABLE           = true // この機能を有効にするか？
const RS_SEQ_IDS_SIZE     = 5    // rs_seq_id は直近X件保持しておく
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
      rs_resend_delay_id: null, // 送信してから RS_RESEND_DELAY 秒後に動かすための setTimeout の戻値
      rs_failed_total: 0,       // SFEN送信に失敗した総回数(不具合解析用)
      rs_failed_count: 0,       // 直近の指し手のSFEN送信に失敗して回数(表示用)
      rs_modal_instance: null,  // モーダルインスタンス
    }
  },
  beforeDestroy() {
    this.rs_modal_with_timer_close()
  },
  methods: {
    // あとで確認するため、指し手情報に指し手の番号を埋めておく
    sequence_code_embed() {
      if (!this.RS_ENABLE) { return }
      this.rs_seq_id += 1
      this.rs_seq_ids.push(this.rs_seq_id)
      this.rs_seq_ids = _.takeRight(this.rs_seq_ids, RS_SEQ_IDS_SIZE)
      this.sfen_share_params.rs_seq_id = this.rs_seq_id
    },

    // sfen_share の実行直後に呼ぶ
    rs_sfen_share_after_hook() {
      if (!this.RS_ENABLE) { return }
      if (this.order_enable_p && this.order_unit.valid_p) {
        if (this.RS_RESEND_DELAY >= 0) {
          this.rs_resend_delay_cancel()
          this.rs_resend_delay_id = Gs.delay_block(this.rs_resend_delay_real_sec, () => {
            if (this.rs_send_success_p) {
              // このブロックが呼ばれる前に相手から応答があった
            } else {
              // 結構待ったけど相手から応答がまだない
              this.rs_modal_open()
            }
          })
        }
      }
    },
    rs_resend_delay_cancel() {
      if (this.rs_resend_delay_id) {
        Gs.delay_stop(this.rs_resend_delay_id)
        this.rs_resend_delay_id = null
      }
    },
    rs_modal_open() {
      this.sfx_play("x")
      this.rs_failed_notify()
      this.rs_modal_with_timer_close()
      this.rs_modal_instance = this.modal_card_open({
        component: SbResendModal,
        canCancel: [],
      })
    },
    // これより rs_modal_with_timer_close を使うべし
    rs_modal_close() {
      if (this.rs_modal_instance) {
        this.rs_modal_instance.close()
        this.rs_modal_instance = null
      }
    },

    // モーダルとモーダル発動タイマーを合わせて削除する
    rs_modal_with_timer_close() {
      this.rs_modal_close()
      this.rs_resend_delay_cancel()
    },

    //////////////////////////////////////////////////////////////////////////////// 失敗したことをRails側に通知
    rs_failed_notify() {
      this.rs_failed_total += 1
      this.rs_failed_count += 1
      const params = {
        rs_failed_total: this.rs_failed_total,
        rs_failed_count: this.rs_failed_count,
      }
      this.ac_room_perform("rs_failed_notify", params) // --> app/channels/share_board/room_channel.rb
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 指し手を受信した次に人が sfen_share_broadcasted のなかで呼ぶ
    rs_receive_success_send(params) {
      if (!this.RS_ENABLE) { return }
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
            rs_seq_id:        params.rs_seq_id,
          })
        } else {
          // 自分は下家ではない
        }
      }
    },
    rs_receive_success(params) {
      this.tl_alert("受信OK")
      this.ac_room_perform("rs_receive_success", params) // --> app/channels/share_board/room_channel.rb
    },
    rs_receive_success_broadcasted(params) {
      if (params.to_connection_id === this.connection_id) { // いろんな人に届くため送信元の確認
        if (this.rs_seq_ids.includes(params.rs_seq_id)) {   // 最近送ったものなら
          if (this.RS_SUCCESS_DELAY >= 0) {
            Gs.delay_block(this.RS_SUCCESS_DELAY, () => {   // デバッグ用のウェイト
              this.rs_send_success_p = true                 // 送信成功とする
              this.rs_modal_with_timer_close()              // 4秒後の場合ダイアログがすでに出ているので消す
              this.tl_alert("送信OK")
            })
          }
        }
      }
    },

    // 次の人を順番設定から除外する (デバッグ用)
    rs_next_member_delete() {
      this.os_member_delete(this.rs_next_user_name)
    },
  },

  computed: {
    RS_ENABLE()        { return String(this.$route.query.RS_ENABLE ?? RS_ENABLE) === "true"        },
    RS_RESEND_DELAY()  { return parseFloat(this.$route.query.RS_RESEND_DELAY ?? RS_RESEND_DELAY)   },
    RS_SUCCESS_DELAY() { return parseFloat(this.$route.query.RS_SUCCESS_DELAY ?? RS_SUCCESS_DELAY) },

    // 再送モーダルを発動するまでの時間(秒)
    // RS_RESEND_DELAY が 5 であれば 5, 6, 8, 11, 15 の順に増えていく
    rs_resend_delay_real_sec() {
      let v = this.RS_RESEND_DELAY + this.rs_failed_count
      if (v > RS_RESEND_DELAY_MAX) {
        v = RS_RESEND_DELAY_MAX
      }
      return v
    },

    // 次に指す人の名前
    rs_next_user_name() {
      if (this.sfen_share_params) {
        return this.sfen_share_params.next_user_name
      }
    },
  },
}
