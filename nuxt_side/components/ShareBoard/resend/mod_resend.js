import _ from "lodash"
import { GX } from "@/components/models/gx.js"
import { resend_confirm_modal } from "./resend_confirm_modal.js"

const RESEND_FEATURE           = true // この機能を有効にするか？
const RESEND_SEQUENCE_IDS_SIZE = 5    // resend_sequence_id は直近X件保持しておく
const RESEND_DELAY             = 3    // 再送モーダル発動までN秒待つ (重要)
const RESEND_DELAY_MAX         = 8    // 再送モーダル発動まで最大N秒待つ
const RESEND_TOAST_SEC         = 6    // 再送のtoastを何秒表示するか？
const RESEND_SUCCESS_DELAY     = 0    // 受信OKするまでの秒数(本番では0にすること) 再送モーダル発動より長いと再送モーダルをcloseする
const RESEND_TRY_MAX               = 3    // 最大何回再送するか？

export const mod_resend = {
  mixins: [resend_confirm_modal],

  data() {
    return {
      resend_sequence_id: 0,             // sfen_sync する度(正確にはsfen_sync_params_setする度)にインクリメントしていく(乱数でもいい？)
      resend_sequence_ids: [],           // それを最大 RESEND_SEQUENCE_IDS_SIZE 件保持しておく
      resend_success_p: false, // 直近のSFENの同期が成功したか？
      resend_observer_id: null, // 送信してから RESEND_DELAY 秒後に動かすための setTimeout の戻値
      resend_failed_total: 0,       // SFEN送信に失敗した総回数(不具合解析用)
      resend_failed_count: 0,       // 直近の指し手のSFEN送信に失敗して回数(表示用)
    }
  },
  beforeDestroy() {
    this.resend_done()
  },
  methods: {
    // あとで確認するため、指し手情報に指し手の番号を埋めておく
    sequence_code_embed() {
      if (!this.RESEND_FEATURE) { return }
      this.resend_sequence_id += 1
      this.resend_sequence_ids.push(this.resend_sequence_id)
      this.resend_sequence_ids = _.takeRight(this.resend_sequence_ids, RESEND_SEQUENCE_IDS_SIZE)
      this.sfen_sync_params.resend_sequence_id = this.resend_sequence_id
    },

    // 指した直後
    resend_init() {
      this.resend_success_p = false // 数ms後に相手から応答があると true になる
      this.resend_failed_count = 0  // 着手したので再送回数を0にしておく
    },

    // sfen_sync の実行直後に呼ぶ
    resend_start() {
      if (!this.RESEND_FEATURE) { return }
      if (this.order_enable_p && this.order_flow.valid_p) {
        if (this.RESEND_DELAY >= 0) {
          this.resend_observer_kill()
          this.resend_observer_id = GX.delay_block(this.resend_adjusted_delay_sec, () => {
            if (this.resend_success_p) {
              // このブロックが呼ばれる前に相手から応答があった
            } else {
              // 結構待ったけど相手から応答がまだない
              this.resend_confirm_modal_open()
            }
          })
        }
      }
    },

    resend_observer_kill() {
      if (this.resend_observer_id) {
        GX.delay_stop(this.resend_observer_id)
        this.resend_observer_id = null
      }
    },

    // モーダルとモーダル発動タイマーを合わせて削除する
    resend_done() {
      this.resend_confirm_modal_close()
      this.resend_observer_kill()
    },

    //////////////////////////////////////////////////////////////////////////////// 失敗したことをRails側に通知
    resend_failed_logging() {
      this.resend_failed_total += 1
      this.resend_failed_count += 1
      const params = {
        resend_failed_total: this.resend_failed_total,
        resend_failed_count: this.resend_failed_count,
      }
      this.ac_room_perform("resend_failed_logging", params) // --> app/channels/share_board/room_channel.rb
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 指し手を受信した次に人が sfen_sync_broadcasted のなかで呼ぶ
    resend_receive_success_send(params) {
      if (!this.RESEND_FEATURE) { return }
      if (this.order_enable_p) {
        // 何で何回も指しているのかわからないので再送していることを伝える(自分も含めて)
        GX.assert(params.resend_failed_count != null, "params.resend_failed_count != null")
        if (params.resend_failed_count >= 1) {
          const message = `次の手番の${this.user_call_name(params.next_user_name)}の反応がないので${this.user_call_name(params.from_user_name)}が再送しました(${params.resend_failed_count}回目)`
          this.toast_warn(message, {duration_sec: RESEND_TOAST_SEC, talk: true})
        }
        if (this.next_is_self_p(params)) {
          // 自分が下家なので上家に受信したことを伝える
          this.resend_receive_success({
            to_connection_id: params.from_connection_id, // alice さんから来たので alice さんに送信
            to_user_name:     params.from_user_name,
            resend_sequence_id:        params.resend_sequence_id,
          })
        } else {
          // 自分は下家ではない
        }
      }
    },
    resend_receive_success(params) {
      this.tl_alert("受信OK")
      this.ac_room_perform("resend_receive_success", params) // --> app/channels/share_board/room_channel.rb
    },
    resend_receive_success_broadcasted(params) {
      if (params.to_connection_id === this.connection_id) { // いろんな人に届くため送信元の確認
        if (this.resend_sequence_ids.includes(params.resend_sequence_id)) {   // 最近送ったものなら
          if (this.RESEND_SUCCESS_DELAY >= 0) {
            GX.delay_block(this.RESEND_SUCCESS_DELAY, () => {   // デバッグ用のウェイト
              this.resend_success_p = true                 // 送信成功とする
              this.resend_done()              // 4秒後の場合ダイアログがすでに出ているので消す
              this.tl_alert("送信OK")
            })
          }
        }
      }
    },

    // 次の人を順番設定から除外する (デバッグ用)
    resend_next_member_delete() {
      this.os_member_delete(this.resend_next_user_name)
    },
  },

  computed: {
    RESEND_FEATURE()       { return this.param_to_b("RESEND_FEATURE", RESEND_FEATURE) },
    RESEND_DELAY()         { return this.param_to_f("RESEND_DELAY", RESEND_DELAY) },
    RESEND_SUCCESS_DELAY() { return this.param_to_f("RESEND_SUCCESS_DELAY", RESEND_SUCCESS_DELAY) },
    RESEND_TRY_MAX()       { return this.param_to_f("RESEND_TRY_MAX", RESEND_TRY_MAX) },

    resend_suggest_p() { return this.resend_failed_count < this.RESEND_TRY_MAX }, // 再送させるか？

    // 再送モーダルを発動するまでの時間(秒)
    // RESEND_DELAY が 5 であれば 5, 6, 8, 11, 15 の順に増えていく
    resend_adjusted_delay_sec() {
      const sec = this.RESEND_DELAY + this.resend_failed_count
      return GX.iclamp(sec, 0, RESEND_DELAY_MAX)
    },

    // 次に指す人の名前
    resend_next_user_name() {
      if (this.sfen_sync_params) {
        return this.sfen_sync_params.next_user_name
      }
    },
  },
}
