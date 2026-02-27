import { GX } from "@/components/models/gx.js"
import dayjs from "dayjs"
import { ThinkMarkReceiveScopeInfo } from "./think_mark_receive_scope_info.js"

const SS_MARK_COLOR_COUNT   = 12    // shogi-player 側で用意している色数。同名の定数と合わせる。
const PEPPER_DATE_FORMAT    = "-"   // 色が変化するタイミング。毎日なら"YYYY-MM-DD"。空にすると秒単位の時間になるので注意せよ。
const WATCHER_ALWAYS_ENABLE = false // 観戦者なら思考印を常に有効とするか？
const MOUSE_MAIN_BUTTON     = 0     // マウスの主ボタン

export const mod_think_mark_support = {
  methods: {
    //////////////////////////////////////////////////////////////////////////////// i_can_mark_send_p と i_can_mark_receive_p が重要

    // 自分はマークできるか？ (送れるか？)
    // マーク自体は役割に関係なく think_mark_mode_p を有効にすれば送ることができる、とする
    i_can_mark_send_p(event) {
      // マークモードONならマークできる
      if (this.play_mode_p && this.think_mark_mode_p) {
        return true
      }

      // 誰でも副ボタンを押せばマークできる
      if (this.play_mode_p && event.button !== MOUSE_MAIN_BUTTON) {
        return true
      }

      // 観戦者なら常にマークできるとする
      if (this.play_mode_p && this.think_mark_watcher_then_always_enable_p) {
        return true
      }

      return false
    },

    // 自分は受信できる？
    i_can_mark_receive_p(params) {
      // 自分から自分へは受信できる
      if (this.received_from_self(params)) {
        return true
      }

      // 順番設定をしていない状態では誰でも受信できる
      if (!this.order_enable_p) {
        return true
      }

      // 順番設定をしている状態では設定に従う
      if (this.order_enable_p) {
        if (this.think_mark_receive_scope_info._if(this, params)) {
          return true
        }
      }

      return false
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 全部消す
    // ・単にローカルで全体を消すだけ
    think_mark_all_clear() {
      this.sp_call(e => e.mut_think_mark_list.clear())
    },

    ////////////////////////////////////////////////////////////////////////////////

    async think_mark_toggle_button_click_handle(e = null) {
      // if (!this.think_mark_mode_global_p) {
      //   return
      // }
      if (this.think_mark_mode_p) {
        this.think_mark_mode_p = false
      } else {
        this.think_mark_mode_p = true
      }
      this.sfx_play_toggle(this.think_mark_mode_p)

      if (this.think_mark_mode_p) {
        if (this.DeviseHelper.mouse_click_event_p(e)) {
          await this.toast_primary("ここ押さんでも右クリックで書けるよ")
          await this.toast_primary("でもここを押していると左クリックで書けるよ")
        }
      }
    },

    // 順番設定反映後、自分の立場に応じてマークモードの初期値を自動で設定する
    think_mark_auto_set() {
      const before_value = this.think_mark_mode_p
      // if (!this.think_mark_mode_global_p) {
      //   return
      // }
      // this.debug_alert("自動印設定")
      // 対局者ならOFF
      if (this.i_am_member_p) {
        this.think_mark_mode_p = false
      }
      // 観戦者ならON
      if (this.i_am_watcher_p) {
        this.think_mark_mode_p = true
      }
      // alert(`think_mark_auto_set: ${this.think_mark_mode_p}`)
      this.tl_add("思考印", `(think_mark_auto_set) think_mark_mode_p: ${before_value} -> ${this.think_mark_mode_p}`)
    },
  },
  computed: {
    ThinkMarkReceiveScopeInfo()     { return ThinkMarkReceiveScopeInfo                                               },
    think_mark_receive_scope_info() { return this.ThinkMarkReceiveScopeInfo.fetch(this.think_mark_receive_scope_key) },

    think_mark_watcher_then_always_enable_p() { return WATCHER_ALWAYS_ENABLE && this.i_am_watcher_p }, // 観戦者なら思考印を常に有効とするか？

    // 現在の利用者の名前に対応する色番号を得る
    mark_color_index() {
      const pepper = dayjs().format(PEPPER_DATE_FORMAT)
      const hash_number = GX.str_to_hash_number([pepper, this.user_name].join("-"))
      return GX.imodulo(hash_number, SS_MARK_COLOR_COUNT)
    },

    // 思考マークモード有効/無効ボタンを表示するか？
    think_mark_button_show_p() {
      // 観戦者なら常に有効なのでボタンは表示しない
      if (this.think_mark_watcher_then_always_enable_p) {
        return false
      }

      if (this.play_mode_p) {
        // if (!this.think_mark_mode_global_p) {
        //   return false
        // }
        return true
      }
      return false
    },

    // 当初は単に pencil と pencil-circle-outline を切り替えるのようにしていたが円付きになると
    // 中のペンの大きさが変わって非常に違和感があったため、pencil は表示したままで自力で円を重ねる方法に変更した
    think_mark_button_icon() {
      return "pencil"
    },
  },
}
