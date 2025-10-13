// メッセージ履歴

// |-----------------------+--------------------------------------------------------------|
// | Method                | 意味                                                         |
// |-----------------------+--------------------------------------------------------------|
// | mh_reset()            | 初期化する                                                   |
// | mh_reset_all()        | 初期化する (メッセージリストも消去する)                      |
// | mh_reload()           | よそ見から復帰したときに読んでほしい内容になっている         |
// | mh_setup()            | チャットを開いた瞬間に毎回実行してほしい内容                 |
// | mh_read()             | 新しいメッセージを読み込む                                   |
// | mh_api_params()       | APIに渡すパラメータ                                          |
// | mh_next_process()     | 読み込んだ1フレーム後に毎回行う処理                          |
// | mh_viewpoint_adjust() | (1) スクロール位置を元に戻す                                 |
// | mh_start_or_stop()    | (2) 終わりでなければ監視者を用意する。終わりなら監視者を殺す |
// | mh_head_observe()     | (3) 終わりでなければ次のフレームで最上位を監視する           |
// | mh_safe_start()       | 監視者がいなければ生成する                                   |
// | mh_start()            | 監視者を生成する                                             |
// | mh_visible_changed()  | 表示状態が変化したときに呼ばれる                             |
// | mh_stop()             | 監視者を殺す                                                 |
// | mh_safe_stop()        | 監視者がいれば殺す                                           |
// | mh_page_index_next()  | axios で取得するページ(ブロック)番号を作る                   |
// | mh_seek_pos           | 読み込み位置(初回はnull)                                     |
// | mh_has_next_p         | 次のデータがあるか？                                         |
// | mh_data_exist_p       | 今のデータがあるか？                                         |
// |-----------------------+--------------------------------------------------------------|

import { GX } from "@/components/models/gx.js"
import _ from "lodash"
import { MessageRecord } from "./message_record.js"

const PADDING = 0 // スクロールエリア内の隙間 (px)

export const mod_chat_message_history = {
  data() {
    return {
      mh_page_index: 0,       // 次にリクエストするページ番号
      mh_scroll_height: null, // 古い発言を差し込む直前の高さ
      mh_latest_info: null,   // 最後に取得したデータの内容
      mh_observer: null,      // IntersectionObserver のインスタンス
    }
  },
  beforeDestroy() {
    this.mh_safe_stop()
  },
  methods: {
    //////////////////////////////////////////////////////////////////////////////// フック

    mh_room_entry()   { this.mh_reset_all() }, // 入室直後
    mh_room_leave()   { this.mh_reset_all() }, // 退室直前
    mh_chat_open()    { this.mh_setup()     }, // チャットモーダルを開いたとき
    mh_chat_close()   { this.mh_safe_stop() }, // チャットモーダルを閉じたとき
    mh_window_focus() { this.mh_reload()    }, // よそ見から復帰したとき

    ////////////////////////////////////////////////////////////////////////////////

    // 初期化
    // コンテンツは残す
    mh_reset() {
      this.tl_add("MH", "mh_reset")
      this.mh_safe_stop()

      this.mh_page_index    = 0    // 次にリクエストするページ番号
      this.mh_scroll_height = null // 古い発言を差し込む直前の高さ
      this.mh_latest_info   = null // 最後に取得したデータの内容
    },

    // すべてを初期状態にする
    mh_reset_all() {
      this.tl_add("MH", "mh_reset_all")
      this.mh_reset()
      this.ml_clear()
    },

    // これは特殊ですべてを初期状態して直近の発言をリロードする
    // よそ見から復帰したときに読んでほしい内容になっている
    // 当初は、すでに入っている発言たちは残しておいた方がよいかとケチ臭いことを思っていたが
    // よそ見した時点で、不整合状態になる恐れがあり、そうすると会話が噛み合わなくなるので全部初期化した方がよい
    mh_reload() {
      this.tl_add("MH", "mh_reload")
      if (this.ac_room) {
        this.app_log({emoji: ":チャット履歴:", subject: "よそ見からの復帰", body: `復帰前履歴行数${this.ml_count}件`})
        this.mh_reset_all()       // よそ見した時点で不整合が起きている可能性があるので全リセット
        if (this.ml_root_el()) {  // すでにチャットモーダルを開いてメッセージが見える状態であれば
          this.mh_setup()         // チャットを開いたときに実行する内容を実行する
        } else {
          // チャットモーダルを開いていない
        }
      }
    },

    // チャットを開いた瞬間に毎回実行してほしい内容
    mh_setup() {
      this.tl_add("MH", "mh_setup")
      if (this.mh_enable) {
        if (this.ac_room) {
          if (this.mh_page_index === 0) {
            this.mh_read()
          } else {
            this.mh_next_process()
          }
        }
      }
    },

    // 新しいメッセージを読み込む
    // http://localhost:3000/api/share_board/chat_message_loader?room_key=dev_room&limit=2
    mh_read() {
      this.tl_add("MH", "mh_read")
      this.$axios.$get("/api/share_board/chat_message_loader", {params: this.mh_api_params(), progress: true}).then(e => {
        this.mh_latest_info = e                   // 最後に取得した内容を保持しておく
        this.ml_concat(e.chat_messages)
        this.$nextTick(() => this.mh_next_process())
      })
    },

    // APIに渡すパラメータ
    mh_api_params() {
      GX.assert(GX.present_p(this.room_key), "GX.present_p(this.room_key)")
      GX.assert(GX.present_p(this.user_name), "GX.present_p(this.user_name)")
      GX.assert(this.ac_room != null, "部屋を作成しない状態で部屋の発言履歴を取得しようとしている")

      // link: app/models/share_board/room/chat_message_loader.rb
      return {
        room_key:  this.room_key,                        // 部屋
        limit:      this.mh_per_page, // 件数
        seek_pos:   this.mh_seek_pos,                      // 指定未満を取得する。nil なら最新から取得する。
        // 以下は AppLog のため
        page_index: this.mh_page_index_next(),             // 取得するページ番号 (アクセスカウンタでもある)
        user_name:  this.user_name,                        // 取得しようとした人
      }
    },

    // 読み込んだ1フレーム後に毎回行う処理
    mh_next_process() {
      this.tl_add("MH", "mh_next_process")
      this.mh_viewpoint_adjust()    // スクロール位置を元に戻す
      this.mh_start_or_stop()       // 終わりでなければ監視者を用意する。終わりなら監視者を殺す。
      this.mh_head_observe()        // 終わりでなければ次のフレームで最上位を監視する (スクロール位置を元に戻したあとで)
    },

    // (1) スクロール位置を元に戻す
    mh_viewpoint_adjust() {
      if (this.mh_data_exist_p) {
        if (this.mh_scroll_height == null) {
          // 初回: 0.9 あたりに位置する (これがないと2連続で読み込んでしまう)
          this.ml_scroll_to_bottom()
        } else {
          // 次回: 0.5 あたりに位置する
          this.ml_root_el_block(el => {
            el.scrollTop = el.scrollHeight - this.mh_scroll_height + PADDING
          })
        }
      }
    },

    // (2) 終わりでなければ監視者を用意する。終わりなら監視者を殺す
    mh_start_or_stop() {
      this.tl_add("MH", "mh_start_or_stop")
      if (this.mh_has_next_p) {
        this.mh_safe_start()
      } else {
        this.mh_safe_stop()
      }
    },

    // (3) 終わりでなければ次のフレームで最上位を監視する
    mh_head_observe() {
      this.tl_add("MH", "mh_head_observe")
      if (this.mh_has_next_p) {
        if (this.mh_observer) {
          this.$nextTick(() => {    // 確実に最上位が見えなくなるまで待つため (一応なくても動く)
            if (this.ml_root_el()) {
              const el = document.querySelector(".SbMessageBox .SbAvatarLine:first-child")
              if (el) {
                this.mh_observer.observe(el)
              } else {
                this.tl_add("MH", "チャットメッセージの最上位の要素が存在しません")
              }
            }
          })
        }
      }
    },

    // 監視者がいなければ生成する
    mh_safe_start() {
      this.tl_add("MH", "mh_safe_start")
      if (!this.mh_observer) {
        this.mh_start()
      }
    },

    // 監視者を生成する
    mh_start() {
      this.tl_add("MH", "mh_start")

      this.ml_root_el_block(el => {
        GX.assert(this.mh_observer == null, "this.mh_observer == null")
        const options = {
          root: el,                       // なくても動作に影響なかったが指定しておいたほうが良さそう
          rootMargin: `${PADDING}px 0px`, // CSS と合わせる。これがないと判定もずれる。
          threshold: 1.0,                 // isIntersecting: true とするタイミング。1.0:すべて 0.5:半分 0.0:一瞬
        }

        this.mh_observer = new IntersectionObserver((entries, observer) => {
          GX.assert(entries.length === 1, "entries.length === 1")
          entries.forEach(e => this.mh_visible_changed(observer, e))
        }, options)
        this.clog(this.mh_observer)
      })
    },

    // 表示状態が変化したときに呼ぶ
    mh_visible_changed(observer, e) {
      this.tl_add("MH", "mh_visible_changed")
      this.clog(`${e.target.innerText} ${e.isIntersecting} ${e.intersectionRatio}`)

      // 状態に対応するクラスを付与する
      e.target.classList.toggle("visible_true", e.isIntersecting)   // 見えたら
      e.target.classList.toggle("visible_false", !e.isIntersecting) // 見えなかったら

      // ぜんぶ見えたとき
      if (e.isIntersecting) {
        // もう用はないので解除する
        observer.unobserve(e.target)

        // 差し込む前の領域の高さを保持しておく
        this.ml_root_el_block(el => {
          this.clog(el)
          this.mh_scroll_height = el.scrollHeight

          this.mh_read()
        })
      }
    },

    // 監視者を殺す
    mh_stop() {
      GX.assert(this.mh_observer != null, "this.mh_observer != null") // GX.present_p(this.mh_observer) は false になるので注意
      this.mh_observer.disconnect()
      this.mh_observer = null
      this.tl_add("MH", "this.mh_observer.disconnect()")
    },

    // 監視者がいれば殺す
    mh_safe_stop() {
      if (this.mh_observer) {
        this.mh_stop()
      }
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
    mh_seek_pos()     { return this.mh_latest_info && this.mh_latest_info["next_seek_pos"] }, // 読み込み位置(初回はnull)
    mh_has_next_p()   { return this.mh_latest_info && this.mh_latest_info["has_next_p"]    }, // 次があるか？
    mh_data_exist_p() { return this.mh_latest_info && this.mh_latest_info["data_exist_p"]  }, // 今があるか？
    mh_enable()       { return this.mh_per_page >= 0                                       }, // この機能が有効か？
  },
}
