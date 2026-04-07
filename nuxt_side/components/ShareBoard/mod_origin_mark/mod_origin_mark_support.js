import { GX } from "@/components/models/gx.js"
import dayjs from "dayjs"
import { OriginMarkReceiveScopeInfo } from "./origin_mark_receive_scope_info.js"
import { OriginMarkSwitchVisibilityInfo } from "./origin_mark_switch_visibility_info.js"

const SS_MARK_COLOR_COUNT   = 12    // shogi-player 側で用意している色数。同名の定数と合わせる。
const PEPPER_DATE_FORMAT    = "-"   // 色が変化するタイミング。毎日なら"YYYY-MM-DD"。空にすると秒単位の時間になるので注意せよ。
const WATCHER_ALWAYS_ENABLE = false // 観戦者なら移動元印を常に有効とするか？
const MOUSE_MAIN_BUTTON     = 0     // マウスの主ボタン

export const mod_origin_mark_support = {
  methods: {
    //////////////////////////////////////////////////////////////////////////////// i_can_origin_mark_send_p と i_can_origin_mark_receive_p が重要

    // 自分はマークできるか？ (送れるか？)
    // マーク自体は役割に関係なく origin_mark_mode_p を有効にすれば送ることができる、とする
    i_can_origin_mark_send_p(event) {

      // // マークモードONならマークできる
      // if (this.play_mode_p && this.origin_mark_mode_p) {
      //   return true
      // }
      //
      // // 誰でも副ボタンを押せばマークできる
      // if (this.play_mode_p && event.button !== MOUSE_MAIN_BUTTON) {
      //   return true
      // }
      //
      // // 観戦者なら常にマークできるとする
      // if (this.play_mode_p && this.origin_mark_watcher_then_always_enable_p) {
      //   return true
      // }
      //
      // return false

      return true
    },

    // 自分は受信できる？
    i_can_origin_mark_receive_p(params) {
      if (this.debug_mode_p) {
        return true
      }

      // 自分から自分は受信できない
      if (!this.received_from_self(params)) {
        return false
      }

      //
      // // 対局設定をしていない状態では誰でも受信できる
      // if (!this.order_enable_p) {
      //   return true
      // }
      //
      // // 対局設定をしている状態では設定に従う
      // if (this.order_enable_p) {
      //   if (this.origin_mark_receive_scope_info._if(this, params)) {
      //     return true
      //   }
      // }
      //
      // return false

      return true
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 全部消す
    // ・単にローカルで全体を消すだけ
    origin_mark_clear_all() {
      this.sp_call(e => e.mut_origin_mark_list.clear())
    },

    ////////////////////////////////////////////////////////////////////////////////

    async origin_mark_toggle_button_click_handle(e = null) {
      this.origin_mark_toggle()
      if (this.origin_mark_mode_p) {
        if (this.DeviseHelper.mouse_click_event_p(e)) {
          await this.toast_primary("ここ押さんでも右クリックで書けるよ")
          await this.toast_primary("でもここを押しとると左クリックで書けるよ")
        }
      }
    },

    origin_mark_toggle_shortcut_handle() {
      this.origin_mark_toggle()
      this.toast_primary(`${this.origin_mark_mode_p ? 'ON' : 'OFF'}`, {talk: false})
    },

    origin_mark_toggle() {
      if (this.origin_mark_mode_p) {
        this.origin_mark_mode_p = false
      } else {
        this.origin_mark_mode_p = true
      }
      this.sfx_play_toggle(this.origin_mark_mode_p)
    },

    // 対局設定反映後、自分の立場に応じてマークモードの初期値を自動で設定する
    origin_mark_auto_set() {
      const before_value = this.origin_mark_mode_p
      // if (!this.origin_mark_mode_global_p) {
      //   return
      // }
      // this.debug_alert("自動印設定")
      // 対局者ならOFF
      if (this.i_am_member_p) {
        this.origin_mark_mode_p = false
      }
      // 観戦者ならON
      if (this.i_am_watcher_p) {
        this.origin_mark_mode_p = true
      }
      // alert(`origin_mark_auto_set: ${this.origin_mark_mode_p}`)
      this.tl_add("移動元印", `(origin_mark_auto_set) origin_mark_mode_p: ${before_value} -> ${this.origin_mark_mode_p}`)
    },
  },
  computed: {
    OriginMarkReceiveScopeInfo()     { return OriginMarkReceiveScopeInfo                                               },
    origin_mark_receive_scope_info() { return this.OriginMarkReceiveScopeInfo.fetch(this.origin_mark_receive_scope_key) },

    OriginMarkSwitchVisibilityInfo()   { return OriginMarkSwitchVisibilityInfo                                    },
    origin_mark_switch_visibility_info() { return this.OriginMarkSwitchVisibilityInfo.fetch(this.origin_mark_switch_visibility_key) },

    origin_mark_watcher_then_always_enable_p() { return WATCHER_ALWAYS_ENABLE && this.i_am_watcher_p }, // 観戦者なら移動元印を常に有効とするか？

    // 現在の利用者の名前に対応する色番号を得る
    origin_mark_color_index() {
      const pepper = dayjs().format(PEPPER_DATE_FORMAT)
      const hash_number = GX.str_to_hash_number([pepper, this.user_name].join("-"))
      return GX.imodulo(hash_number, SS_MARK_COLOR_COUNT)
    },

    // 思考マークモード有効/無効ボタンを表示するか？
    origin_mark_button_show_p() {
      // 編集モードのときは表示しない
      if (this.edit_mode_p) {
        return false
      }

      // 観戦者なら常に有効なのでボタンは表示しない
      if (this.origin_mark_watcher_then_always_enable_p) {
        return false
      }

      // 対局者でかつ表示しないモードのときは表示しない
      if (this.i_am_member_p) {
        if (this.origin_mark_switch_visibility_info.key === "tmsv_hidden") {
          return false
        }
      }

      return true
    },
  },
}
