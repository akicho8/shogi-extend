// チャット発言送信

// import ChatModal from "./ChatModal.vue"
// import { MessageScopeInfo } from "../models/message_scope_info.js"
// import { SendTriggerInfo } from "../models/send_trigger_info.js"
import { Gs } from "@/components/models/gs.js"
import _ from "lodash"
// import { MessageDto } from "./message_dto.js"

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
      seek_pos: LATEST - STEP,  // 読み込んだ最後の位置
      old_scroll_height: null,  // 古い発言を差し込む直前の高さ

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
    // this.iob_stop()
  },
  methods: {
    // 発言の最上位(一番古いもの)を監視する
    iob_start() {
      this.iob_stop()
      this.$chat_observer_object = new IntersectionObserver((entries, observer) => {
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

            // 過去のコンテンツを STEP 件数読み込む
            // (実際はサーバーから読み込んだのを、現在のコンテンツの奥に差し込む感じになる)
            this.seek_pos = this.seek_pos - STEP
            if (this.seek_pos < 0) {
              this.seek_pos = 0
            }

            // もうコンテンツがない場合は監視を止める
            // (実際はサーバーから読み込んだコンテンツがそれで最後だった場合)
            if (this.seek_pos === 0) {
              this.iob_stop()
            }

            // コンテンツが更新されてからスクロール位置を元に戻す
            this.$nextTick(() => {
              this.iob_root_el().scrollTop = this.iob_root_el().scrollHeight - this.old_scroll_height + PADDING

              // スクロール位置を元に戻してから次のフレームで最上位の要素を監視する (順序重要)
              this.iob_observe()
            })
          }
        })
      }, {
        root: this.iob_root_el(), // なくても動作に影響なかったが指定しておいたほうが良さそう
        rootMargin: `${PADDING}px 0px`,          // CSS と合わせる。これがないと判定もずれる。
        threshold: 1.0,                          // isIntersecting: true とするタイミング。1.0:すべて 0.5:半分 0.0:一瞬
      })

      // スクロール位置が一番下まで移動したあとで最上位の要素を監視する
      this.iob_observe()
    },

    // 最上位の要素を監視する
    iob_observe() {
      if (this.$chat_observer_object) {
        this.$nextTick(() => {
          this.$chat_observer_object.observe(document.querySelector(".SbAvatarLine:first-child"))
        })
      }
    },

    // 監視をやめる
    iob_stop() {
      if (this.$chat_observer_object) {
        this.$chat_observer_object.disconnect()
        this.$chat_observer_object = null
      }
    },

    iob_root_el() {
      // return this.iob_root_el
      return document.querySelector(".SbMessageLog")
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
