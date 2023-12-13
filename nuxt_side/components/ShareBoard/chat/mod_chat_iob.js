// チャット発言送信

// import ChatModal from "./ChatModal.vue"
// import { MessageScopeInfo } from "../models/message_scope_info.js"
// import { SendTriggerInfo } from "../models/send_trigger_info.js"
import { Gs } from "@/components/models/gs.js"
import _ from "lodash"
import { MessageDto } from "./message_dto.js"

const LATEST  = 100             // 最新の発言番号
const STEP    = 2               // まとめて読み込む発言数
const PADDING = 0             // スクロールエリア内の隙間 (px)

export const mod_chat_iob = {
  //   <template lang="pug">
  // .App
  //   p iob_flags={{iob_flags}}
  //   p old_scroll_height={{old_scroll_height}}
  //   p seek_pos={{seek_pos}}
  //   p entries_count={{entries_count}}
  //   .SbMessageLog(ref="SbMessageLog")
  //     .iob_row(v-for="iob_row in iob_rows" :key="iob_row") {{iob_row}}
  // </template>
  //
  // <script>
  data() {
    return {
      // seek_pos: LATEST - STEP,  // 読み込んだ最後の位置
      seek_pos: null,  // 読み込んだ最後の位置
      iob_page_seq_id: 0,
      old_scroll_height: null,  // 古い発言を差し込む直前の高さ
      // fetched_data: null,

      // デバッグ用
      iob_flags: {},                // 監視した要素の状態
      entries_count: 0,         // 監視した要素の数 (常に1のはず)
    }
  },
  mounted() {
    // // 発言の最上位(一番古いもの)を監視する
    // this.iob_start()
    //
    // // 一番下にスクロールしておく
    // this.iob_root_el().scrollTop = this.iob_root_el().scrollHeight
    //
    // // スクロール操作の自動化
    // setInterval(() => this.iob_root_el().scrollTop -= 1, 1000 * 0.01)
  },
  beforeDestroy() {
    // 実戦ではコンポーネントを離れるときに解除しておく
    this.iob_stop()
  },
  methods: {
    // 初回だけ呼ぶ
    ml_read_once() {
      if (this.iob_page_seq_id === 0) {
        this.ml_read()
      }
    },

    // 新しいメッセージを読み込む
    ml_read() {
      // http://localhost:3000/api/share_board/chot_message_loader?room_code=dev_room&limit=2

      // link: app/models/share_board/room/chot_message_loader.rb
      const params = {
        room_code:   this.room_code,                        // 部屋
        limit:       this.AppConfig.CHAT_MESSAGES_SIZE_MAX, // 件数
        seek_pos:    this.seek_pos,                         // 指定未満を取得する。nil なら最新から取得する。
        // 以下は AppLog のため
        page_seq_id: this.iob_page_seq_id_next(),           // 取得するページ番号 (アクセスカウンタでもある)
        user_name:   this.user_name,                        // 取得しようとした人
      }

      this.$axios.$get("/api/share_board/chot_message_loader", {params: params}).then(e => {
        console.log(`${this.seek_pos} -> ${e.next_seek_pos}`)
        // this.fetched_data = e
        this.seek_pos = e.next_seek_pos
        this.ml_merge(e.chot_messages)

        // this.$nextTick(() => {
        //   // 最初は一番下にセットする
        //   this.ml_scroll_to_bottom()

        // 次のフレーム
        this.$nextTick(() => {
          // if (Gs.present_p(e.chot_messages)) {
          this.iob_viewpoint_adjust(e)    // スクロール位置を元に戻す
          this.iob_start_or_stop(e)       // 終わりでなければ監視者を用意する。終わりなら監視者を殺す。
          this.iob_observe_next_frame(e)  // 終わりでなければ次のフレームで最上位を監視する
        })

        // this.ml_truncate_and_scroll_to_bottom()
        // this.$nextTick(() => this.ml_scroll_to_bottom())
      })
    },

    // スクロール位置を元に戻す
    iob_viewpoint_adjust(e) {
      if (e.data_exist_p) {
        if (this.old_scroll_height) {
          this.iob_root_el().scrollTop = this.iob_root_el().scrollHeight - this.old_scroll_height + PADDING
        }
      }
    },

    iob_start_or_stop(e) {
      if (e.has_next_p) {
        if (!this.$iob_instance) {
          this.iob_start()
        }
      } else {
        if (this.$iob_instance) {
          this.iob_stop()
        }
      }
    },

    // // 必要なら起動する
    // iob_start_if_need() {
    //   console.log("iob_start_if_need")
    //   if (this.seek_pos != null) {           // 監視したい対象がある
    //     if (!this.$iob_instance) {   // まだ起動していない
    //       console.log("iob_start")
    //       this.iob_start()
    //     }
    //   }
    // },

    iob_start() {
      Gs.assert(Gs.blank_p(this.$iob_instance), "Gs.blank_p(this.$iob_instance)")
      const options = {
        root: this.iob_root_el(),       // なくても動作に影響なかったが指定しておいたほうが良さそう
        rootMargin: `${PADDING}px 0px`, // CSS と合わせる。これがないと判定もずれる。
        threshold: 1.0,                 // isIntersecting: true とするタイミング。1.0:すべて 0.5:半分 0.0:一瞬
      }
      this.$iob_instance = new IntersectionObserver((entries, observer) => {
        this.entries_count = entries.length // 監視対象の数を確認する

        this.iob_flags = {}
        entries.forEach(e => {
          this.iob_flags[e.target.innerText] = e.isIntersecting // 状態確認用
          console.log(`${e.target.innerText} ${e.isIntersecting} ${e.intersectionRatio}`)

          // 状態に対応するクラスを付与する
          e.target.classList.toggle("visible_true", e.isIntersecting)   // 見えたら
          e.target.classList.toggle("visible_false", !e.isIntersecting) // 見えなかったら

          // ぜんぶ見えたとき
          if (e.isIntersecting) {
            // もう用はないので解除する
            observer.unobserve(e.target)

            // 差し込む前の領域の高さを保持しておく
            console.log(this.iob_root_el())
            this.old_scroll_height = this.iob_root_el().scrollHeight

            this.ml_read()

            // // // 過去のコンテンツを STEP 件数読み込む
            // // // (実際はサーバーから読み込んだのを、現在のコンテンツの奥に差し込む感じになる)
            // // this.seek_pos = this.seek_pos - STEP
            // // if (this.seek_pos < 0) {
            // //   this.seek_pos = 0
            // // }
            // //
            // // // もうコンテンツがない場合は監視を止める
            // // // (実際はサーバーから読み込んだコンテンツがそれで最後だった場合)
            // // if (this.seek_pos === 0) {
            // //   this.iob_stop()
            // // }
            //
            // // コンテンツが更新されてからスクロール位置を元に戻す
            // this.$nextTick(() => {
            //   this.iob_root_el().scrollTop = this.iob_root_el().scrollHeight - this.old_scroll_height + PADDING
            //
            //   // スクロール位置を元に戻してから次のフレームで最上位の要素を監視する (順序重要)
            //   this.iob_observe_next_frame()
            // })
          }
        })
      }, options)

      // スクロール位置が一番下まで移動したあとで最上位の要素を監視する
      // this.iob_observe_next_frame()
    },

    // 最上位の要素を監視する
    iob_observe_next_frame(e) {
      if (e.has_next_p) {
        if (this.$iob_instance) {
          this.$nextTick(() => {
            const el = document.querySelector(".SbMessageLog .SbAvatarLine:first-child")
            console.log(el)
            if (el) {
              Gs.assert(el, "el")
              this.$iob_instance.observe(el)
            }
          })
        }
      }
    },

    // 監視をやめる
    iob_stop() {
      if (this.$iob_instance) {
        this.$iob_instance.disconnect()
        this.$iob_instance = null
      }
    },

    iob_root_el() {
      // return this.iob_root_el
      const el = document.querySelector(".SbMessageLog")
      Gs.assert(el, "el")
      return el
    },
    // iob_root_el2() {
    //   const el = this.iob_root_el()
    //   el.scrollTop =
    //
    //   this.iob_root_el.scrollTop = this.iob_root_el.scrollHeight - this.old_scroll_height + PADDING
    //
    //   el.
    //   return document.querySelector(".SbMessageLog")
    // },

    iob_page_seq_id_next() {
      const v = this.iob_page_seq_id
      this.iob_page_seq_id += 1
      return v
    },
  },
  computed: {
    // 表示する発言の配列
    iob_rows() {
      const av = []
      for (let i = this.seek_pos; i <= LATEST; i++) {
        av.push(i)
      }
      return av
    },
  },
}
