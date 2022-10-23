// https://www.studiok-i.net/kifu/?sfen=position%20sfen%20lnsgkgsnl%2F1r5b1%2Fp1pppp1pp%2F1p4p2%2F9%2F2P4P1%2FPP1PPPP1P%2F1B5R1%2FLNSGKGSNL%20b%20-%201&game_name=&sente_name
// https://www.studiok-i.net/ps/?sfen=position%20sfen%20lnsgkgsnl%2F1r5b1%2Fp1pppp1pp%2F1p4p2%2F9%2F2P4P1%2FPP1PPPP1P%2F1B5R1%2FLNSGKGSNL%20b%20-%201

import { Gs2 } from "@/components/models/gs2.js"
import { Gs3 } from "@/components/models/gs3.js"
import { MyMobile } from "@/components/models/my_mobile.js"
import { MyLocalStorage } from "@/components/models/my_local_storage.js"
import { PiyoShogiTypeInfo } from "@/components/models/piyo_shogi_type_info.js"

export class PiyoShogiUtil {
  static cache_clear() {
    this.memo_current_info = null
  }
  static get current_info() {
    if (this.memo_current_info) {
      return this.memo_current_info
    }
    this.memo_current_info = this.__current_info__
    return this.memo_current_info
  }
  static get __current_info__() { // private
    const v = MyLocalStorage.get("user_settings")
    let key = "auto"
    if (v) {
      key = v.piyo_shogi_type_key
    }
    return PiyoShogiTypeInfo.fetch(key)
  }

  static create(params) {
    return new this(params)
  }

  constructor(params) {
    this.params = params
  }

  // app, web 自動切り替え
  // app のとき path があれば kif の URL を渡す
  get url() {
    if (this.native_p) {    // モバイル版
      if (this.params.path) {
        return this.app_url // KIFファイルを渡す方法
      } else {
        return this.web_url // SFENを引数に渡す方法
      }
    } else {
      return this.web_url   // SFENを引数に渡す方法
    }
  }

  //////////////////////////////////////////////////////////////////////////////// private

  // ぴよ将棋はコンテンツを見ているのではなく .kif という拡張子を見ているので format=kif にはできない
  get app_url() {
    // let url = this.params.kif_url
    //
    // if (Gs3.blank_p(url)) {
    //   Gs2.__assert__(this.params.path, "this.params.path")
    //   url = new URL(Gs3.as_full_url(this.params.path))
    //   url.pathname = url.pathname + ".kif" // http://xxx/yyy?zzz=1 --> http://xxx/yyy.kif?zzz=1
    // }
    //
    // const a = {...this.params, url: url}
    //
    // const ordered_keys = ["num", "url"]
    // const ordered_url = this.params_to_url(a, ordered_keys) // 最後を url=xxx.kif にしないと動かない。順序重要。
    // return ordered_url

    Gs2.__assert__(this.params.sfen, "this.params.sfen")
    const ordered_keys = ["viewpoint", "num", "sente_name", "gote_name", "game_name", "sfen"]
    return this.params_to_url(this.params, ordered_keys)
  }

  // app, web 自動切り替え
  // 常にSFENを渡す
  get web_url() {
    Gs2.__assert__(this.params.sfen, "this.params.sfen")
    const ordered_keys = ["viewpoint", "num", "sente_name", "gote_name", "game_name", "sfen"]
    return this.params_to_url(this.params, ordered_keys)
  }

  params_to_url(params, ordered_keys) {
    params = {
      ...params,
      num: params.turn, // turn -> num
    }
    return [this.url_prefix, this.params_to_sorted_query(params, ordered_keys)].join("?")
  }

  params_to_sorted_query(params, ordered_keys) {
    const values = []
    ordered_keys.forEach(e => {
      let v = params[e]
      if (v != null) {
        if (this.native_p) {
          // ぴよ将棋の罠
          // ・アプリ版はエンコードすると読めなくなる
          // ・URLの最後に ".kif" の文字列がないと読めなくなる
        } else {
          v = encodeURIComponent(v)
        }
        values.push([e, v].join("="))
      }
    })
    return values.join("&")
  }

  // モバイル or WEB に合わせたプレフィクス
  get url_prefix() {
    if (this.native_p) {
      return "piyoshogi://"
    } else {
      return "https://www.studiok-i.net/ps/"
    }
  }

  get native_p() {
    return this.constructor.current_info.native_p
  }
}
