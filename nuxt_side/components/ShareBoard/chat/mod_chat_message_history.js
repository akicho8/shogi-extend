// メッセージ履歴

// | mh_room_entry |
// | mh_room_leave |
// | mh_setup  |

// import ChatModal from "./ChatModal.vue"
// import { MessageScopeInfo } from "../models/message_scope_info.js"
// import { SendTriggerInfo } from "../models/send_trigger_info.js"
import { Gs } from "@/components/models/gs.js"
import _ from "lodash"
import { MessageRecord } from "./message_record.js"

const LATEST  = 100             // 最新の発言番号
const STEP    = 2               // まとめて読み込む発言数
const PADDING = 0             // スクロールエリア内の隙間 (px)

export const mod_chat_message_history = {
  data() {
    return {
      mh_page_index: 0,       // 次にリクエストするページ番号
      mh_scroll_height: null,  // 古い発言を差し込む直前の高さ
      mh_data: null,           // 最後に取得したデータの内容
      mh_flags: {},            // 監視した要素の状態
    }
  },
  mounted() {
    // // 発言の最上位(一番古いもの)を監視する
    // this.mh_start()
    //
    // // 一番下にスクロールしておく
    // this.mh_root_el_fetch().scrollTop = this.mh_root_el_fetch().scrollHeight
    //
    // // スクロール操作の自動化
    // setInterval(() => this.mh_root_el_fetch().scrollTop -= 1, 1000 * 0.01)
  },
  beforeDestroy() {
    this.mh_safe_stop()
  },
  methods: {
    //////////////////////////////////////////////////////////////////////////////// フック

    mh_room_entry()   { this.mh_reset_all()           }, // 入室直後
    mh_room_leave()   { this.mh_reset_all()           }, // 退室直前
    mh_chat_open()    { this.mh_setup()               }, // チャットモーダルを開いたとき
    mh_chat_close()   { this.mh_safe_stop()           }, // チャットモーダルを閉じたとき
    mh_window_focus() { this.mh_reset_all_and_setup() }, // よそ見から復帰したとき

    ////////////////////////////////////////////////////////////////////////////////

    // 初期化
    // コンテンツは残す
    mh_reset() {
      this.mh_safe_stop()

      this.mh_page_index    = 0    // 次にリクエストするページ番号
      this.mh_scroll_height = null // 古い発言を差し込む直前の高さ
      this.mh_data          = null // 最後に取得したデータの内容
      this.mh_flags         = {}   // 監視した要素の状態
    },

    // すべてを初期状態にする
    mh_reset_all() {
      this.mh_reset()
      this.ml_clear()
    },

    // これは特殊ですべてを初期状態して直近の発言をリロードする
    // よそ見から復帰したときに読んでほしい内容になっている
    // 当初は、すでに入っている発言たちは残しておいた方がよいかとケチ臭いことを思っていたが
    // よそ見した時点で、不整合状態になる恐れがあり、そうすると会話が噛み合わなくなるので全部初期化した方がよい
    mh_reset_all_and_setup() {
      if (this.ac_room) {
        this.app_log({emoji: ":チャット履歴:", subject: "よそ見からの復帰", body: `復帰前履歴行数${this.ml_count}件`})
        this.mh_reset_all()       // よそ見した時点で不整合が起きている可能性があるので全リセット
        if (this.mh_root_el()) {  // すでにチャットモーダルを開いてメッセージが見える状態であれば
          this.mh_setup()         // チャットを開いたときに実行する内容を実行する
        }
      }
    },

    // チャットを開いた瞬間に毎回実行してほしい内容
    mh_setup() {
      if (this.ac_room) {
        if (this.mh_page_index === 0) {
          this.mh_read()
        } else {
          this.mh_next_process()
        }
      }
    },

    // 新しいメッセージを読み込む
    // http://localhost:3000/api/share_board/chot_message_loader?room_code=dev_room&limit=2
    mh_read() {
      this.debug_alert("mh_read")
      this.$axios.$get("/api/share_board/chot_message_loader", {params: this.mh_api_params()}).then(e => {
        this.mh_data = e                   // 最後に取得した内容を保持しておく
        this.ml_merge(e.chot_messages)
        this.$nextTick(() => this.mh_next_process())
      })
    },

    // APIに渡すパラメータ
    mh_api_params() {
      this.debug_alert("mh_api_params")
      Gs.assert(Gs.present_p(this.room_code), "Gs.present_p(this.room_code)")
      Gs.assert(Gs.present_p(this.user_name), "Gs.present_p(this.user_name)")
      Gs.assert(this.ac_room != null, "部屋を作成しない状態で部屋の発言履歴を取得しようとしている")

      // link: app/models/share_board/room/chot_message_loader.rb
      return {
        room_code:  this.room_code,                        // 部屋
        limit:      this.AppConfig.CHAT_MESSAGES_SIZE_MAX, // 件数
        seek_pos:   this.mh_seek_pos,                      // 指定未満を取得する。nil なら最新から取得する。
        // 以下は AppLog のため
        page_index: this.mh_page_index_next(),             // 取得するページ番号 (アクセスカウンタでもある)
        user_name:  this.user_name,                        // 取得しようとした人
      }
    },

    // 読み込んだあとで毎回行う処理
    mh_next_process() {
      this.mh_viewpoint_adjust()    // スクロール位置を元に戻す
      this.mh_start_or_stop()       // 終わりでなければ監視者を用意する。終わりなら監視者を殺す。
      this.mh_head_observe()        // 終わりでなければ次のフレームで最上位を監視する
    },

    // (1) スクロール位置を元に戻す
    mh_viewpoint_adjust() {
      if (this.mh_data.data_exist_p) {
        if (this.mh_scroll_height) {
          this.mh_root_el_fetch().scrollTop = this.mh_root_el_fetch().scrollHeight - this.mh_scroll_height + PADDING
        }
      }
    },

    // (2) 終わりでなければ監視者を用意する。終わりなら監視者を殺す
    mh_start_or_stop() {
      if (this.mh_has_next_p) {
        this.mh_safe_start()
      } else {
        this.mh_safe_stop()
      }
    },

    // (3) 終わりでなければ次のフレームで最上位を監視する
    mh_head_observe() {
      this.debug_alert("mh_head_observe")
      if (this.mh_has_next_p) {
        if (this.$mh_observer) {
          this.$nextTick(() => {
            this.mh_root_el_fetch() // .SbMessageList が参照できることを確証する
            const el = document.querySelector(".SbMessageList .SbAvatarLine:first-child")
            if (el) {
              this.$mh_observer.observe(el)
            } else {
              this.debug_alert("チャットメッセージの最上位の要素が存在しません")
            }
          })
        }
      }
    },

    mh_safe_start() {
      if (!this.$mh_observer) {
        this.mh_start()
      }
    },

    mh_start() {
      this.debug_alert("mh_start")

      Gs.assert(this.$mh_observer == null, "this.$mh_observer == null")
      const options = {
        root: this.mh_root_el_fetch(),        // なくても動作に影響なかったが指定しておいたほうが良さそう
        rootMargin: `${PADDING}px 0px`, // CSS と合わせる。これがないと判定もずれる。
        threshold: 1.0,                 // isIntersecting: true とするタイミング。1.0:すべて 0.5:半分 0.0:一瞬
      }

      this.$mh_observer = new IntersectionObserver((entries, observer) => {
        Gs.assert(entries.length === 1, "entries.length === 1")

        this.mh_flags = {}
        entries.forEach(e => {
          this.mh_flags[e.target.innerText] = e.isIntersecting // 状態確認用
          console.log(`${e.target.innerText} ${e.isIntersecting} ${e.intersectionRatio}`)

          // 状態に対応するクラスを付与する
          e.target.classList.toggle("visible_true", e.isIntersecting)   // 見えたら
          e.target.classList.toggle("visible_false", !e.isIntersecting) // 見えなかったら

          // ぜんぶ見えたとき
          if (e.isIntersecting) {
            // もう用はないので解除する
            observer.unobserve(e.target)

            // 差し込む前の領域の高さを保持しておく
            console.log(this.mh_root_el_fetch())
            this.mh_scroll_height = this.mh_root_el_fetch().scrollHeight

            this.mh_read()
          }
        })
      }, options)
      this.clog(this.$mh_observer)

      // スクロール位置が一番下まで移動したあとで最上位の要素を監視する
      // this.mh_head_observe()
    },

    // 監視者を殺す
    mh_stop() {
      this.debug_alert("mh_stop")
      Gs.assert(this.$mh_observer != null, "this.$mh_observer != null") // Gs.present_p(this.$mh_observer) は false になるので注意
      this.$mh_observer.disconnect()
      this.$mh_observer = null
    },

    // 監視者がいれば殺す
    mh_safe_stop() {
      this.debug_alert("mh_safe_stop")
      if (this.$mh_observer) {
        this.mh_stop()
      }
    },

    // .SbMessageList の要素を必ず取得する
    mh_root_el_fetch() {
      const el = this.mh_root_el()
      Gs.assert(Gs.present_p(el), "チャットモーダルが開いていない状態で .SbMessageList を参照しようとしいる")
      return el
    },

    // .SbMessageList が存在するか？
    // ここは this.chat_modal_instance の有無で調べてもよかったが、
    // 本当に必要なのはチャットモーダルオブジェクトではなく .SbMessageList 要素が存在するかどうかなので
    // より直接的な方法にした
    mh_root_el() {
      return document.querySelector(".SbMessageList")
    },

    // axios で取得するページ(ブロック)番号を作る
    // 初回は必ず 0 とすること
    mh_page_index_next() {
      const v = this.mh_page_index
      this.mh_page_index += 1
      return v
    },
  },
  computed: {
    mh_seek_pos()   { return this.mh_data && this.mh_data["next_seek_pos"] }, // 読み込み位置(初回はnull)
    mh_has_next_p() { return this.mh_data && this.mh_data["has_next_p"]    }, // 次があるか？
  },
}
